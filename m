Return-Path: <linux-kernel-owner+w=401wt.eu-S1762783AbXGNSp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762783AbXGNSp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 14:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbXGNSpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 14:45:20 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48616 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbXGNSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 14:45:19 -0400
Subject: Re: [PATCH -rt 2/5] Thread Migration Preemption - v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070714171646.GB746@tv-sign.ru>
References: <20070714175733.194012000@chello.nl>
	 <20070714175839.641246000@chello.nl>  <20070714171646.GB746@tv-sign.ru>
Content-Type: text/plain
Date: Sat, 14 Jul 2007 20:44:54 +0200
Message-Id: <1184438694.5284.69.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 21:16 +0400, Oleg Nesterov wrote:
> On 07/14, Peter Zijlstra wrote:
> >
> > From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > This patch adds the ability to protect critical sections from migration to
> > another CPU without disabling preemption.
> > 
> > This will be useful to minimize the amount of preemption disabling for the -rt
> > patch. It will help leveraging improvements brought by the local_t types in
> > asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> > variables protected by migrate_disable must be either atomic or protected from
> > concurrent updates done by other threads.
> > 
> > Typical use:
> > 
> > migrate_disable();
> > local_inc(&__get_cpu_var(&my_local_t_var));
> > migrate_enable();
> > 
> > Which will increment the variable atomically wrt the local CPU.
> 
> I still think this patch is buggy. Perhaps I am wrong. Please look at
> 
> 	http://marc.info/?l=linux-kernel&m=118417177818825
> 
> there was no any reply.

Looking at it, I tend to agree that the migration_thread thing is indeed
quite broken. Not quite sure on how to solve it nicely though, one would
need to stick the migration request structure somewhere in task_struct
or thread_info, and not back on the migration_queue. But given that
people already complained about the adding ov migration_counter,. I'm
not daring to propose such things.


