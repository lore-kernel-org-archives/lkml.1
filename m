Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYI3KOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYI3KOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 06:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYI3KOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 06:14:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54745 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYI3KOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 06:14:09 -0400
Date: Tue, 30 Sep 2008 12:13:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Markers use rcu_read_lock_sched()
Message-ID: <20080930101322.GD7557@elte.hu>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929150803.GE11245@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929150803.GE11245@Krystal>
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

> Use the new rcu_read_lock_sched/unlock_sched() in marker code around 
> the call site instead of preempt_disable/enable(). It helps reviewing 
> the code more easily.

applied this cleanup on top of the fix from Lai Jiangshan, thanks 
Matthieu!

here are the new commits in tip/tracing/markers:

 2396ac3: sputrace: use marker_synchronize_unregister()
 a16801c: markers: documentation fix for teardown
 b05d9cf: markers: probe example, fix teardown
 4b0b16f: markers: fix unregister bug and reenter bug, cleanup
 1638da5: markers: marker_synchronize_unregister()
 b211730: Merge branch 'core/rcu' into tracing/markers
 1c50b72: rcu: add rcu_read_lock_sched() / rcu_read_unlock_sched()
 d587284: markers: fix unregister bug and reenter bug

	Ingo
