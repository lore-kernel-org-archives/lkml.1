Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbZFOPTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbZFOPTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZFOPTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:19:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbZFOPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:19:33 -0400
Date: Mon, 15 Jun 2009 17:19:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Debug bits for the tty ldisc problem
Message-ID: <20090615151918.GA27094@elte.hu>
References: <20090615153015.4036.76588.stgit@t61.ukuu.org.uk> <1245076796.6800.488.camel@laptop> <20090615161439.507fb04b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615161439.507fb04b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Mon, 15 Jun 2009 16:39:56 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2009-06-15 at 16:32 +0100, Alan Cox wrote:
> > > I'm not 100% sure the close one is
> > > safe for locking but as the lock detector has been busted since 2.6.30 its a
> > > bit hard to be sure.
> > 
> > Would you have some specifics?
> 
> I stuck it in bugzilla basically it blows up with a 
> 
> BUG: MAX_STACK_TRACE_ENTRIES too low! turning off the locking 
> correctness validator.
> 
> and has done for ages.

It's hitting a simple limit. Please try the patch below - it 
quadruples the value printed in the warning (the number of entries) 
- does that get your system going?

Lock validation is getting more and more popular, covering now a lot 
more than just locks (workqueues, timers, etc.), so the max number 
of entries is steadily increasing. Some configs will run into this 
faster.

	Ingo

diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index 699a2ac..031f4c6 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -65,7 +65,7 @@ enum {
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
  */
-#define MAX_STACK_TRACE_ENTRIES	262144UL
+#define MAX_STACK_TRACE_ENTRIES	1048576UL
 
 extern struct list_head all_lock_classes;
 extern struct lock_chain lock_chains[];
