Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYBDMBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYBDMBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 07:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYBDMBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 07:01:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYBDMBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 07:01:43 -0500
Date: Mon, 4 Feb 2008 13:01:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git4+ regression
Message-ID: <20080204120131.GA20962@elte.hu>
References: <20080130135609.GA5100@ics.muni.cz> <20080131102919.GC27157@elte.hu> <20080204111747.GB4450@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204111747.GB4450@ics.muni.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> but in such a case, kernel 2.6.24-git13 does oops at startup in 
> sched_slice.

could you tell me more about this oops? You booted unmodified, latest 
-git and it oopsed in sched_slice()? The patch below should work around 
any oopses in sched_slice(). [but this is really a 'must not happen' 
scenario - so a just-for-testing patch]

	Ingo

Index: linux-x86.q/kernel/sched_fair.c
===================================================================
--- linux-x86.q.orig/kernel/sched_fair.c
+++ linux-x86.q/kernel/sched_fair.c
@@ -268,7 +268,8 @@ static u64 sched_slice(struct cfs_rq *cf
 	u64 slice = __sched_period(cfs_rq->nr_running);
 
 	slice *= se->load.weight;
-	do_div(slice, cfs_rq->load.weight);
+	if (cfs_rq->load.weight)
+		do_div(slice, cfs_rq->load.weight);
 
 	return slice;
 }
