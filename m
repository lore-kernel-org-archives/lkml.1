Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbXHBNHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbXHBNHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbXHBNHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:07:20 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:41857 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbXHBNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:07:18 -0400
To: jengelh@computergmbh.de
CC: adobriyan@gmail.com, miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
In-reply-to: <Pine.LNX.4.64.0708021417400.24572@fbirervta.pbzchgretzou.qr>
	(message from Jan Engelhardt on Thu, 2 Aug 2007 14:24:44 +0200 (CEST))
Subject: Re: [PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> 
 <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu> <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com> <Pine.LNX.4.64.0708021417400.24572@fbirervta.pbzchgretzou.qr>
Message-Id: <E1IGaOE-0001a3-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Aug 2007 15:06:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Aug 2 2007 16:04, Alexey Dobriyan wrote:
> >On 8/2/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>   fooptr = kmalloc(sizeof(struct foo), ...);
> >
> >Key word is "traditional". Good traditional form which even half-competent
> >C programmers immediately parse in retina.
> 
> And being aware of the potential type-unsafety makes programmers more
> careful IMHO.

That's a _really_ good reason ;)

> >> +/**
> >> + * alloc_struct - allocate given type object
> >> + * @type: the type of the object to allocate
> >> + * @flags: the type of memory to allocate.
> >> + */
> >> +#define alloc_struct(type, flags) ((type *) kmalloc(sizeof(type), flags))
> 
> >someone will write alloc_struct(int, GFP_KERNEL), I promise.
> 
> and someone else will write
> 
> 	struct complexthing foo;
> 	alloc_struct(foo, GFP_KERNEL);

And the compiler will complain like mad about that.

Miklos
