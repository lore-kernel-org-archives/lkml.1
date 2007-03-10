Return-Path: <linux-kernel-owner+w=401wt.eu-S1751360AbXCJTLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbXCJTLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXCJTLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:11:39 -0500
Received: from 1wt.eu ([62.212.114.60]:1110 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbXCJTLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:11:38 -0500
Date: Sat, 10 Mar 2007 20:11:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: Stephen Clark <Stephen.Clark@seclark.us>
Cc: Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: RSDL v0.28 for 2.6.20
Message-ID: <20070310191118.GL943@1wt.eu>
References: <200703101845.59497.kernel@kolivas.org> <45F2F45F.6000403@seclark.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F2F45F.6000403@seclark.us>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 01:09:35PM -0500, Stephen Clark wrote:
> Con Kolivas wrote:
> 
> >Here is an update for RSDL to version 0.28
> >
> >Full patch:
> >http://ck.kolivas.org/patches/staircase-deadline/2.6.20-sched-rsdl-0.28.patch
> >
> >Series:
> >http://ck.kolivas.org/patches/staircase-deadline/2.6.20/
> >
> >The patch to get you from 0.26 to 0.28:
> >http://ck.kolivas.org/patches/staircase-deadline/2.6.20/sched-rsdl-0.26-0.28.patch
> >
> >A similar patch and directories will be made for 2.6.21-rc3 without 
> >further announcement
> >
> > 
> >
> doesn't apply against 2.6.20.2:
> 
> patch -p1 <~/2.6.20-sched-rsdl-0.28.patch --dry-run
> patching file include/linux/list.h
> patching file fs/proc/array.c
> patching file fs/pipe.c
> patching file include/linux/sched.h
> patching file include/asm-generic/bitops/sched.h
> patching file include/asm-s390/bitops.h
> patching file kernel/sched.c
> Hunk #41 FAILED at 3531.
> 1 out of 62 hunks FAILED -- saving rejects to file kernel/sched.c.rej
> patching file include/linux/init_task.h
> patching file Documentation/sched-design.txt

It is easier to apply 2.6.20.2 on top of 2.6.20+RSDL. The .2 patch
is a one-liner that you can easily fix by hand, and I'm not even
certain that it is still required :

--- ./kernel/sched.c.orig	2007-03-10 13:03:51 +0100
+++ ./kernel/sched.c	2007-03-10 13:08:02 +0100
@@ -3544,7 +3544,7 @@
 		next = list_entry(queue->next, struct task_struct, run_list);
 	}
 
-	if (dependent_sleeper(cpu, rq, next))
+	if (rq->nr_running == 1 && dependent_sleeper(cpu, rq, next))
 		next = rq->idle;
 switch_tasks:
 	if (next == rq->idle)

BTW, Con, I think that you should base your work on 2.6.20.[23] and not
2.6.20 next time, due to this conflict. It will get wider adoption.

Regards,
Willy

