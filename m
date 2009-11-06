Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbZKFM42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbZKFM42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 07:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbZKFM42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 07:56:28 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:59069 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbZKFM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 07:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ww3O+YVpyM09tk7oB2XGsgXQXniABlY5xV/B5iKzVXjj4LDsAP3qbJBBqC5FZ6a580
         8TqZu+LXRadYP742H7HUi1tR+AL/iWpLbNQN6T9lCqPOTSmr3DxlzalThNZ3ebj8i85C
         ifpJykZGbyPuiGobTyXY6QmHmcDNSdfWP4fJU=
MIME-Version: 1.0
In-Reply-To: <20091106123403.GB18592@alberich.amd.com>
References: <1257192496.5941.8.camel@dimm>
	 <20091105153742.GA18592@alberich.amd.com>
	 <b647ffbd0911051040r3987f63es1279c87bf349bcf6@mail.gmail.com>
	 <20091106123403.GB18592@alberich.amd.com>
Date: Fri, 6 Nov 2009 13:56:31 +0100
Message-ID: <b647ffbd0911060456x5c37ebfapdb2ece392428f66@mail.gmail.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode output 
	messages
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/6 Andreas Herrmann <herrmann.der.user@googlemail.com>:
>>> [ ... ]
>> >  ...
>> >  microcode: CPU0-1,3: patch_level=0x1000083
>>
>> before or after loading a module? CPU2 is down, isn't it?
>
> No, no CPU was offline at this moment. They all were brought back
> online after some CPU hotplug and/or suspend/resume tests.
>
>> >  microcode: CPU2-3: patch_level=0x1000065
>
> Both messages showed up after same ucode-update process.
>
>> same question as above.
>
> Same answer as above all CPUs are online.
>
>> Here, either CPUs 0 and 1 are down or have a
>> different version. Both above messages don't make sense taken together
>
> See, and that's the problem.
>
>> (CPU3 belongs to both sets) unless summarize_cpu_info() is utterly
>> broken.
>
> I didn't check that yet.

Yeah, this behavior is likely due to a missing cpumask_clear() in
summarize_cpu_info().

should be as follows:

      if (!alloc_cpumask_var(&cpulist, GFP_KERNEL))
              return;

+    cpumask_clear(cpulist);

>> sure, my test is somewhat limited... anyway, first of all I'd like to
>> get a clear understanding of your logs. Thanks for yout test btw. :-))
>
> I'll send you full logs asap.

Thanks. Maybe it's something about a particular sequence of actions
that triggers this behavior. Or was it reproducible with the very
first pm-suspend invocation after "modprobe microcode.ko"?


>
> Regards,
> Andreas
>

-- Dmitry
