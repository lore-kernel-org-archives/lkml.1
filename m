Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837Ab0AIXQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0AIXQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553Ab0AIXQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:16:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0AIXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:16:42 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=uGrhdwFXV8AXpu0HQR0A:9 a=wIYYDMkypuYq_A6r0uFA6mLe9ewA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <1263078327.28171.3792.camel@gandalf.stny.rr.com>
References: <20100107191657.GN6764@linux.vnet.ibm.com>
	 <1262893243.28171.3753.camel@gandalf.stny.rr.com>
	 <20100107205830.GR6764@linux.vnet.ibm.com>
	 <1262900140.28171.3773.camel@gandalf.stny.rr.com>
	 <20100108235338.GA18050@Krystal> <20100109002043.GD6816@linux.vnet.ibm.com>
	 <20100109010231.GA25368@Krystal> <20100109012128.GF6816@linux.vnet.ibm.com>
	 <20100109023842.GA1696@Krystal> <20100109054215.GB9044@linux.vnet.ibm.com>
	 <20100109192006.GA23672@Krystal>
	 <1263078327.28171.3792.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sat, 09 Jan 2010 18:16:40 -0500
Message-ID: <1263079000.28171.3795.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-09 at 18:05 -0500, Steven Rostedt wrote:

> Then we should have O(tasks) for spinlocks taken, and 
> O(min(tasks, CPUS)) for IPIs.
> 

And for nr tasks >> CPUS, this may help too:

> cpumask = 0;
> foreach task {

	if (cpumask == online_cpus)
		break;

> 	spin_lock(task_rq(task)->rq->lock);
> 	if (task_rq(task)->curr == task)
> 		cpu_set(task_cpu(task), cpumask);
> 	spin_unlock(task_rq(task)->rq->lock);
> }
> send_ipi(cpumask);
> 

-- Steve


