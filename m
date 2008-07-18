Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbYGRNbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbYGRNbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYGRNbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:31:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbYGRNbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:31:09 -0400
Date: Fri, 18 Jul 2008 09:28:40 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com, arjan <arjan@infradead.org>, sandmann@daimi.au.dk,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs (part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080718132840.GN18295@redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain> <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins> <y0m7ibjjqg4.fsf@ton.toronto.redhat.com> <1216386627.28405.42.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216386627.28405.42.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jul 18, 2008 at 03:10:27PM +0200, Peter Zijlstra wrote:
> [...]
> > For example, we're about to do unwinding/stack-traces of userspace
> > programs.  To what extent do you think the kernel unwinder (should one
> > reappear in git) would welcome patches that provide zero benefit to
> > the kernel, but only enable a peculiar (nonintrusive) sort of
> > unwinding we would need for complex userspace stacks?
> 
> I think sysprof (kernel/trace/trace_sysprof.c) already does user-space
> stack unwinding. So pushing that capability further up the chain when a
> second user (stap) comes along makes perfect sense.

trace_sysprof relies on dump_stack, which is x86-only and does not do
elf/dwarf unwinding proper.  (Likewise oprofile, etc.)  They can't
even start, because they don't have unwind data available - something
we plan to make available to the systemtap runtime.


- FChE
