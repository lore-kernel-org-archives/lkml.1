Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbXKTM4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbXKTM4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbXKTM4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:56:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758429AbXKTM4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:56:13 -0500
Date: Tue, 20 Nov 2007 13:55:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3,
	v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071120125557.GB8355@elte.hu>
References: <20071119151756.GA25446@elte.hu> <20071120112459.GA2884@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071120112459.GA2884@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Damien Wyart <damien.wyart@free.fr> wrote:

> > As usual, any sort of feedback, bugreport, fix and suggestion is 
> > more than welcome!
> 
> Testing sched-cfs-v2.6.24-rc3-v24.patch on top of 2.6.24-rc3-git1 
> (ignored the two "already applied" messages coming from git1 commits), 
> I get a 1.00 minimum load in top, coming from the load_balance_mo 
> thread staying in D-state. I get this on 2 different computers with 
> similar configs, so I am attaching one of them here.

does the patch below fix that problem for you?

	Ingo

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -7138,7 +7138,7 @@ static int load_balance_monitor(void *un
 		else if (timeout < sysctl_sched_max_bal_int_shares)
 			timeout *= 2;
 
-		msleep(timeout);
+		msleep_interruptible(timeout);
 	}
 
 	return 0;
