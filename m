Return-Path: <linux-kernel-owner+w=401wt.eu-S1760329AbZFJTeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760329AbZFJTeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZFJTeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:34:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZFJTeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:34:02 -0400
Date: Wed, 10 Jun 2009 15:34:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Frysinger <vapier.adi@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
In-Reply-To: <8bd0f97a0906101219r7a7fcbdfqc0c45c9c97210d1a@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0906101523140.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org>  <1244623722-6325-2-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com>  <8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com> 
 <alpine.DEB.2.00.0906101441410.30552@gandalf.stny.rr.com>  <8bd0f97a0906101207s3eb36ccbp7baa631a941b9b0f@mail.gmail.com>  <alpine.DEB.2.00.0906101511070.30552@gandalf.stny.rr.com> <8bd0f97a0906101219r7a7fcbdfqc0c45c9c97210d1a@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 10 Jun 2009, Mike Frysinger wrote:

> On Wed, Jun 10, 2009 at 15:11, Steven Rostedt wrote:
> > On Wed, 10 Jun 2009, Mike Frysinger wrote:
> >> On Wed, Jun 10, 2009 at 14:45, Steven Rostedt wrote:
> >> > If there's a HAVE_XXX in Kconfig that I want to see how to implement it, I
> >> > go off and do 'grep -r XXX Documentation'.
> >>
> >> i look for the source of the define because ive given up on the
> >> Documentation actually being relevant
> >
> > And you think documentation in Kconfig will be updated??
> 
> i didnt mean *just* Kconfig, but funny enough, the Kconfig for
> HAVE_FUNCTION_TRACE_MCOUNT_TEST had the most relevant information.
> all other places were #ifdef with no meaning.  and the existing
> x86/ppc/sh ports of ftrace are devoid of any comments let alone useful

Well that example was commented in the generic code:

kernel/trace/ftrace.c:

#ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
/*
 * For those archs that do not test ftrace_trace_stop in their
 * mcount call site, we need to do it from C.
 */


And only x86 has it defined, thus looking at the mocunt call site
as descibed in the comment, or searching the kernel for ftrace_trace_stop:

arch/x86/kernel/entry_64.S

ENTRY(ftrace_caller)
        cmpl $0, function_trace_stop
        jne  ftrace_stub

But yes, as documenting goes, this is a poor example. The 
function_trace_stop is more of a way to quickly stop ftrace, in case of 
emergency. It can also be useful for static ftrace. When ftrace is 
enabled, there's really not much difference in overhead if it is 
implemented or not. Only for static tracing, or when ftrace is disabled 
via the variable (not with dynamic ftrace).

> ones, as is the core ftrace code wrt the arch pieces it relies on.
> the absolute dearth of ftrace documentation for arch porters is
> ridiculous.

Yes, we can always document more. But you are the first to complain to me 
about lack of documentation for porting. I get complaints all the time 
about lack of documentation for using it, and I'm working on that.

When I get time, I would love to write up a "how to port ftrace" doc.

I would also love to review one ;-)

-- Steve

