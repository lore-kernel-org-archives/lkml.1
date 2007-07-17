Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbXGQIzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbXGQIzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXGQIzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:55:35 -0400
Received: from out002.atlarge.net ([129.41.63.60]:32540 "EHLO
	out002.atlarge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbXGQIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:55:35 -0400
Date: Tue, 17 Jul 2007 10:55:32 +0200
From: Domen Puncer <domen.puncer@telargo.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce __init_exit function annotation
Message-ID: <20070717085532.GL4375@moe.telargo.com>
References: <20070717080248.GK4375@moe.telargo.com> <20070717083156.GB3801@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717083156.GB3801@stusta.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 17 Jul 2007 08:55:06.0025 (UTC) FILETIME=[2BBF6190:01C7C850]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07 10:31 +0200, Adrian Bunk wrote:
> On Tue, Jul 17, 2007 at 10:02:48AM +0200, Domen Puncer wrote:
> > Introduce __init_exit, which is useful ie. for drivers that call
> > cleanup functions when they fail in __init functions.
> > 
> > 
> > Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
> > ---
> >  include/linux/init.h |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: work-powerpc.git/include/linux/init.h
> > ===================================================================
> > --- work-powerpc.git.orig/include/linux/init.h
> > +++ work-powerpc.git/include/linux/init.h
> > @@ -60,8 +60,10 @@
> >  
> >  #ifdef MODULE
> >  #define __exit		__attribute__ ((__section__(".exit.text")))
> > +#define __init_exit
> >  #else
> >  #define __exit		__attribute_used__ __attribute__ ((__section__(".exit.text")))
> > +#define __init_exit	__init
> >  #endif
> >  
> >  /* For assembly routines */
> 
> This doesn't work on architectures like i386 where __exit code is
> discarded at runtime.

If it's a module, then it shouldn't be discarded until unload anyway.
If it's in-kernel, then it'll be discarded as __init stuff.
I don't see a problem?

BTW. can you point me to reasoning for discarding __exit at runtime?


	Domen

> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
