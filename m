Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbYFCNAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbYFCNAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYFCNA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:00:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYFCNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:00:29 -0400
Date: Tue, 3 Jun 2008 09:00:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3][RFC] ftrace: track dynamic ftrace update failures
In-Reply-To: <863e9df20806022113w339257b1pa4c8a7762bab8bc1@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0806030858500.20107@gandalf.stny.rr.com>
References: <4842CB8F.2000702@gmail.com>  <Pine.LNX.4.58.0806021354520.10366@gandalf.stny.rr.com>
 <863e9df20806022113w339257b1pa4c8a7762bab8bc1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 3 Jun 2008, Abhishek Sagar wrote:
>
> > Have you also taken into account adding and removing of modules? This can
> > cause some funny behaviours with ftrace that can be rather dangerous.
>
> I've tried to accommodate them (fixed the wrong use of
> kernel_text_address). This makes
> init and module function records eligible to be freed. Only core
> kernel function update failures now get tracked/remembered.
>
> There might still be a need to find a way to track external modifiers
> of mcount call-sites such as (but not limited to) kprobes. Consider
> this (rather long) contrived scenario:
>
> 1. Function foo gets recorded by ftrace.
> 2. Mcount call site of foo is patched with a NOP by ftraced.
> 3. foo gets 'enabled' by some ftrace filter rule. NOP changes to a
> call to the function tracer.
> 4. A kprobe is registered on the mcount call-site. It places a trap
> generating instruction at the
> mcount call site and stores the call-to-function-tracer instruction
> elsewhere internally.
> 5. Tracing is disabled by end user.
> 6. Disabling of foo fails because Kprobe had placed a trap at the
> mcount call site.
> 7. foo still keeps getting traced because Kprobes will keep
> single-stepping the call-to-function-tracer instruction each time the
> mcount call site is executed.
>
> Not sure what to do with such cases...

Can we add an API to kprobes or perhaps a way to register code
modification in ftrace, that ftrace can ignore? Let the two know about
each other, but in a way that they dont need to know the internals of one
another.

-- Steve

