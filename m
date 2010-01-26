Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545Ab0AZVbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0AZVbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823Ab0AZVa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:30:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51884 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab0AZVa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:30:59 -0500
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last non-dynticked CPU
From: Andi Kleen <andi@firstfloor.org>
References: <20100125034816.GA14043@linux.vnet.ibm.com>
Date: Tue, 26 Jan 2010 22:30:57 +0100
In-Reply-To: <20100125034816.GA14043@linux.vnet.ibm.com> (Paul E. McKenney's message of "Sun, 24 Jan 2010 19:48:16 -0800")
Message-ID: <873a1sft9q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

Kind of offtopic to the original patch, but I couldn't 
resist...

> +config RCU_FAST_NO_HZ
> +	bool "Accelerate last non-dyntick-idle CPU's grace periods"
> +	depends on TREE_RCU && NO_HZ && SMP

Having such a thing as a config option doesn't really make 
any sense to me. Who would want to recompile their kernel
to enable/disable this? If anything it should be runtime, or better
just unconditionally on.

In general RCU could probably reduce its number of "weird"
Kconfig options.

While I think I have a better understanding of RCU than a lot
of normal users I often have no clue what to set there when
building a kernel.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
