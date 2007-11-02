Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbXKBPyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbXKBPyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXKBPyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:54:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbXKBPyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:54:45 -0400
Date: Fri, 2 Nov 2007 16:53:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix delay accounting regression
Message-ID: <20071102155358.GA32116@elte.hu>
References: <20071102142220.24166.49046.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102142220.24166.49046.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0051]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Fix the delay accounting regression introduced by commit 
> 75d4ef16a6aa84f708188bada182315f80aab6fa. rq no longer has sched_info 
> data associated with it. task_struct sched_info structure is used by 
> delay accounting to provide back statistics to user space.

no, this really is broken code. sched_clock() is not a generally 
reliable time source so at a minimum the rq->clock fix i mentioned is 
needed. What user-space tools are utilizing delay-accounting by the way? 
We have most of this data available under SCHEDSTATS - how about 
consolidating CONFIG_TASK_DELAY_ACCT into CONFIG_SCHEDSTATS?

	Ingo
