Return-Path: <linux-kernel-owner+w=401wt.eu-S1422675AbXBAIcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422675AbXBAIcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 03:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422680AbXBAIcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 03:32:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422675AbXBAIcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 03:32:45 -0500
Date: Thu, 1 Feb 2007 09:23:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, dipankar@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, oleg@tv-sign.ru,
       twoerner.k@gmail.com, josh@freedesktop.org, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 1/2] RCU priority boosting that survives vicious testing
Message-ID: <20070201082333.GA18233@elte.hu>
References: <20070201012136.GA21770@linux.vnet.ibm.com> <20070201012445.GA22922@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201012445.GA22922@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Here is the RCU priority-boosting patch.  Pretty close to the 
> http://lkml.org/lkml/2007/1/24/295 version.  This patch prevents 
> preempted or blocked low-priority RCU readers from indefinitely 
> stalling RCU grace periods.

thanks - i've applied both patches to -rt and it's looking good so far! 
Find a small cosmetic fix below.

	Ingo

Index: linux/kernel/rcupreempt.c
===================================================================
--- linux.orig/kernel/rcupreempt.c
+++ linux/kernel/rcupreempt.c
@@ -489,7 +489,7 @@ void init_rcu_boost_late(void)
 	rcu_boost_task = kthread_run(rcu_booster, NULL, "RCU Prio Booster");
 	if (IS_ERR(rcu_boost_task)) {
 		printk(KERN_ALERT
-		       "Unable to create RCU Priority Booster, errno %d\n",
+		       "Unable to create RCU Priority Booster, errno %ld\n",
 		       -PTR_ERR(rcu_boost_task));
 
 		/*
