Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZAICCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZAICCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZAICCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:02:45 -0500
Received: from mail.impinj.com ([206.169.229.170]:32194 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbZAICCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:02:44 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Subject: Re: amd5536udc interrupts bug
Date: Thu, 8 Jan 2009 18:02:43 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49661E83.2070703@arcor.de> <49662C7C.2040500@arcor.de>
In-Reply-To: <49662C7C.2040500@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081802.43625.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 09 Jan 2009 02:02:43.0864 (UTC) FILETIME=[5C29B980:01C971FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009 08:40:28 Thomas Dahlmann wrote:
> Maybe you want to try this. It should work to place the register init
> from udc_probe()
>
> /* udc csr registers base */
> dev->csr = dev->virt_addr + UDC_CSR_ADDR;
> /* dev registers base */
> dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
> /* ep registers base */spin_lock_init(&dev->lock);
> dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
> /* fifo's base */
> dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
> dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);
>
> just before request_irq(...) to allow the interrupt handler to read the
> interrupt status
> registers.

I did this. Actually, I also yanked the "spin_lock_init(&dev->lock)" bit 
before the request_irq() as well, since that field was also obviously 
needed for the irq routine. (I didn't check for any other necessary but 
less-obvious fields.) With these changes, the module modprobes just 
fine.

Alas, the hardware doesn't work. When I try plugging in the other end of 
the USB cable, absolutely nothing happens. Not even an interrupt: 
/proc/interrupts for the amd5536udc line stays at zero. Any thoughts on 
possible ways to tackle this / what could be going wrong / etc?

-- Vadim Lobanov

