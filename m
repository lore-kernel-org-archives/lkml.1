Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXKKL0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXKKL0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 06:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbXKKL0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 06:26:05 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33627 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753209AbXKKL0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 06:26:04 -0500
Date: Sun, 11 Nov 2007 12:25:39 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 1/6] Suppress A.OUT library support if
	!CONFIG_BINFMT_AOUT [try #5]
Message-ID: <20071111112538.GL21669@stusta.de>
References: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071109153437.20803.55096.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 03:34:37PM +0000, David Howells wrote:
> Suppress A.OUT library support if CONFIG_BINFMT_AOUT is not set.
> 
> Not all architectures support the A.OUT binfmt, so the ELF binfmt should not
> be permitted to go looking for A.OUT libraries to load in such a case.  Not
> only that, but under such conditions A.OUT core dumps are not produced either.
> 
> To make this work, this patch also does the following:
> 
>  (1) Makes the existence of the contents of linux/a.out.h more or less
>      contingent on one of:
> 
> 	CONFIG_BINFMT_AOUT=[ym]
> 	CONFIG_IA32_AOUT=[ym]
> 	CONFIG_BINFMT_AOUT32=[ym]
> 
>  (2) Moves STACK_TOP[_MAX] out of asm/a.out.h and into asm/processor.h as
>      they're required whether or not A.OUT format is available.
> 
>  (3) Renames dump_thread() to aout_dump_thread() as it's only called by A.OUT
>      core dumping code.
> 
>  (4) Moves aout_dump_thread() into asm/a.out-core.h and makes it inline.  This
>      is then included only where needed.  This means that this bit of arch
>      code will be stored in the appropriate A.OUT binfmt module rather than
>      the core kernel.
> 
>  (5) Removes a lot of now obsolete {linux,asm}/a.out.h inclusions.
> 
>  (6) Drops A.OUT support for Blackfin (according to Mike Frysinger it's not
>      needed).
>...

I do not like this patch for the following reasons:
- too many cleanups lumped into one patch
- it adds #ifdef's in fs/binfmt_elf.c for code that is anyway
  scheduled for removal in 2.6.25

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

