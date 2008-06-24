Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYFXKia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYFXKia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYFXKiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:38:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47566 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYFXKiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:38:19 -0400
Subject: Re: [PATCH 2/3] sched: only run newidle if previous task was CFS
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       dbahi@novell.com
In-Reply-To: <1214301517.4351.12.camel@twins>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
	 <20080623230445.31515.41728.stgit@lsg.lsg.lab.novell.com>
	 <1214301517.4351.12.camel@twins>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 12:38:08 +0200
Message-Id: <1214303888.4351.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 11:58 +0200, Peter Zijlstra wrote:
> On Mon, 2008-06-23 at 17:04 -0600, Gregory Haskins wrote:
> > A system that tends to overschedule (such as PREEMPT_RT) will naturally
> > tend to newidle balance often as well.  This may have quite a negative
> > impact on performance.  This patch attempts to address the overzealous
> > newidle balancing by only allowing it to occur if the previous task
> > was SCHED_OTHER.
> > 
> > Some may argue that if the system is going idle, it should try to
> > newidle balance to keep it doing useful work.  But the fact is that
> > spending too much time in the load-balancing code demonstrably hurts
> > performance as well.  Running oprofile on the system with various
> > workloads has shown that we can sometimes spend a majority of our
> > cpu-time running load_balance_newidle.  Additionally, disabling
> > newidle balancing can make said workloads increase in performance by
> > up to 200%.  Obviously disabling the feature outright is not sustainable,
> > but hopefully we can make it smarter. 
> > 
> > This code assumes that if there arent any CFS tasks present on the queue,
> > it was probably already balanced.
> > 
> > Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> 
> NAK, this wrecks idle balance for any potential other classes.
> 
> idle_balance() is the generical hook - as can be seen from the class
> iteration in move_tasks().
> 
> I can imagine paritioned EDF wanting to make use of these hooks to
> balance the reservations.

Hmm, it wouldn't,.. since its too tied in with fbg which is sched_other
based,..

would need more generalization work,..



