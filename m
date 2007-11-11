Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbXKKOWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbXKKOWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXKKOWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:22:31 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42363 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056AbXKKOWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:22:30 -0500
Date: Sun, 11 Nov 2007 15:22:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
	!CONFIG_BINFMT_AOUT [try #5]
Message-ID: <20071111142205.GO21669@stusta.de>
References: <20071111112538.GL21669@stusta.de> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk> <1505.1194789569@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1505.1194789569@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 01:59:29PM +0000, David Howells wrote:
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > - too many cleanups lumped into one patch
> 
> Perhaps, but unfortunately a lot of them are related and required for a
> compilable patch.  I can probably split it up 4 ways if you really want me
> to, in order:
> 
>  (1) Move STACK_TOP[_MAX].
> 
>  (2) Rename dump_thread() -> aout_dump_thread().

It's BTW not an improvement that you do not only rename them but change 
such big functions to static inline functions in header files.

>  (3) Everything else.
> 
>  (4) Remove obsolete a.out.h inclusions.
> 
> I don't think it's really worth splitting (2) from (3) though.

Something like this.

> > - it adds #ifdef's in fs/binfmt_elf.c for code that is anyway
> >   scheduled for removal in 2.6.25
> 
> Yes, but that patch isn't there now, and won't be there in the next version -
> assuming this arch has a hope of getting in on that one - according to your
> statement.

I'm not the one to decide, but the only excuse for getting that late 
into 2.6.24 would be "it can't cause any regression".

The arch/mn10300/ and include/asm-mn10300/ additions can't cause 
regressions, and for all the drivers/ parts it seems to be easily 
verifiable that they can't cause regressions.

But changes to binfmt_elf.c after the merge window that might introduce 
regressions (e.g. you (ab)use CONFIG_BINFMT_AOUT where you might have to 
introduce an CONFIG_ARCH_SUPPORTS_AOUT instead) decrease your chances of 
being merged that late.

But you might be able to do something like a
  cp include/asm-xtensa/a.out.h include/asm-mn10300/
instead.

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

