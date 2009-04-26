Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZDZL30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZDZL30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 07:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZDZL3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 07:29:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50106 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbZDZL3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 07:29:12 -0400
Date: Sun, 26 Apr 2009 13:27:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, davem@davemloft.net, dada1@cosmosbay.com,
       zbr@ioremap.net, jeff.chua.linux@gmail.com, paulus@samba.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v2 expedited "big hammer" RCU grace periods
Message-ID: <20090426112717.GE10391@elte.hu>
References: <20090426052340.GA24931@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426052340.GA24931@linux.vnet.ibm.com>
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

> Second cut of "big hammer" expedited RCU grace periods, but only 
> for rcu_bh.  This creates another softirq vector, so that entering 
> this softirq vector will have forced an rcu_bh quiescent state (as 
> noted by Dave Miller).  Use smp_call_function() to invoke 
> raise_softirq() on all CPUs in order to cause this to happen.  
> Track the CPUs that have passed through a quiescent state (or gone 
> offline) with a cpumask.

hm, i'm still asking whether doing this would be simpler via a 
reschedule vector - which not only is an existing facility but also 
forces all RCU domains through a quiescent state - not just bh-RCU 
participants.

Triggering a new softirq is in no way simpler that doing an SMP 
cross-call - in fact softirqs are a finite resource so using some 
other facility would be preferred.

Am i missing something?

	Ingo
