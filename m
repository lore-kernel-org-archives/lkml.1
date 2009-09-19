Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZISGz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZISGz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 02:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZISGz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 02:55:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbZISGz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 02:55:56 -0400
Date: Sat, 19 Sep 2009 08:55:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH tip/core/rcu 0/3] Cleanups/bugfixes for large systems
	and TREE_PREEMPT_RCU
Message-ID: <20090919065523.GA17617@elte.hu>
References: <20090918164955.GA22272@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090918164955.GA22272@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This set of patches does some cleanups and fixes a bug that prevents 
> TREE_PREEMPT_RCU from running reliably on large systems (more than 64 
> CPUs, or on 32-bit systems, more than 32 CPUs).  The patches are as 
> follows:
> 
> 1.	Add WARN_ON_ONCE() consistency checks to catch bugs.  These
> 	are all on slowpaths, so are appropriate for production use.
> 
> 2.	Apply the results of a code walkthrough of rcutree_plugin.h.
> 	This includes a fix for a theoretical race that could result in
> 	excessively long RCU grace periods, or perhaps even hangs/OOMs.
> 
> 3.	Fix a bug introduced in a bugfix commit #de078d875 that caused
> 	large systems to only partially initialize the fields in the
> 	rcu_node tree.  TREE_RCU doesn't care about any of these fields,
> 	which explains why only TREE_PREEMPT_RCU was broken.
> 
> With these fixes, large systems using TREE_PREEMPT_RCU pass moderate 
> rcutorture runs (but with Josh Triplett's mods that force frequent 
> preemption within RCU read-side critical sections).  I am sure that 
> there are more bugs, but these fixes get things much closer.
> 
>  b/kernel/rcutree.c        |   13 +++++++++----
>  b/kernel/rcutree_plugin.h |   21 ++++++++++++++-------
>  kernel/rcutree.c          |   38 +++++++++-----------------------------
>  kernel/rcutree_plugin.h   |   16 +++++++++-------
>  4 files changed, 41 insertions(+), 47 deletions(-)

Thanks Paul, applied them to tip:core/urgent.

	Ingo
