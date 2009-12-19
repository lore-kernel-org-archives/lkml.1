Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZLSXZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZLSXZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZLSXZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:25:37 -0500
Received: from www84.your-server.de ([213.133.104.84]:37535 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZLSXZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:25:36 -0500
Subject: Re: [PATCH] new kqueue API v.08
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>, Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
In-Reply-To: <20091219113609.GB9321@basil.fritz.box>
References: <1261179026.16900.42.camel@wall-e>
	 <20091219113609.GB9321@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 20 Dec 2009 00:25:15 +0100
Message-ID: <1261265115.26268.11.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 19.12.2009, 12:36 +0100 schrieb Andi Kleen:
> I like the basic idea of a type safe FIFO.
> 
> > #define	DYNAMIC
> > #ifdef DYNAMIC
> > static DECLARE_KFIFO_PTR(test[1], int);
> > #else
> > static DECLARE_KFIFO(test[1], int, FIFO_SIZE);
> 
> The [1] looks weird.  Is that really needed and what does it mean?
> The callers below don't seem to use it like an array.

I am a lazy girl. This is only for convenient, because i don't want to
write always kfifo_....(&test...). Using an array of [1] provide the
pointer automaticly. Of course you can also write

static DECLARE_KFIFO(test, int, FIFO_SIZE);

and then call the kfifo macros with the address of the variable.
 
> 
> > I know that this kind of macros are very sophisticated and not easy to
> > maintain. But i have all tested and it works as expected. I analyzed the
> > output of the compiler and for the x86 the code is as good as hand
> > written assembler code.
> 
> Linux has a long tradition of complicated macros in headers, that shouldn't be a 
> problem.
> 

I know, but this are in my opinion the most complicated macros for
linux.

> >  include/linux/kfifo.h | 1107 +++++++++++++++++++++++++++++---------------------
> >  kernel/kfifo.c        |  768 +++++++++++++++++++++++-----------
> >  2 files changed, 1174 insertions(+), 701 deletions(-)
> > 
> > diff -u -N -r -p mmotm.orig/include/linux/kfifo.h mmotm.new/include/linux/kfifo.h
> > --- mmotm.orig/include/linux/kfifo.h	2009-12-19 00:23:12.510334931 +0100
> > +++ mmotm.new/include/linux/kfifo.h	2009-12-19 00:23:04.375307229 +0100
> > @@ -1,8 +1,7 @@
> >  /*
> > - * A generic kernel FIFO implementation.
> > + * A generic kernel fifo implementation
> >   *
> >   * Copyright (C) 2009 Stefani Seibold <stefani@seibold.net>
> > - * Copyright (C) 2004 Stelian Pop <stelian@popies.net>
> 
> You should probably keep the old copyright, even if not much code remains.
> 

No, all previous code has gone. I use the counter fifo technique since
many years, so the basic idea is very old. 
 
> > +#ifdef __KERNEL__
> >  #include <linux/kernel.h>
> >  #include <linux/spinlock.h>
> > +#include <linux/stddef.h>
> > +#include <linux/scatterlist.h>
> > +#else
> > +#include "helper.h"
> > +#endif
> 
> Such ifdefs should not make it into submitted code. Better use more glue
> in the test program.

Will be fixed after review.

> 
> 
> ... didn't review the whole thing at this point ...

Would be great if you can do this.

Stefani


