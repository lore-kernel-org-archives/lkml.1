Return-Path: <linux-kernel-owner+w=401wt.eu-S1761606AbXHAJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbXHAJuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760848AbXHAJuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:50:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:55864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428AbXHAJuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:50:19 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] type safe allocator
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Aug 2007 12:44:52 +0200
In-Reply-To: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu>
Message-ID: <p73myxbpm8r.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> I wonder why we don't have type safe object allocators a-la new() in
> C++ or g_new() in glib?
> 
>   fooptr = k_new(struct foo, GFP_KERNEL);
> 
> is nicer and more descriptive than
> 
>   fooptr = kmalloc(sizeof(*fooptr), GFP_KERNEL);
> 
> and more safe than
> 
>   fooptr = kmalloc(sizeof(struct foo), GFP_KERNEL);

How is it more safe? It seems 100% equivalent to me,
just a different syntax.

> 
> And we have zillions of both variants.

In my own non kernel code i tend to define a pascal style NEW()

#define NEW(p) ((p) = malloc(sizeof(*(p))))

But I'm not sure such a untraditional solution would too popular.

Also I don't think we have too many bugs in this area anyways; so
it might be better to concentrate on more fruitful areas.

-Andi
