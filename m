Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbXJ0RRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbXJ0RRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXJ0RRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:17:30 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35011 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbXJ0RRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:17:30 -0400
Date: Sat, 27 Oct 2007 13:14:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] SG: set names for numeric constants
In-Reply-To: <20071027170228.GA7257@cvg>
Message-ID: <Pine.LNX.4.64.0710271312190.9802@localhost.localdomain>
References: <20071027170228.GA7257@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Oct 2007, Cyrill Gorcunov wrote:

>
> This patch defines names for numeric constants that
> used in scatter list for more convenient code reading.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
...
> @@ -73,7 +76,7 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
>  	sg->length = len;
>  }
>
> -#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
> +#define sg_page(sg)	((struct page *) ((sg)->page_link & ~SG_MASK))
>
> -#define sg_is_chain(sg)		((sg)->page_link & 0x01)
> -#define sg_is_last(sg)		((sg)->page_link & 0x02)
> +#define sg_is_chain(sg)		((sg)->page_link & SG_CHAIN)
> +#define sg_is_last(sg)		((sg)->page_link & SG_LAST)
>  #define sg_chain_ptr(sg)	\
> -	((struct scatterlist *) ((sg)->page_link & ~0x03))
> +	((struct scatterlist *) ((sg)->page_link & ~SG_MASK))

while you're at it, could you move all those macros to the top of the
file, rather than leaving them scattered across the first 100 lines or
so?  it would just make them easier to find when you're perusing the
code.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
