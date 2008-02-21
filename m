Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbYBUJFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbYBUJFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYBUJEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:04:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYBUJEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:04:52 -0500
Date: Thu, 21 Feb 2008 10:04:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: Make yield_task_fair more efficient
Message-ID: <20080221090430.GA20055@elte.hu>
References: <20080221053321.GA26918@balbir.in.ibm.com> <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com> <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com> <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BD3B56.3090404@linux.vnet.ibm.com>
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

> If you insist that sched_yield() is bad, I might agree, but how does 
> my patch make things worse. [...]

it puts new instructions into the hotpath.

> [...] In my benchmarks, it has helped the sched_yield case, why is 
> that bad? [...]

I had the same cache for the rightmost task in earlier CFS (it's a 
really obvious thing) but removed it. It wasnt a bad idea, but it hurt 
the fastpath hence i removed it. Algorithms and implementations are a 
constant balancing act.

	Ingo
