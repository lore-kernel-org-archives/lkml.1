Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151Ab0AUQcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0AUQcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934Ab0AUQcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:32:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51332 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0AUQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:32:20 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=6XqCWgjLSEsTxjFNj7sA:9 a=jTzW9MYidBjdB4hPehAA:7 a=QPl0TQgbXGQ7CstUh4Se0lPj5g4A:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100121162249.GA15761@Krystal>
References: <1263488625.4244.333.camel@laptop>
	 <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal>
	 <1263495132.28171.3861.camel@gandalf.stny.rr.com>
	 <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop>
	 <1263928006.4283.762.camel@laptop> <1264073212.4283.1158.camel@laptop>
	 <20100121160729.GB12842@Krystal>
	 <1264090331.31321.212.camel@gandalf.stny.rr.com>
	 <20100121162249.GA15761@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 11:32:09 -0500
Message-ID: <1264091529.31321.223.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:22 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > You may also need spin_lock_irqsave, et al. variants too.
> 
> Yep, or we simply use the local_irq_save/restore separately. That could
> be a good idea given that only few specialized sites are affected.

If it gets used more often, then we need to consider RT. RT modifies
spin_lock_irqsave into a standard mutex that does not disable
interrupts. But if something does:

	local_irq_save(flags);
	spin_lock_mb(&lock);
	[...]

Then it will break RT (if lock is to be converted).

-- Steve


