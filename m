Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXJCKws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXJCKws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXJCKwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:52:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbXJCKwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:52:40 -0400
Date: Wed, 3 Oct 2007 12:52:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lockdep: annotate kprobes irq fiddling
Message-ID: <20071003105221.GA6776@elte.hu>
References: <1191408172.5572.11.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191408172.5572.11.camel@lappy>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3505]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Hi,
> 
> The below patch fixes a lockdep error in 2.6.23-rc9 when using 
> tcp_probe.
> 
> ---
> 
> Subject: lockdep: annotate kprobes irq fiddling
> 
> kprobes disables irqs for jprobes, but does not tell lockdep about it.

this resolves this warning during an allyesconfig bzImage bootup test:

 [  423.670337] WARNING: at kernel/lockdep.c:2658 check_flags()
 [  423.670341]  [<c0107f01>] show_trace_log_lvl+0x19/0x2e
 [  423.670348]  [<c0107ffa>] show_trace+0x12/0x14
 [  423.670350]  [<c0108010>] dump_stack+0x14/0x16
 [  423.670353]  [<c015249d>] check_flags+0x95/0x142
 [  423.670357]  [<c0155576>] lock_acquire+0x52/0xb8
 [  423.670360]  [<c1313c90>] _spin_lock+0x2e/0x58
 [  423.670365]  [<c11b72f9>] jtcp_rcv_established+0x6e/0x189
 [  423.670369]  [<c11810da>] tcp_v4_do_rcv+0x30b/0x620
 [  423.670373]  [<c1181c8c>] tcp_v4_rcv+0x89d/0x8fa
 [  423.670376]  [<c1167dba>] ip_local_deliver+0x17d/0x225
 [  423.670380]  [<c11682f5>] ip_rcv+0x493/0x4ce
 [  423.670383]  [<c11177ef>] netif_receive_skb+0x347/0x365
 [  423.670388]  [<c07b6e7b>] nv_napi_poll+0x501/0x6c3
 [  423.670393]  [<c1115b1a>] net_rx_action+0xa3/0x1b6
 [  423.670396]  [<c013bdee>] __do_softirq+0x76/0xfb
 [  423.670400]  [<c0109189>] do_softirq+0x75/0xf3

	Ingo
