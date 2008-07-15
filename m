Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbYGOCVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbYGOCVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbYGOCVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:21:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:23745 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYGOCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NQU1NsAUnNpRyZLaW+xuaLaZlGv2IB2ekQHax6HexhfI2CEpwbbiXoxpi0Z0seUDnE
         5fBiW54HJ30nijmSTcgVtbfjJyXC6vvPECdBC+3rUEhQL6h+Ky9AqKSh6YH2TeQojSNC
         Al7NsT+z5nSt78GzLaC4ycLxY2ko4VZXzyZmI=
Message-ID: <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com>
Date: Tue, 15 Jul 2008 04:21:10 +0200
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
In-Reply-To: <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com>
	 <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org>
	 <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com>
	 <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Tue, 15 Jul 2008, Dmitry Adamushko wrote:
>>
>> The 'synchronization' point occurs even earlier - when cpu_down() ->
>> __stop_machine_run() gets called (as I described in my previous mail).
>>
>> My point was that if it's ok to have a _delayed_ synchronization
>> point, having it not immediately after cpu_clear(cpu, cpu_active_map)
>> but when the "runqueue lock" is taken a bit later (as you pointed out
>> above) or __stop_machine_run() gets executed (which is a sync point,
>> scheduling-wise),
>>
>> then we can implement the proper synchronization (hotplugging vs.
>> task-migration) with cpu_online_map (no need for cpu_active_map).
>
> [ ... ]
>
> In particular, it should tell you that the code is too hard to follow, and
> too fragile, and a total mess.
>
> I do NOT understand why you seem to argue for being "subtle" and "clever",
> considering the history of this whole setup. Subtle and clever and complex
> is what got us to the crap situation.

Fair enough, agreed.


>
>                Linus
>

-- 
Best regards,
Dmitry Adamushko
