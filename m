Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYGRNEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYGRNEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYGRNE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:04:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbYGRNEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:04:25 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs 	(part1: use kprobe symbol_name/offset instead of address)
References: <1216146802.3312.95.camel@localhost.localdomain>
	<87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 18 Jul 2008 09:02:19 -0400
In-Reply-To: <1216373009.5232.130.camel@twins> (Peter Zijlstra's message of "Fri, 18 Jul 2008 11:23:29 +0200")
Message-ID: <y0m7ibjjqg4.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> [...]
>> Right now x86 doesn't really have a good reliable unwinder that
>> works without frame pointer. I think systemtap
>> recently switched to Jan Beulich's dwarf2 unwinder. Before
>> switching to the in kernel unwinder that one would need to be 
>> re-merged again.
>
> Those are two separate issues.
>
> 1) stap ought to use the kernel's infrastructure and not re-implement
> its own.
> 2) if the kernel's infrastructure doesn't meet requirements, improve
> it.

They are related to the extent that readers may not realize some
implications of systemtap being/becoming a *kernel-resident* but not
*kernel-focused* tool.

For example, we're about to do unwinding/stack-traces of userspace
programs.  To what extent do you think the kernel unwinder (should one
reappear in git) would welcome patches that provide zero benefit to
the kernel, but only enable a peculiar (nonintrusive) sort of
unwinding we would need for complex userspace stacks?


- FChE
