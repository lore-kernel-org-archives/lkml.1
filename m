Return-Path: <linux-kernel-owner+w=401wt.eu-S965081AbXBQJHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081AbXBQJHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 04:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965082AbXBQJHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 04:07:49 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51879 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965081AbXBQJHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 04:07:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<20070216195256.GE2572@flint.arm.linux.org.uk>
	<1171665426.5644.99.camel@localhost.localdomain>
	<200702170237.42910.arnd@arndb.de>
	<1171684847.5644.108.camel@localhost.localdomain>
Date: Sat, 17 Feb 2007 02:06:43 -0700
In-Reply-To: <1171684847.5644.108.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Sat, 17 Feb 2007 15:00:47 +1100")
Message-ID: <m1tzxlb1b0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> In addition, if we remove the numbers, archs will need basically the
> exact same services provided by the powerpc irq core for reverse mapping
> (going from a HW irq number on a given PIC back to an irq_desc *).

Ben you seem to be under misapprehension that except for the case of
ISA (0-16) the linux IRQ number is a hardware number.  It is an arbitrary
software enumeration, and I think it has been that way a very long time.

> Either using a linear array for simple PICs or a radix tree for
> platforms with very big interrupt numbers (BTW. I think we have lockless
> radix trees nowadays, I can remove the spinlocks to protect it in the
> powerpc remapper).

I can only tell you that my impression of this last is that all the
world's not a PPC.

I have a version of the x86 code with a partial conversion done and
I didn't need a reverse mapping.  What you call the hardware interrupt
number never happens to be interesting to me after the system is setup.

I do suspect there may be an interesting chunk of your ppc work that
probably makes sense as a library so other arches could use it.

Eric
