Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbXGEWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbXGEWry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbXGEWrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:47:45 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:49071 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbXGEWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:47:44 -0400
Subject: Re: [RFC] Thread Migration Preemption
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070705215152.GA4865@Krystal>
References: <20070705215152.GA4865@Krystal>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 18:46:46 -0400
Message-Id: <1183675606.17319.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 17:51 -0400, Mathieu Desnoyers wrote:
> Thread Migration Preemption
> 
> This patch adds the ability to protect critical sections from migration to
> another CPU without disabling preemption.
> 
> This will be useful to minimize the amount of preemption disabling for the -rt
> patch. It will help leveraging improvements brought by the local_t types in
> asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> variables protected by migration_disable must be either atomic or protected from
> concurrent updates done by other threads.
> 
> Typical use:
> 
> migration_disable();
> local_inc(&__get_cpu_var(&my_local_t_var));
> migration_enable();
> 
> Which will increment the variable atomically wrt the local CPU.
> 
> Comments (such as how to integrate this in the already almost full
> preempt_count) are welcome.

Ingo and Thomas, this also would help with the IRQ thread running a
softirq issue.  We wouldn't need to bind to a CPU the thread. We could
simply disable the ability to migrate while the IRQ thread was handling
the softirqs.

-- Steve


