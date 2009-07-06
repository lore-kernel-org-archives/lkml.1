Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbZGFAC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbZGFAC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 20:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbZGFACR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 20:02:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:55489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbZGFACR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 20:02:17 -0400
Date: Sun, 5 Jul 2009 17:03:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] RO/NX protection for loadable kernel modules
Message-ID: <20090705170306.5916293a@infradead.org>
In-Reply-To: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
References: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009 19:23:56 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> 
> By default, the original section layout is preserved and RO/NX is
> enforced only for whole pages of same content.
> However, when compiled with CONFIG_DEBUG_RODATA=y, the patch
> will page-align each group of section to ensure that each page
> contains only one type of content mentioned above.

I like it.

A few minor nitpicks below, but again, I like this.


> +
> +/* Given a virtual address returns 1 if the address is page-aligned,
> + * 0 otherwise */
> +#define PAGE_ALIGNED(ADDR) (((unsigned long) ADDR & \
> +				((1UL << PAGE_SHIFT) - 1UL)) ? \
> +					(0) : (1))

there is a #define IS_ALIGNED in include/linux/kernel.h... can that be
used either directly or wrapped around?


> +
> +/* Given a virtual address returns a virtual page number
> + * that contains that address */
> +#define PAGE_NUMBER(ADDR) (((unsigned long) ADDR) >> PAGE_SHIFT)

this is PFN_DOWN() from include/linux/pfn.h

there is also a PFN_UP(), which might be useful in your code where
you first round down, and then skip the first page if it's partial...
... might be able to just round up from the start instead...





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
