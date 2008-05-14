Return-Path: <linux-kernel-owner+w=401wt.eu-S1763641AbYENPcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763641AbYENPcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYENPci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:32:38 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37196 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbYENPch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:32:37 -0400
Date: Wed, 14 May 2008 18:30:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andreas Schwab <schwab@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514153059.GA22115@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de> <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <jeabitt0xj.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 04:28:24PM +0200, Andreas Schwab wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > Or replace all the strlen stuff in include/asm-m68k/string.h with a 
> 
> I don't think the strlen macros has any influence in this case (it
> already uses __builtin_strlen anyway).

The problem is that it sets __HAVE_ARCH_STRLEN, and therefore the 
out-of-line function in lib/string.c is not built.

That breaks when gcc replaces a call to a different function with a call 
to strlen().

> I'd rather guess that gcc is
> expanding strncat internally to something involving strlen with
> non-constant argument,

We agree on this one.

> although I cannot see how that can happen from a
> quick look.

It isn't the first time we have these problems in the kernel...

> Andreas.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

