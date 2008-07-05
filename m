Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYGEIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYGEIfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYGEIfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 04:35:23 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:2800 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYGEIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 04:35:22 -0400
Date: Sat, 5 Jul 2008 10:34:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/20] lib: generic show_mem()
Message-ID: <20080705083445.GA5454@osiris.boeblingen.de.ibm.com>
References: <20080704160737.750988999@saeurebad.de> <20080704161452.730548249@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704161452.730548249@saeurebad.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 06:07:39PM +0200, Johannes Weiner wrote:
> This implements a platform-independent version of show_mem().
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
> ---
>  lib/Makefile   |    2 -
>  lib/show_mem.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 1 deletion(-)
> 
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
>  	 rbtree.o radix-tree.o dump_stack.o \
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
> -	 proportions.o prio_heap.o ratelimit.o
> +	 proportions.o prio_heap.o ratelimit.o show_mem.o
> 
>  ifdef CONFIG_FTRACE
>  # Do not profile string.o, since it may be used in early boot or vdso
> --- /dev/null
> +++ b/lib/show_mem.c
> @@ -0,0 +1,63 @@
> +/*
> + * Generic show_mem() implementation
> + *
> + * Copyright (C) 2008 Johannes Weiner <hannes@saeurebad.de>
> + * All code subject to the GPL version 2.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/nmi.h>
> +#include <linux/quicklist.h>
> +
> +void show_mem(void)
> +{

Umh.. I think your 4th patch set was the way to go. This set is not
bisectable anymore and those architectures which you didn't convert
to the generic implementation won't build anymore. show_mem is present
twice there...

You might solve this by adding an __attribute__((weak)) but I'm sure
people will complain again, because it produces dead code for all
architectures which got converted.
