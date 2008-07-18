Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbYGRNKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbYGRNKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbYGRNKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:10:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYGRNKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:10:03 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com, arjan <arjan@infradead.org>, sandmann@daimi.au.dk,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins>
	 <y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 15:10:27 +0200
Message-Id: <1216386627.28405.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
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

I think sysprof (kernel/trace/trace_sysprof.c) already does user-space
stack unwinding. So pushing that capability further up the chain when a
second user (stap) comes along makes perfect sense.



