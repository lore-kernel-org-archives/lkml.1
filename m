Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbXKKPU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbXKKPU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 10:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXKKPUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 10:20:17 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35821 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754336AbXKKPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 10:20:15 -0500
Date: Sun, 11 Nov 2007 16:19:51 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
	!CONFIG_BINFMT_AOUT [try #5]
Message-ID: <20071111151951.GP21669@stusta.de>
References: <20071111142205.GO21669@stusta.de> <20071111112538.GL21669@stusta.de> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <1505.1194789569@redhat.com> <1701.1194793436@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1701.1194793436@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 03:03:56PM +0000, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > It's BTW not an improvement that you do not only rename them but change 
> > such big functions to static inline functions in header files.
> 
> I'm not sure what you meant by that.
> 
> Renaming them indicates more clearly that their only purpose is for A.OUT
> support.
> 
> Making them inline is an improvement because it compiles the code into the
> binfmt_aout module rather than the core kernel, and gives the compiler
> optimiser a chance to reduce the size of the overall code.
>  
> And the functions aren't actually all that big or complex.  They're about
> shovelling data and don't do anything clever.
>...

My thoughts go more into the direction that we have hundreds of similar 
cases where e.g. a VFS function might currently only by used by OCFS2 
and therefore be dead code for most users, and the only maintainable 
solution will be to solve these at the compiler and/or linker level.

> > Something like this.
> 
> Was that an agreement with my suggested break up, or was there something more
> meant to be there?

That was an agreement.

> > But changes to binfmt_elf.c after the merge window that might introduce 
> > regressions (e.g. you (ab)use CONFIG_BINFMT_AOUT where you might have to 
> > introduce an CONFIG_ARCH_SUPPORTS_AOUT instead) decrease your chances of 
> > being merged that late.
> 
> That was more or less what I wanted to do originally, but I was told to use
> CONFIG_BINFMT_AOUT instead - which actually proves to have two variants:-(
> 
> Perhaps I could start with the patch that you mentioned to remove AOUT
> interpreter support from binfmt_elf.  Can you point me at it or send it to me?
> That's still not sufficient, but it removes part of the changes I have to
> make.

Andi scheduled it for removal, and I don't know whether he already has a 
patch.

> > But you might be able to do something like a
> >   cp include/asm-xtensa/a.out.h include/asm-mn10300/
> > instead.
> 
> No.  That would be wrong.  MN10300 does not define an exec struct, and nor
> should it provide an asm/a.out.h header.  It does not do AOUT format.

Read the comment at the top of the xtensa header.  ;-)

For 2.6.25 a better solution is appreciated, but for 2.6.24 such a small 
dirty workaround that can't cause breakages on other architectures would 
be better.

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

