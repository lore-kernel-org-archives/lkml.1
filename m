Return-Path: <linux-kernel-owner+w=401wt.eu-S1763067AbYBUJmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763067AbYBUJmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYBUJmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:42:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYBUJma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:42:30 -0500
Date: Thu, 21 Feb 2008 10:42:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
Message-ID: <20080221094217.GA24162@elte.hu>
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com> <20080221090430.GA20055@elte.hu> <47BD44FF.7070104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BD44FF.7070104@linux.vnet.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> I have an alternate approach in mind (that I need to find time for), 
> threaded-rbtrees. Walking the tree is really efficient, specially 
> finding successor of a node.

sure, feel free to experiment with those details.

But if you want to improve Java workloads then you should probably start 
by converting them to futexes instead of sched_yield(), that will 
probably give far more performance than micro-optimizing the 
sys_sched_yield() codepath. (especially when it happens at the expense 
of other workloads, which is not acceptable for mainline) You can 
rebuild your JVM easily and re-test with its locking fixed, right?

	Ingo
