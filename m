Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469Ab0AZXze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0AZXze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473Ab0AZXz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:55:29 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:33657 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0AZXzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:55:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAGsLX0uuWOiG/2dsb2JhbACBO9gvhDcE
Date: Tue, 26 Jan 2010 18:55:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100126235516.GA15855@Krystal>
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <873a1sft9q.fsf@basil.nowhere.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:49:22 up 41 days,  8:07,  4 users,  load average: 0.18, 0.24,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> Kind of offtopic to the original patch, but I couldn't 
> resist...
> 
> > +config RCU_FAST_NO_HZ
> > +	bool "Accelerate last non-dyntick-idle CPU's grace periods"
> > +	depends on TREE_RCU && NO_HZ && SMP
> 
> Having such a thing as a config option doesn't really make 
> any sense to me. Who would want to recompile their kernel
> to enable/disable this? If anything it should be runtime, or better
> just unconditionally on.
> 
> In general RCU could probably reduce its number of "weird"
> Kconfig options.
> 
> While I think I have a better understanding of RCU than a lot
> of normal users I often have no clue what to set there when
> building a kernel.

Maybe we could keep them under a CONFIG_DEBUG_RCU umbrella. Compiling
out parts of the rcu options can be useful for debugging purposes, but
I agree with you that end users should not be bothered with that much
options when some of them are "obviously" wanted.

OTOH, I understand that Paul seems to want to introduce new RCU
features gradually, without hitting all kernel users with bugs in newer
features. That's a sane approach to keep things generally stable, but
maybe it is time to set some of the stabilized RCU options to default Y
and move their config to the debug menu.

Let's see what Paul has to say about this...

Thanks,

Mathieu

> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
