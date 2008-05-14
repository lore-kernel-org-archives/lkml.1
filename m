Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbYENP56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbYENP56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYENP5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:57:49 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41944 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYENP5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:57:49 -0400
Date: Wed, 14 May 2008 18:56:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andreas Schwab <schwab@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514155611.GB22115@cs181133002.pp.htv.fi>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de> <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de> <20080514153059.GA22115@cs181133002.pp.htv.fi> <20080514154801.GG6902@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080514154801.GG6902@cvg>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 07:48:01PM +0400, Cyrill Gorcunov wrote:
> [Adrian Bunk - Wed, May 14, 2008 at 06:30:59PM +0300]
> | On Wed, May 14, 2008 at 04:28:24PM +0200, Andreas Schwab wrote:
> | > Adrian Bunk <bunk@kernel.org> writes:
> | > 
> | > > Or replace all the strlen stuff in include/asm-m68k/string.h with a 
> | > 
> | > I don't think the strlen macros has any influence in this case (it
> | > already uses __builtin_strlen anyway).
> | 
> | The problem is that it sets __HAVE_ARCH_STRLEN, and therefore the 
> | out-of-line function in lib/string.c is not built.
> | 
> | That breaks when gcc replaces a call to a different function with a call 
> | to strlen().
> | 
> | > I'd rather guess that gcc is
> | > expanding strncat internally to something involving strlen with
> | > non-constant argument,
> | 
> | We agree on this one.
> | 
> | > although I cannot see how that can happen from a
> | > quick look.
> | 
> | It isn't the first time we have these problems in the kernel...
> | 
> | > Andreas.
> | 
> | cu
> | Adrian
> 
> Adrian, I've just sent the updated patch, and accidentally forget
> to CC you - please take a look on http://lkml.org/lkml/2008/5/14/267

It removes the strncat() calls and should therefore remove the current 
compile error.

But the underlying problem that actually causes the compile error is not 
fixed and might occur again in other places (but that's nothing you 
have to worry about).

> 		- Cyrill -

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

