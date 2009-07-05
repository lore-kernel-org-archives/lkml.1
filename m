Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZGEDML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZGEDML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 23:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZGEDMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 23:12:00 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:53789 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbZGEDL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 23:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j3Hz+BfvSWWwmrP7fWzSvl6qQmcjfZ4UFM3gKiEJ2oRh5dWBNZRkFhn4t4433by42+
         7umWB70esK6nK6SKu0K5z2iPk5x0SDc3aRaqlQTvmakAVewwOUj6A52IMw28o+3pG9rf
         cjTBuXaF96IFgR7N9bW8CNdP66SIJPICHwa1U=
Subject: Re: [PATCH]mempool.c : clean up type-casting twice
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090705030100.GA9341@elte.hu>
References: <1246762120.15308.3.camel@myhost>
	 <20090705030100.GA9341@elte.hu>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 11:11:56 +0800
Message-Id: <1246763517.15308.10.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-05 at 05:01 +0200, Ingo Molnar wrote:
> * Figo.zhang <figo1802@gmail.com> wrote:
> 
> > clean up type-casting twice
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > ---   
> > mm/mempool.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/mempool.c b/mm/mempool.c
> > index a46eb1b..0aec628 100644
> > --- a/mm/mempool.c
> > +++ b/mm/mempool.c
> > @@ -303,7 +303,7 @@ EXPORT_SYMBOL(mempool_free_slab);
> >   */
> >  void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
> >  {
> > -	size_t size = (size_t)(long)pool_data;
> > +	size_t size = (size_t)pool_data;
> >  	return kmalloc(size, gfp_mask);
> >  }
> >  EXPORT_SYMBOL(mempool_kmalloc);
> > @@ -327,14 +327,14 @@ EXPORT_SYMBOL(mempool_kfree);
> >   */
> >  void *mempool_alloc_pages(gfp_t gfp_mask, void *pool_data)
> >  {
> > -	int order = (int)(long)pool_data;
> > +	int order = (int)pool_data;
> >  	return alloc_pages(gfp_mask, order);
> >  }
> >  EXPORT_SYMBOL(mempool_alloc_pages);
> >  
> >  void mempool_free_pages(void *element, void *pool_data)
> >  {
> > -	int order = (int)(long)pool_data;
> > +	int order = (int)pool_data;
> >  	__free_pages(element, order);
> 
> What's the motivation?
> 
> On 64-bit platforms, casting from a pointer (64-bit) straight to int 
> (32-bit) can lose information and is thus a potential source of 
> bugs, so certain compilers will warn about it with:
> 
>    warning: cast from pointer to integer of different size
> 
> The double cast is a "I know what I'm doing" signal.
> 

thanks.


void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
{
	size_t size = (size_t)(long)pool_data;
	return kmalloc(size, gfp_mask);
}

void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data)
{
	size_t size = (size_t) pool_data;
	return kzalloc(size, gfp_mask);
}

at this point, is it no need for type-casting twice ? because size_t is
typedef "unsigned int" in x86_32, "unsigned long " in x86_64.

Best,
Figo.zhang

