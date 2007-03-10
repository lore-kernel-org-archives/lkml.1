Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbXCJX1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbXCJX1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 18:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXCJX1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 18:27:07 -0500
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:33886 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400AbXCJX1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 18:27:06 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: RSDL v0.28 for 2.6.20
Date: Sun, 11 Mar 2007 10:54:42 +1100
User-Agent: KMail/1.9.5
Cc: Stephen Clark <Stephen.Clark@seclark.us>, ck list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200703101845.59497.kernel@kolivas.org> <45F2F45F.6000403@seclark.us> <20070310191118.GL943@1wt.eu>
In-Reply-To: <20070310191118.GL943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111054.42921.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 06:11, Willy Tarreau wrote:
> On Sat, Mar 10, 2007 at 01:09:35PM -0500, Stephen Clark wrote:
> > Con Kolivas wrote:
> > >Here is an update for RSDL to version 0.28
> > >
> > >Full patch:
> > >http://ck.kolivas.org/patches/staircase-deadline/2.6.20-sched-rsdl-0.28.
> > >patch
> > >
> > >Series:
> > >http://ck.kolivas.org/patches/staircase-deadline/2.6.20/
> > >
> > >The patch to get you from 0.26 to 0.28:
> > >http://ck.kolivas.org/patches/staircase-deadline/2.6.20/sched-rsdl-0.26-
> > >0.28.patch
> > >
> > >A similar patch and directories will be made for 2.6.21-rc3 without
> > >further announcement
> >
> > doesn't apply against 2.6.20.2:
> >
> > patch -p1 <~/2.6.20-sched-rsdl-0.28.patch --dry-run
> > patching file include/linux/list.h
> > patching file fs/proc/array.c
> > patching file fs/pipe.c
> > patching file include/linux/sched.h
> > patching file include/asm-generic/bitops/sched.h
> > patching file include/asm-s390/bitops.h
> > patching file kernel/sched.c
> > Hunk #41 FAILED at 3531.
> > 1 out of 62 hunks FAILED -- saving rejects to file kernel/sched.c.rej
> > patching file include/linux/init_task.h
> > patching file Documentation/sched-design.txt
>
> It is easier to apply 2.6.20.2 on top of 2.6.20+RSDL. The .2 patch
> is a one-liner that you can easily fix by hand, and I'm not even
> certain that it is still required :
>
> --- ./kernel/sched.c.orig	2007-03-10 13:03:51 +0100
> +++ ./kernel/sched.c	2007-03-10 13:08:02 +0100
> @@ -3544,7 +3544,7 @@
>  		next = list_entry(queue->next, struct task_struct, run_list);
>  	}
>
> -	if (dependent_sleeper(cpu, rq, next))
> +	if (rq->nr_running == 1 && dependent_sleeper(cpu, rq, next))
>  		next = rq->idle;
>  switch_tasks:
>  	if (next == rq->idle)
>
> BTW, Con, I think that you should base your work on 2.6.20.[23] and not
> 2.6.20 next time, due to this conflict. It will get wider adoption.

Gotcha. This bugfix for 2.6.20.2 was controversial anyway so it probably wont 
hurt if you dont apply it.

Has anyone had any trouble with RSDL on the stable kernels (ie not -mm)?

-- 
-ck
