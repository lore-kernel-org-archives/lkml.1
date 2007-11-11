Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXKKPEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXKKPEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbXKKPE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 10:04:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbXKKPEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 10:04:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071111142205.GO21669@stusta.de>
References: <20071111142205.GO21669@stusta.de> <20071111112538.GL21669@stusta.de> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <1505.1194789569@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if !CONFIG_BINFMT_AOUT [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 15:03:56 +0000
Message-ID: <1701.1194793436@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> wrote:

> It's BTW not an improvement that you do not only rename them but change 
> such big functions to static inline functions in header files.

I'm not sure what you meant by that.

Renaming them indicates more clearly that their only purpose is for A.OUT
support.

Making them inline is an improvement because it compiles the code into the
binfmt_aout module rather than the core kernel, and gives the compiler
optimiser a chance to reduce the size of the overall code.

And the functions aren't actually all that big or complex.  They're about
shovelling data and don't do anything clever.

Actually, I could probably do another patch split to inline these functions
first before doing AOUT suppression.

> Something like this.

Was that an agreement with my suggested break up, or was there something more
meant to be there?

> But changes to binfmt_elf.c after the merge window that might introduce 
> regressions (e.g. you (ab)use CONFIG_BINFMT_AOUT where you might have to 
> introduce an CONFIG_ARCH_SUPPORTS_AOUT instead) decrease your chances of 
> being merged that late.

That was more or less what I wanted to do originally, but I was told to use
CONFIG_BINFMT_AOUT instead - which actually proves to have two variants:-(

Perhaps I could start with the patch that you mentioned to remove AOUT
interpreter support from binfmt_elf.  Can you point me at it or send it to me?
That's still not sufficient, but it removes part of the changes I have to
make.

> But you might be able to do something like a
>   cp include/asm-xtensa/a.out.h include/asm-mn10300/
> instead.

No.  That would be wrong.  MN10300 does not define an exec struct, and nor
should it provide an asm/a.out.h header.  It does not do AOUT format.

David
