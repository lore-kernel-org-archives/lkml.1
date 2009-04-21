Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZDUSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZDUSRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbZDUSRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:17:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZDUSRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:17:36 -0400
Date: Tue, 21 Apr 2009 14:17:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Abbott <tabbott@MIT.EDU>
cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeffrey B Arnold <jbarnold@MIT.EDU>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
In-Reply-To: <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu>
Message-ID: <alpine.DEB.2.00.0904211415520.10097@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Arjan ]

On Tue, 21 Apr 2009, Tim Abbott wrote:

> On Sun, 19 Apr 2009, Rusty Russell wrote:
> 
> > I think you need to do something else in general.  Share the module_mutex for
> > the ftrace code?  The ksplice guys have a similar issue, so maybe we should
> > generalize this into a "kernel_text" mutex?
> 
> Yes, a kernel_text mutex is on my list of things to propose once Ksplice 
> gets merged.
> 
> There are at present several systems that modify the kernel text after a 
> machine is booted (e.g. dynamic ftrace and toggling of smp_locks when 
> hotplugging a cpu).  Currently, they avoid stepping on each other by only 
> making changes inside stop_machine.
> 
> However, Ksplice does its run-pre matching checks outside stop_machine, 

Does Ksplice use break points to do the modification? I'd be interested in 
knowing how Ksplice protects against the nastiness of code executing on 
one CPU that is being modified by another CPU.

-- Steve


> and Ksplice needs a way to prevent e.g. dynamic ftrace from changing the 
> code out from under it between those checks and actually applying the 
> patches [1].  A kernel_text mutex would be a reasonable solution to this 
> problem.
> 
> 	-Tim Abbott
> 
> [1] At present this isn't a real problem because Ksplice and ftrace 
> conflict with each other for unrelated reasons.
> 
