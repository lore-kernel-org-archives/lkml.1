Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYLJCPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYLJCPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYLJCO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:14:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYLJCO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:14:57 -0500
Date: Tue, 9 Dec 2008 21:14:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt
 triggering on output
In-Reply-To: <493EF64D.50804@gmail.com>
Message-ID: <alpine.DEB.1.10.0812092111510.19875@gandalf.stny.rr.com>
References: <493EF64D.50804@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Dec 2008, Frederic Weisbecker wrote:

> This patchset adds all the features to draw hardirq triggering on output
> for the function graph tracer.
> An example is given on the third patch.
> 
> Just one question, on recordmcount.pl:
> 
> my %text_sections = (
>       ".text" => 1,
>       ".sched.text" => 1,
>       ".spinlock.text" => 1,
> 
> The .sched.text section is included inside .text, it's a subsection, I'm not sure
> it's necessary to add it in text_sections. In doubt I added the new .irqentry.text
> 

Matters what objdump -dr shows.

$ objdump -dr kernel/sched.o | grep 'Disassembly'
Disassembly of section .text:
Disassembly of section .cpuinit.text:
Disassembly of section .init.text:
Disassembly of section .sched.text:

Yep, .sched.text is needed.  It is not about what gets linked by the 
linker. It is about what objdump shows, which is what recordmcount.pl uses 
to determine whether or not to record the mcount callers in that section.

-- Steve

