Return-Path: <linux-kernel-owner+w=401wt.eu-S1762906AbYCDLMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906AbYCDLMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbYCDLMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:12:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbYCDLME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:12:04 -0500
Subject: Re: SCHED_IDLE documentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@lst.de>, cbe-oss-dev@ozlabs.org,
       Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org
In-Reply-To: <cfd18e0f0803030606v7ba30121k19f2e90c595451d8@mail.gmail.com>
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
	 <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu>
	 <cfd18e0f0803030431n69df391dw53843d5079d906dd@mail.gmail.com>
	 <20080303125227.GA22160@elte.hu>
	 <cfd18e0f0803030606v7ba30121k19f2e90c595451d8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:11:44 +0100
Message-Id: <1204629104.6241.49.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-03 at 15:06 +0100, Michael Kerrisk wrote:
> Ingo,
> 
> On Mon, Mar 3, 2008 at 1:52 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
> >
> >
> > > > > * What's the difference between SCHED_IDLE and SCHED_BATCH?
> >  > >
> >  > > SCHED_BATCH can still have nice levels from -20 to +19, it is a
> >  > > modified SCHED_OTHER/SCHED_NORMAL for "throughput oriented"
> >  > > workloads.
> >  >
> >  > So, suppose we have two CPU intensive jobs, one SCHED_OTHER and the
> >  > other SCHED_BATCH.  If they have the same nice value, will/should the
> >  > scheduler favour one over the other?
> >
> >  yes - SCHED_BATCH does not modify the CPU usage proportion for
> >  CPU-intense tasks, it's their nice value that controls the proportion.
> >  What it will influence is wakeup behavior - i.e. wakeup-intense
> >  workloads should schedule less with SCHED_BATCH. (but how that is done
> >  is really fluid and will probably tweaked in the future.)
> >
> >         Ingo
> 
> So, I've tweaked the description of SCHED_BATCH in the
> sched_setscheduler.2 man page, and added some text describing
> SCHED_IDLE.  Relevant excepts below.  Does his look okay to you?
> 
>        SCHED_OTHER is the default universal time-sharing  sched-
>        uler  policy  used  by  most  processes.   SCHED_BATCH is
>        intended  for  "batch"  style  execution  of   processes.
>        SCHED_IDLE  is  intended  for  running  very low priority
>        background jobs.  SCHED_FIFO and  SCHED_RR  are  intended
>        for  special time-critical applications that need precise
>        control over the way  in  which  runnable  processes  are
>        selected for execution.
> 
>        Processes  scheduled  with  SCHED_OTHER,  SCHED_BATCH, or
>        SCHED_IDLE must be assigned the static priority 0.   Pro-
>        cesses  scheduled under SCHED_FIFO or SCHED_RR can have a
>        static priority in the range 1 to 99.
>        ...
> 
>    SCHED_BATCH: Scheduling batch processes
>        (Since Linux 2.6.16.)  SCHED_BATCH can only  be  used  at
>        static   priority   0.    This   policy   is  similar  to
>        SCHED_OTHER, except that it will cause the  scheduler  to
>        always  assume that the process is CPU-intensive.  Conse-
>        quently, the scheduler  will  apply  a  small  scheduling
>        penalty  with  respect  to wakeup behaviour, so that this
>        process is mildly  disfavored  in  scheduling  decisions.
>        This policy is useful for workloads that are non-interac-
>        tive, but do not want to lower their nice value, and  for
>        workloads  that  want  a  deterministic scheduling policy
>        without interactivity causing extra preemptions  (between
>        the workload's tasks).
> 
>    SCHED_IDLE: Scheduling very low priority jobs
>        (Since  Linux  2.6.23.)   SCHED_IDLE  can only be used at
>        static priority 0; the process nice value has  no  influ-
>        ence  for  this policy.  This policy is intended for run-
>        ning jobs at extremely low priority (lower  even  than  a
>        +19  nice value with the SCHED_OTHER or SCHED_BATCH poli-
>        cies).

Your SCHED_BATCH and SCHED_IDLE descriptions seem at odds, in that your
SCHED_IDLE description says you can run SCHED_BATCH +19, however your
SCHED_BATCH description says you can only run at nice 0.

To clarify SCHED_BATCH _can_ indeed use the full nice range.


