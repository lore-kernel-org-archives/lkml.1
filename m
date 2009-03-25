Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZCYQ6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZCYQ6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZCYQ56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:57:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZCYQ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:57:57 -0400
Date: Wed, 25 Mar 2009 17:57:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, penberg@cs.helsinki.fi,
       eduard.munteanu@linux360.ro, tglx@linutronix.de
Subject: Re: [tip:tracing/kmemtrace] rcutree: fix rcu_tree_trace.c data
	structure dependencies
Message-ID: <20090325165713.GA14250@elte.hu>
References: <1237898630.25315.83.camel@penberg-laptop> <tip-5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36@git.kernel.org> <20090325161147.GA18738@elte.hu> <20090325165204.GG7297@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325165204.GG7297@linux.vnet.ibm.com>
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

> > I think many of the data definitions (and the resulting include 
> > file dependencies) in include/linux/rcu*.h could move into 
> > kernel/rcu*.h and be privatized that way. 'struct rcu_state' 
> > would be an example.
> > 
> > Agreed?
> 
> In principle, yes.  In practice, my attempts to make headway in 
> this direction have usually collided with the desire to inline 
> some of the functions that appear on fastpaths, so I would prefer 
> caution when moving in this direction, especially given my 
> treercu-related todos, to which "speeding up synchronize_rcu()" 
> just got added.

I think there's a solution, for example the quiescent-state inlines 
could still be offered in a kernel/rcupdate_internals.h header to be 
included by kernel/softirq.c et al directly.

Otherwise ... i think it generally is not worth the trouble to put 
huge data types into common headers just to be able to inline into a 
small number of callsites.

	Ingo
