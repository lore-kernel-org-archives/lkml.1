Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXGCR1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXGCR1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 13:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbXGCR0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 13:26:54 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37035 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbXGCR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 13:26:53 -0400
Date: Tue, 3 Jul 2007 13:26:38 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH 4/5] UML - Simplify helper stack handling
Message-ID: <20070703172638.GA31640@c2.user-mode-linux.org>
References: <20070614202655.GA9647@c2.user-mode-linux.org> <20070627233701.8e53f3cb.akpm@linux-foundation.org> <200707031728.36472.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707031728.36472.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 05:28:30PM +0200, Blaisorblade wrote:
> > fchown01 used greatest stack depth: 4892 bytes left
> 
> > That's the sum of process stack and interrupt stack, but I doubt if this
> > little box is using much interrupt stack space.
> >
> > No wonder people are still getting stack overflows with 4k stacks...
> 
> First, those numbers pretend to be _unused_ stack space.

But on an 8K stack.  If you pretend to be on a 4K stack, and take 4K
away from that, those numbers are 100s of bytes away from eating the
stack.

> Well, UML tends to use more stack space than the rest of
> kernel. Apart it has a bit more layering (even if less than in the
> past), we must use libc's function too, and they're not written to
> be executed on an 8k stack.

We don't use very much of libc on kernel stacks.  Also, various things
have been done to reduce stack usage.  We no longer initialize kernel
stacks with a signal frame on them.  We now have IRQ stacks.  I've
also done some amount of general stack usage reduction.  I haven't
seen anything come very close to running out of stack.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
