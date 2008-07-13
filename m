Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYGMVNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYGMVNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYGMVNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:13:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbYGMVNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:13:32 -0400
Date: Sun, 13 Jul 2008 23:13:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]rcu classic: update qlen when cpu offline
Message-ID: <20080713211315.GA17442@elte.hu>
References: <4862F9B3.5030300@cn.fujitsu.com> <20080626141324.GA10859@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626141324.GA10859@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Jun 26, 2008 at 10:06:43AM +0800, Lai Jiangshan wrote:
> > 
> > When callbacks are moved from offline cpu to this cpu,
> > the qlen field of this rdp should be updated.
> 
> Good catch!!!
> 
> The effect of this bug would be for force_quiescent_state() to be invoked
> when it should not and vice versa -- wasting cycles in the first case
> and letting RCU callbacks remain piled up in the second case.  The bug
> is thus "benign" in that it does not result in premature grace-period
> termination, but should of course be fixed nonetheless.
> 
> Preemption is disabled by the caller's get_cpu_var(), so we are guaranteed
> to remain on the same CPU, as required.  The local_irq_disable() is indeed
> needed, otherwise, an interrupt might invoke call_rcu() or call_rcu_bh(),
> which could cause that interrupt's increment of ->qlen to be lost.
> 
> So this patch looks correct to me.  Good job, Jiangshan!!!
> 
> Ingo, would you be willing to add this patch to tip/core/rcu?
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

thanks, applied to tip/core/rcu. (sorry about the delay!)

	Ingo
