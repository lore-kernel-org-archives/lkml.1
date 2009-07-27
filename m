Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZG0H64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZG0H64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZG0H6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:58:55 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:36636 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZG0H6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:58:54 -0400
Date: Mon, 27 Jul 2009 09:58:41 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Fred Fan <fanyefeng@gmail.com>
Cc: cocala <syy.wxd@gmail.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       rick.jones2@hp.com, gallatin@myri.com, akpm@linux-foundation.org,
       dada1@cosmosbay.com, brice@myri.com, paulus@samba.org,
       benh@kernel.crashing.org, mingo@elte.hu, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: inaccurate cpu idle time from top command
Message-ID: <20090727095841.7a584c4f@skybase>
In-Reply-To: <2f495dc80907252034i4bdd812cx2267d65af7d993d8@mail.gmail.com>
References: <458a17f90907240745m15c3d7ep893a01a035bf0146@mail.gmail.com>
	<2f495dc80907252034i4bdd812cx2267d65af7d993d8@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009 11:34:02 +0800
Fred Fan <fanyefeng@gmail.com> wrote:

> Hi cocala:
>     I have met same issue. And we found the total utilization
> count(added by idle's utilization) is not 100% in detail processes
> information fields.
>    best Regards
> Fred
> 
> 2009/7/24 cocala <syy.wxd@gmail.com>:
> > I saw one commit "3209ada8285a9fa6ab8f7a731d54031ec884c745 - sched: account
> > system time properly"
> > This commit is to take into account timer IRQ interrupting the idle task
> > servicing a hard or soft irq.
> >
> > If a softirq is started in a tick, all the time in the tick will be counted
> > as soft irq time even most time in the tick is idle.
> > In our use case, one jiffy is 10ms and the 1G net driver will generate many
> > software irq, so the "top" command will show high softare irq time and cpu
> > idle time approaches to zero.
> > If I change the jiffy to 1ms, the "top" command shows much higher cpu idle
> > time. I think this algorithm is also not fair for some cases.
> >
> > Is there any better way to count the softare irq time?
> >
> > Thanks
> > cocala

There is a solution to this problem but not all architectures have
implemented it. Currently only s390, powerpc and ia64 have defined
CONFIG_VIRT_CPU_ACCOUNTING which allows the architecture backend to do
its own, precise math. The backdraw of the improved accounting is
i) some complicated code, and ii) a slight performance penalty. So far
nobody wanted to implement it for x86.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

