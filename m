Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0CBMVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:21:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56481 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab0CBMVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:21:33 -0500
Date: Tue, 2 Mar 2010 13:20:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: suppress RCU lockdep warnings
 during early boot
Message-ID: <20100302122059.GA8247@elte.hu>
References: <20100301190329.GA26892@linux.vnet.ibm.com>
 <1267470234-27150-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267470234-27150-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> +	if (!rcu_scheduler_active || !debug_locks)
> +		return 1;
> +	return lock_is_held(&rcu_lock_map);

> +	if (!rcu_scheduler_active || !debug_locks)
> +		return 1;
> +	return lock_is_held(&rcu_bh_lock_map);

i guess there could be a common helper here?

Also, could we clear rcu_scheduler_active when we clear debug_locks? That way 
only a single test is needed, a generic 'is lock debugging active'.

(Which test should probably be unlikely() as well?)

	Ingo
