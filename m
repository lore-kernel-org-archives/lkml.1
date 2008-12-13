Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbYLMS6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbYLMS6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYLMS60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:58:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40885 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbYLMS60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:58:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Date: Sat, 13 Dec 2008 19:56:02 +0100
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera> <T1gm2CtAHBF.A.bnH.14_QJB@chimera> <b637ec0b0812131045n34bf420w3729abf24533b51c@mail.gmail.com>
In-Reply-To: <b637ec0b0812131045n34bf420w3729abf24533b51c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812131956.03495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 13 of December 2008, Fabio Comolli wrote:
> Hi.

Hi,

> On Sat, Dec 13, 2008 at 5:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12155
> > Subject         : Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
> > Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> > Date            : 2008-11-23 16:17 (21 days old)
> > References      : http://marc.info/?l=linux-kernel&m=122745709926361&w=4
> 
> Still present. It has been bisected to:
> 
> ---------------------------------------------------------------------------------------------------------------
> commit 5e55aa8db085dad1aabb4574c73c23c7ae571e7b
> Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Date:   Sun Oct 26 18:20:14 2008 -0400
> 
>     sched_clock: prevent scd->clock from moving backwards
> 
>     commit 5b7dba4ff834259a5623e03a565748704a8fe449 upstream
> 
>     sched_clock: prevent scd->clock from moving backwards
> 
>     When sched_clock_cpu() couples the clocks between two cpus, it may
>     increment scd->clock beyond the GTOD tick window that __update_sched_clock()
>     uses to clamp the clock.  A later call to __update_sched_clock() may move
>     the clock back to scd->tick_gtod + TICK_NSEC, violating the clock's
>     monotonic property.
> 
>     This patch ensures that scd->clock will not be set backward.
> 
>     Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>     Cc: Chuck Ebbert <cebbert@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ------------------------------------------------------------------------------------------------------------
> 
> Both 2.6.27.8 and 2.6.28-rc8 with that commit reverted work fine
> (well, at least they failed to show the bug so far).

Thanks for the update, I have put this information into the Bugzilla entry.

Would everyone involved agree with reverting the above commit for now and
revisiting the issue in the 2.6.29 time frame?

Rafael


