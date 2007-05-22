Return-Path: <linux-kernel-owner+w=401wt.eu-S966557AbXEVTDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966557AbXEVTDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbXEVTDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:03:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:4191 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXEVTDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:03:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CEpdRm9aeSv4egHtnQBRgfAfw+w0oGnkIMzTNmM5R9mezIbtrFH7eGVtuZovKcCRKyRlxI/qJ5BtHKgTfGYWPvE90L2b7jiXmsJnNHO1mckFhG0agjGa9iWDvb+JmeM06/oK7qRR4IQNYs4rmJsDTU8uK6w3Fy2ouCzJuJ/ITys=
Message-ID: <6bffcb0e0705221203s1ba21ed3j641e91036859db7d@mail.gmail.com>
Date: Tue, 22 May 2007 21:03:43 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [BUG] local_softirq_pending storm
Cc: "Anant Nitya" <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1179697388.6570.26.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705091942.22920.kernel@prachanda.hub>
	 <200705191525.28400.kernel@prachanda.hub>
	 <1179601868.12981.127.camel@chaos>
	 <200705200253.44992.kernel@prachanda.hub>
	 <1179697388.6570.26.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 20/05/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 2007-05-20 at 02:53 +0530, Anant Nitya wrote:
> > > 1 == TASK_INTERRUPTIBLE, so we know that ksoftirqd was not woken up. At
> > > least it is not a scheduler problem.
> > >
> > > I work out a more complex debug patch and pester you to test once I'm
> > > done.
> > No problem :)
>
> You asked for it :)
>
> Please patch 2.6.22-rc2 with
>
> http://tglx.de/projects/hrtimers/2.6.22-rc2/patch-2.6.22-rc2-hrt2.patch
> and
> http://www.tglx.de/private/tglx/ht-debug/tracer.diff
>
> Compile it with the config
>
> http://www.tglx.de/private/tglx/ht-debug/config.debug
>
> You should find something like:
>
> (         swapper-0    |#0): new 67173 us user-latency.
>
> along with the familiar "NOHZ ......" message in your log file.
>
> Once that happened please do:
>
> $ cat /proc/latency_trace >trace.txt
>
> compress it and send it to me along with the full dmesg output or put
> both up to some place, where I can download it.
>
> Michal,
>
> IIRC you encountered the same P4/HT related wreckage. Can you do the
> same ?

Good news - I can't reproduce this bug. It's time to remove
"Subject    : 2.6.21-git4 BUG: soft lockup detected on CPU#1!
References : http://lkml.org/lkml/2007/5/2/511
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged"
from KR.

Bad news - I hit a bug in 2.6.22-rc2-hrt3. Bug symptoms:
- X hangs (keyboard, mouse, sound etc.)
- only Magic SysRq works

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc2-hrt3/hrt-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc2-hrt3/hrt-console.log

Now I'm trying to apply hrtimers debug patch ontop 2.6.22-rc2-hrt3
http://lkml.org/lkml/2007/3/23/106

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
