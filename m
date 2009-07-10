Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZGJSNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZGJSNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZGJSNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:13:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZGJSNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:13:47 -0400
Subject: Re: [PATCH] sched: Move the sleeping while atomic checks early in
 cond_resched()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090710180801.GA5271@nowhere>
References: <20090710161034.GB22049@elte.hu>
	 <1247246098-5627-1-git-send-email-fweisbec@gmail.com>
	 <1247247810.6042.5.camel@laptop>  <20090710180801.GA5271@nowhere>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 20:13:42 +0200
Message-Id: <1247249622.6042.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 20:08 +0200, Frederic Weisbecker wrote:

> > Right, how about renaming these to _cond_resched_{lock,softirq}, and
> > added a __might_sleep() definition for !DEBUG_SPINLOCK_SLEEP and add
> > macro wrappers to sched.c for these two as well?
> 
> I did that first but thought that might_sleep() would fail in a spinlock
> held or softirq context, right?

Ah, right.. maybe we can add a preempt_count_offset parameter to
__might_sleep() such that it will compensate for the pending
spin_unlock()/local_bh_enable().



