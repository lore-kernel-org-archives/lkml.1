Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYI3HK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYI3HK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYI3HKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:10:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYI3HKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:10:15 -0400
Date: Tue, 30 Sep 2008 09:09:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] Markers : fix reentrancy
Message-ID: <20080930070923.GB30927@elte.hu>
References: <20080930054151.GA16961@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930054151.GA16961@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Lai Jiangshan <laijs@cn.fujitsu.com> wrote :
> > marker_synchronize_unregister must be called _also_ between unregistration
> > and destruction the data that unregistration-ed probes need to make sure
> > there is no caller executing a probe when it's data is destroyed.
> > 
> 
> Ah, you're right. I looked again through your patch description and I
> think using a :
> 
> 
> if (entry->rcu_pending)
>                 rcu_barrier_sched();
> 
> After each time the markers_mutex is taken would keep the fast batch 
> registration/unregistration and fix the reentrancy problem. The 
> following patch should address the problem.

could you please send a delta patch against tip/master? Lai's patch is 
already applied and is tested. Thanks,

	Ingo
