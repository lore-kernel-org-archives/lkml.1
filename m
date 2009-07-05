Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZGEJNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZGEJNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZGEJNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:13:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:4662 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZGEJNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xuW4xOSGiikrWo/+u8XCRzM+GStl3Ioq5jDunTWbL1g1fgSgyOiY9DjlnW6pJXIP8q
         BlIDKTbqZ9bPqX5yaaP2X6zPbRk3qEuZ5A09jeDSF0/7/zTgrYiXV6eCK+ndmxVRz1Oc
         SZdOJScs3ZuU4IXhoxnQOTOiJ/RvIUgYilqR4=
Subject: Re: [PATCH v3]mempool.c : clean up type-casting twice
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090705090441.GA24502@elte.hu>
References: <1246762120.15308.3.camel@myhost>
	 <1246766651.15308.13.camel@myhost> <1246784484.4358.3.camel@myhost>
	 <20090705090441.GA24502@elte.hu>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 17:13:36 +0800
Message-Id: <1246785216.4358.4.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-05 at 11:04 +0200, Ingo Molnar wrote:
> * Figo.zhang <figo1802@gmail.com> wrote:
> 
> > clean up type-casting twice. "size_t" typedef as "unsigned long" in 64-bit system,
> > and "unsigned int" in 32-bit system.
> 
> [
>   You should line-length limit your changelogs btw., to 60 
>   characters or so. git log will add another 4 characters. The 
>   ~/.vimrc magic for this is:
> 
>   autocmd BufNewFile,BufRead *.patch setlocal textwidth=60
> ]

hi,Ingo,

Thanks a lot.

should i motify the log, and send it again?

Best,
Figo.zhang


> 
> > 
> > in v3, remove the space to casts.
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > ---    
> > mm/mempool.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/mempool.c b/mm/mempool.c
> > index a46eb1b..32e75d4 100644
> > --- a/mm/mempool.c
> > +++ b/mm/mempool.c
> > @@ -303,14 +303,14 @@ EXPORT_SYMBOL(mempool_free_slab);
> >   */
> >  void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
> >  {
> > -	size_t size = (size_t)(long)pool_data;
> > +	size_t size = (size_t)pool_data;
> >  	return kmalloc(size, gfp_mask);
> >  }
> >  EXPORT_SYMBOL(mempool_kmalloc);
> >  
> >  void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data)
> >  {
> > -	size_t size = (size_t) pool_data;
> > +	size_t size = (size_t)pool_data;
> >  	return kzalloc(size, gfp_mask);
> >  }
> >  EXPORT_SYMBOL(mempool_kzalloc);
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> 	Ingo

