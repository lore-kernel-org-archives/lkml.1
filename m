Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYGRNkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYGRNkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYGRNkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:40:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbYGRNkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:40:03 -0400
Date: Fri, 18 Jul 2008 09:37:59 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org,
       jbeulich@novell.com
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs (part1: use kprobe symbol_name/offset instead of address)
Message-ID: <20080718133759.GO18295@redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain> <87ej5rsgk4.fsf@basil.nowhere.org> <1216373009.5232.130.camel@twins> <y0m7ibjjqg4.fsf@ton.toronto.redhat.com> <1216387284.3811.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216387284.3811.2.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jul 18, 2008 at 08:21:24AM -0500, James Bottomley wrote:

> [...]  I'm not entirely convinced systemtap wants full stack
> unwinding in the kernel.

Sure we "want" it if we can get it.  It enables richer data gathering.
It lets scripts act on the contents of the call stack ("is this probe
being run due to a callback from this or that shared library?").


> [...] However, systemtap in userspace sees all the relevant dwarf
> information as well ... it could do a much better job of unwinding:
> give file and line and arguments for function calls, for instance.
> All it really needs is to have the relevant pieces of the stack
> relayed back.

The relevant bits of stack for a userspace program could include
several megabytes per thread; without unwind info we can't be sure
which parts are which.  (A full gdb symbolic backtrace takes seconds
to compute - something we can't possibly afford in situ.)


- FChE
