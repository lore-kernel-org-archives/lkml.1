Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYKQPvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYKQPvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYKQPv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:51:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYKQPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:51:27 -0500
Date: Mon, 17 Nov 2008 10:51:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/7] ftrace, PPC: use probe_kernel API to modify code
In-Reply-To: <18720.63178.864933.911090@drongo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811171047520.2919@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <20081116212515.728019601@goodmis.org> <18720.63178.864933.911090@drongo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > Impact: use cleaner probe_kernel API over assembly
> > 
> > Using probe_kernel_read/write interface is a much cleaner approach
> > than the current assembly version.
> 
> Possibly naive question: how is it possible for the accesses to the
> instructions to fault, given that we are called through kstop_machine
> (according to the comment) and nothing else should be happening?

Actually, only start up and shutdown of the tracer goes through 
kstop_machine. With the new code, it can happen before SMP starts (in 
init/main.c) or on the module itself, before the module loads. But that's 
not why we do the probe_kernel_* calls.

The reason for probe_kernel_ is because ftrace is very intrusive. Ingo and 
I have been making ftrace very paranoid about anything it does. It does 
not trust itself to be correct. If anything were to fail, it will warn and 
shut itself down peacefully.  So far, I have not seen these warnings, but 
this is part of the robustness features that have been added since 2.6.27.

-- Steve

