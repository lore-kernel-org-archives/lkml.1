Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbXH1OnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbXH1OnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXH1Omu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:42:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43369 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786AbXH1Omt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:42:49 -0400
Date: Tue, 28 Aug 2007 16:42:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Gabriel C <nix.or.die@googlemail.com>,
       linux-kernel@vger.kernel.org, Olaf Hering <olh@suse.de>,
       netdev@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-ID: <20070828144248.GR26410@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de> <20070828003704.deed71ae.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070828003704.deed71ae.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 12:37:04AM -0700, Andrew Morton wrote:
> On Mon, 27 Aug 2007 23:27:43 +0200 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Wed, Aug 22, 2007 at 03:33:27PM +0200, Gabriel C wrote:
> > >...
> > > WARNING: "div64_64" [net/netfilter/xt_connbytes.ko] has no CRC!
> > >...
> > 
> > Patch below.
> > 
> > > Regards,
> > > 
> > > Gabriel
> > 
> > cu
> > Adrian
> > 
> > 
> > <--  snip  -->
> > 
> > 
> > This patch makes the 64bit integers on 32bit architectures usable for
> > all C parsers that know about "long long".
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> 
> Given that this patch (hopefully) fixes a problem in the current net-2.6.24
> tree, I'm inclined to slip it into mainline immediately.

It fixes a bug exposed by a -mm only patch, not by the net tree
(and 2.6.23-rc3-mm1 doesn't contain the net tree at all).

> But I'd like a better description, please.  Which "non-gcc parser" are we
> talking about here?  Something under ./scripts/.  Well, please identify it,
> and describe what the problem is, and how the proposed patch will address
> it.
>...

It's about parsers like the Sun C compiler and the C parser shipped 
with genksyms.

We can fix the C parser shipped with genksyms, but we have nearly the 
same problem with userspace C parsers:

These are userspace headers, and we had a bug report that the Sun C 
compiler was not able to compile some userspace code.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

