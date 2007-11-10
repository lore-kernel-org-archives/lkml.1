Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXKJEFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXKJEFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 23:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbXKJEFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 23:05:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35727 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbXKJEFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 23:05:38 -0500
Subject: Re: [PATCH 6/6] MN10300: Add MTD flash support for the ASB2303
	board [try #5]
From: David Woodhouse <dwmw2@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
In-Reply-To: <20071109153503.20803.69203.stgit@warthog.procyon.org.uk>
References: <20071109153432.20803.69832.stgit@warthog.procyon.org.uk>
	 <20071109153503.20803.69203.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 23:05:38 -0500
Message-Id: <1194667538.2588.49.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dunno why it's called "try #5" when I haven't directly received it even
once yet.

On Fri, 2007-11-09 at 15:35 +0000, David Howells wrote:
> Add MTD flash support for the ASB2303 board.

We're trying to avoid taking new simple map drivers -- you should be
able to use a platform device instead.

> --- a/drivers/mtd/chips/jedec_probe.c
> +++ b/drivers/mtd/chips/jedec_probe.c
> @@ -1883,11 +1883,13 @@ static inline __u8 finfo_uaddr(const struct amd_flash_info *finfo, int device_ty
>  
>  	uaddr = finfo->uaddr[uaddr_idx];
>  
> +#ifndef CONFIG_MN10300_UNIT_ASB2303
>  	if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
>  		/* ASSERT("The unlock addresses for non-8-bit mode
>  		   are bollocks. We don't really need an array."); */
>  		uaddr = finfo->uaddr[0];
>  	}
> +#endif

I think this is a NOP for the chip in question anyway, isn't it?

-- 
dwmw2

