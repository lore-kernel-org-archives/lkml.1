Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYGRNVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYGRNVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbYGRNVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:21:30 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38333 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756392AbYGRNV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:21:29 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com
In-Reply-To: <y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins>
	 <y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 08:21:24 -0500
Message-Id: <1216387284.3811.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 09:02 -0400, Frank Ch. Eigler wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > [...]
> >> Right now x86 doesn't really have a good reliable unwinder that
> >> works without frame pointer. I think systemtap
> >> recently switched to Jan Beulich's dwarf2 unwinder. Before
> >> switching to the in kernel unwinder that one would need to be 
> >> re-merged again.
> >
> > Those are two separate issues.
> >
> > 1) stap ought to use the kernel's infrastructure and not re-implement
> > its own.
> > 2) if the kernel's infrastructure doesn't meet requirements, improve
> > it.
> 
> They are related to the extent that readers may not realize some
> implications of systemtap being/becoming a *kernel-resident* but not
> *kernel-focused* tool.
> 
> For example, we're about to do unwinding/stack-traces of userspace
> programs.  To what extent do you think the kernel unwinder (should one
> reappear in git) would welcome patches that provide zero benefit to
> the kernel, but only enable a peculiar (nonintrusive) sort of
> unwinding we would need for complex userspace stacks?

I'm not entirely convinced systemtap wants full stack unwinding in the
kernel.  What the kernel wants is the call trace, which it can do with
kallsyms.  However, systemtap in userspace sees all the relevant dwarf
information as well ... it could do a much better job of unwinding: give
file and line and arguments for function calls, for instance.  All it
really needs is to have the relevant pieces of the stack relayed back.

James


