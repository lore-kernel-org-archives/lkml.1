Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZGGQUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZGGQUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbZGGQT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:19:59 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:38357 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984AbZGGQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hYSxpoTz/pLw5ekEXi5s1rW1Dq/Mhd9LdtBCsLmZVFpmSiZN6R335GUaQ8w8+HmUb/
         xFc3IbqlbE9Zx+lBULR2tNsfaWhjfuxNmVY7WKGqX263CPCdyPm1csgmSEE7aFdl+/on
         MoQha0wd1niPNy/fHcZ/iSeSSvxycGkLv6tWU=
Subject: Re: [PATCH] vmalloc.c: fix vmap_page_range() return
From: "Figo.zhang" <figo1802@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1246960849.2581.29.camel@myhost>
References: <1246960849.2581.29.camel@myhost>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 00:19:49 +0800
Message-Id: <1246983589.2597.16.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 18:00 +0800, Figo.zhang wrote:
> vmap_page_range() would never return a positive number.

hmm, it is my mistake. vmap_pud_range() will return the succeed mapped
page number.

Best,
Figo.zhang


> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> --- 
> mm/vmalloc.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index f8189a4..bbd312d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1109,10 +1109,6 @@ int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
>  	int err;
>  
>  	err = vmap_page_range(addr, end, prot, *pages);
> -	if (err > 0) {
> -		*pages += err;
> -		err = 0;
> -	}
>  
>  	return err;
>  }
> 

