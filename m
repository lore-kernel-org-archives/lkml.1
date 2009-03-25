Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbZCYQMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbZCYQMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbZCYQME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:12:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbZCYQMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:12:03 -0400
Date: Wed, 25 Mar 2009 17:11:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro, tglx@linutronix.de
Subject: Re: [tip:tracing/kmemtrace] rcutree: fix rcu_tree_trace.c data
	structure dependencies
Message-ID: <20090325161147.GA18738@elte.hu>
References: <1237898630.25315.83.camel@penberg-laptop> <tip-5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Commit-ID:  5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36
> Gitweb:     http://git.kernel.org/tip/5d957021d326fbfdc1d7a4f11a3da1f6f82d6a36
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 25 Mar 2009 16:42:24 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 25 Mar 2009 16:42:24 +0100
> 
> rcutree: fix rcu_tree_trace.c data structure dependencies
> 
> Impact: build fix
> 
> We removed rcutree internals from the public rcutree.h file - but
> kernel/rcutree_trace.c depends on them.
> 
> Introduce kernel/rcutree.h for internal definitions. (Probably all
> the other data types from include/linux/rcutree.h could be
> moved here too - except rcu_data.)

Paul ... what do you think? This is just an interim measure to get 
the build going - i think we could do more cleanups here perhaps, if 
you agree.

I think many of the data definitions (and the resulting include file 
dependencies) in include/linux/rcu*.h could move into kernel/rcu*.h 
and be privatized that way. 'struct rcu_state' would be an example.

Agreed?

	Ingo
