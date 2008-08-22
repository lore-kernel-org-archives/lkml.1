Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbYHVHka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbYHVHka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYHVHkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:40:22 -0400
Received: from mail.atmel.fr ([81.80.104.162]:34184 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYHVHkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:40:21 -0400
Message-ID: <48AE6D50.4030609@atmel.com>
Date: Fri, 22 Aug 2008 09:40:00 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Andrew Victor <linux@maxim.org.za>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 2.6.27-rc3] at91_mci: don't use coherent dma buffers
References: <200808181607.21516.david-b@pacbell.net>
In-Reply-To: <200808181607.21516.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre, Andrew,

You can add my...

David Brownell :
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> At91_mci is abusing dma_free_coherent(), which may not be called
> with IRQs disabled.  I saw "mkfs.ext3" on an MMC card objecting
> voluminously as each write completed:
> 
>  WARNING: at arch/arm/mm/consistent.c:368 dma_free_coherent+0x2c/0x224()
>  [<c002726c>] (dump_stack+0x0/0x14) from [<c00387d4>] (warn_on_slowpath+0x4c/0x68)
>  [<c0038788>] (warn_on_slowpath+0x0/0x68) from [<c0028768>] (dma_free_coherent+0x2c/0x224)
>   r6:00008008 r5:ffc06000 r4:00000000
>  [<c002873c>] (dma_free_coherent+0x0/0x224) from [<c01918ac>] (at91_mci_irq+0x374/0x420)
>  [<c0191538>] (at91_mci_irq+0x0/0x420) from [<c0065d9c>] (handle_IRQ_event+0x2c/0x6c)
>  ...
> 
> This bug has been around for a LONG time.  The MM warning is
> from late 2005, but the driver merged a year later ... so I'm
> puzzled why nobody noticed this before now.
> 
> The fix involves noting that this buffer shouldn't be DMA-coherent;
> it's just used for normal DMA writes.  So replace it with standard
> kmalloc() buffering and DMA mapping calls.
> 
> This is the quickie fix.  A better one would not rely on allocating
> large bounce buffers.  (Note that dma_alloc_coherent could have failed
> too, but that case was ignored... kmalloc is a bit more likely to
> fail though.)
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

...

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>


-- 
Nicolas Ferre

