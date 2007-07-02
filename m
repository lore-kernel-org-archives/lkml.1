Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXGBC1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXGBC1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 22:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbXGBC1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 22:27:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47133 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755940AbXGBC1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 22:27:33 -0400
Date: Mon, 2 Jul 2007 04:27:59 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       jsipek@cs.sunysb.edu, linux-kernel@vger.kernel.org,
       unionfs@filesystems.org
Subject: Re: [-mm patch] unionfs: make functions static
Message-ID: <20070702022759.GE10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070701202330.GU10869@stusta.de> <20070702014249.GA14417@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070702014249.GA14417@filer.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 09:42:49PM -0400, Josef Sipek wrote:
> On Sun, Jul 01, 2007 at 10:23:30PM +0200, Adrian Bunk wrote:
> > This patch makes some needlessly global functions static.
> > 
> ...
> > --- linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c.old	2007-07-01 00:05:02.000000000 +0200
> > +++ linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c	2007-07-01 00:06:05.000000000 +0200
> > @@ -18,6 +18,8 @@
> >  
> >  #include "union.h"
> >  
> > +static int realloc_dentry_private_data(struct dentry *dentry);
> > +
> >  /* is the filename valid == !(whiteout for a file or opaque dir marker) */
> 
> I forget who said it, but someone wasn't very happy with prototypes like
> that in .c files. What's the prefered way - are they ok for static symbols?

It might have even been me who said this - but about global functions.

For global functions, prototypes in header files allow gcc to check 
whether the prototype matches the actual function. With a prototype
in the C file of the caller that's not possible, and if they are 
different it can result in nasty runtime errors.

For static functions that's not an issue since gcc sees both the 
prototype and the actual function.

> Josef "Jeff" Sipek.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

