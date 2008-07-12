Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYGLXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYGLXZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYGLXZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:25:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:4095 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYGLXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MsX9Rd+TrGNGxynaY0rWcwcCQ3RqP1ek8AEC3co1zw769hBbI3TYUlGrvlcxdc1sYK
         vAaeqJkYbVOOADyCFqZxNy+FX7R25ix/BVNZnLGB8zs5SeJawrvPXiScn0thNaSKKGp9
         ikcH/SmNsBpdIC9MhMfDTpx2r8A/o5XqsANk8=
Message-ID: <b647ffbd0807121625n2a9ffc16rd17d2b393ef8506e@mail.gmail.com>
Date: Sun, 13 Jul 2008 01:25:39 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0807121619r15c2864fw5b0ff592ba8edbd2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
	 <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
	 <alpine.LFD.1.10.0807121603150.2959@woody.linux-foundation.org>
	 <b647ffbd0807121619r15c2864fw5b0ff592ba8edbd2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/13 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> 2008/7/13 Linus Torvalds <torvalds@linux-foundation.org>:
>>
>>> (A little pet horse for the occasion: Testing can show the presence of
>>> errors, but not their absence. But that's a different story.)
>>
>> Absolutely. Which is actually why I prefer my patch. I think it fixes - in
>> general - the issue of CPU migration migrating tasks back to the CPU that
>> we're taking down.
>>
>> The other patches seem to work around just the problem that _triggers_ the
>> bug. They don't actually make it impossible to migrate to a CPU that is
>> getting shut down - they just try to avoid the particular sequence that
>> made it happen for you.
>
> Well, they try to make sched-domains consistent for all possible
> cases, not just any particular case. So no, they don't allow a
> possibility to leave tasks on a dead CPU (unless there is another
> bug).
>
> With your patch (and a cpusets :: hotplug handler from the current
> -git) sched-domains are still broken and they are used in a number of
> places. So why keep them at all?
>
> I'm really surprised that Vegard says this "cpu_active_map" patch
> alone fixes the problem.
>
> With your modifications of common_cpu_mem_hotplug_unplug() - yes

No, not even with your modifications of common_mem_hotplug_unplug().

-       if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+       if (phase == CPU_DYING || phase == CPU_DYING_FROZEN ||
+           phase == CPU_UP_PREPARE || phase == CPU_UP_PREPARE_FROZEN)
               return NOTIFY_DONE;

You should have added "phase == CPU_DOWN_PREPARE || phase ==
CPU_DOWN_PREPARE_FROZEN" additionally. So I'm really surprised by
Vegard's assertion :-)


 but
> then it will work even without "cpu_active_map".
>
> (ok, unless I'm really blind at this late hour so please direct me to
> the right way :-)
>
>
>>
>>                        Linus
>>
>
>
> --
> Best regards,
> Dmitry Adamushko
>



-- 
Best regards,
Dmitry Adamushko
