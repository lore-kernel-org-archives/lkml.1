Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXHBHk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXHBHk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXHBHkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:40:52 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:51868 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXHBHkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:40:52 -0400
To: satyam@infradead.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <alpine.LFD.0.999.0708021302500.8258@enigma.security.iitk.ac.in>
	(message from Satyam Sharma on Thu, 2 Aug 2007 13:07:47 +0530 (IST))
Subject: Re: [RFC PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> <alpine.LFD.0.999.0708021302500.8258@enigma.security.iitk.ac.in>
Message-Id: <E1IGVIO-0000tT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Aug 2007 09:40:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  
> > +/**
> > + * k_new - allocate given type object
> > + * @type: the type of the object to allocate
> > + * @flags: the type of memory to allocate.
> > + */
> > +#define k_new(type, flags) ((type *) kmalloc(sizeof(type), flags))
> 
> What others already said, plus:
> 
> kmalloc()'ing sizeof(struct foo) is not always what we want in C either.
> 
> Several kernel structs have zero-length / variable-length array members
> and space must be allocated for them only at alloc() time ... would be
> impossible to make them work with this scheme.

Exactly.  We can, and should use kmalloc() for that.

Miklos
