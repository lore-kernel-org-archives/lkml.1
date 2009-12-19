Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbZLSLgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbZLSLgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 06:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZLSLgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 06:36:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51546 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZLSLgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 06:36:11 -0500
Date: Sat, 19 Dec 2009 12:36:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
Subject: Re: [PATCH] new kqueue API v.08
Message-ID: <20091219113609.GB9321@basil.fritz.box>
References: <1261179026.16900.42.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261179026.16900.42.camel@wall-e>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I like the basic idea of a type safe FIFO.

> #define	DYNAMIC
> #ifdef DYNAMIC
> static DECLARE_KFIFO_PTR(test[1], int);
> #else
> static DECLARE_KFIFO(test[1], int, FIFO_SIZE);

The [1] looks weird.  Is that really needed and what does it mean?
The callers below don't seem to use it like an array.

> I know that this kind of macros are very sophisticated and not easy to
> maintain. But i have all tested and it works as expected. I analyzed the
> output of the compiler and for the x86 the code is as good as hand
> written assembler code.

Linux has a long tradition of complicated macros in headers, that shouldn't be a 
problem.

>  include/linux/kfifo.h | 1107 +++++++++++++++++++++++++++++---------------------
>  kernel/kfifo.c        |  768 +++++++++++++++++++++++-----------
>  2 files changed, 1174 insertions(+), 701 deletions(-)
> 
> diff -u -N -r -p mmotm.orig/include/linux/kfifo.h mmotm.new/include/linux/kfifo.h
> --- mmotm.orig/include/linux/kfifo.h	2009-12-19 00:23:12.510334931 +0100
> +++ mmotm.new/include/linux/kfifo.h	2009-12-19 00:23:04.375307229 +0100
> @@ -1,8 +1,7 @@
>  /*
> - * A generic kernel FIFO implementation.
> + * A generic kernel fifo implementation
>   *
>   * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
> - * Copyright (C) 2004 Stelian Pop <stelian@popies.net>

You should probably keep the old copyright, even if not much code remains.

> +#ifdef __KERNEL__
>  #include <linux/kernel.h>
>  #include <linux/spinlock.h>
> +#include <linux/stddef.h>
> +#include <linux/scatterlist.h>
> +#else
> +#include "helper.h"
> +#endif

Such ifdefs should not make it into submitted code. Better use more glue
in the test program.


... didn't review the whole thing at this point ...

-Andi
