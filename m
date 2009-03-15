Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbZCOGsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbZCOGsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 02:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZCOGsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 02:48:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45252 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbZCOGsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 02:48:09 -0400
Date: Sun, 15 Mar 2009 07:48:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: some ARM fixes for 2.6.29-rc7-rt1
Message-ID: <20090315064803.GB6982@pengutronix.de>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <20090313010458.GB1192@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090313010458.GB1192@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 13, 2009 at 02:04:58AM +0100, Uwe Kleine-König wrote:
> on top of 2.6.29-rc7-rc1 I did some ARM related fixes that you can find
> at
> 
> 	git://git.pengutronix.de/git/ukl/linux-2.6.git v2.6.29-rc7-rt1-pu
> 
> The top commit currently isn't pretty as it contains several independant
> fixes.  Some of them are netX specific so you probably don't need them,
> but they shouldn't hurt you either.
> 
> I will update this branch as I continue working in a non-fast-forward
> manner.  I use TopGit to manage this branch, you might want to use it,
> too, if you intend to follow my work.
> 
> My status quo is:
> 
> 	Testing tracer sched_switch: PASSED
> 	Testing tracer function: PASSED
> 	Testing tracer irqsoff: .. no entries found ..FAILED!
> 	Testing tracer preemptoff: .. no entries found ..FAILED!
> 	Testing tracer preemptirqsoff: .. no entries found ..
[removed stack dump]
> 	FAILED!
I still have this problem.  I digged into irqsoff without finding the reason.

Looking at trace_selftest_startup_irqsoff I saw that
trace_buffer_lock_reserve is called thrice successfully.

Steven (or someone else of course), do you can give me a hint?

> Other than that my machine boots and reports from time to time
> 
> 	scheduling while atomic
> 
> and
> 
> 	sleeping function called from invalid context at kernel/rtmutex.c:683
> 
> Both errors probably happen because some spin_locks need to be converted
> to raw_spin_locks.  Will look later.
Up to now I didn't try to do much with my system, but just booting
doesn't yield such BUGs or Warnings anymore.
 
Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
