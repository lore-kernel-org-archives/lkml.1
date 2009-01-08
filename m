Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbZAHS12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbZAHS12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbZAHS1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:27:20 -0500
Received: from mail.impinj.com ([206.169.229.170]:46822 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753581AbZAHS1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:27:19 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Subject: Re: amd5536udc interrupts bug
Date: Thu, 8 Jan 2009 10:27:18 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49661E83.2070703@arcor.de> <49662C7C.2040500@arcor.de>
In-Reply-To: <49662C7C.2040500@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081027.18662.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 08 Jan 2009 18:27:19.0025 (UTC) FILETIME=[BD4A2E10:01C971BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009 08:40:28 Thomas Dahlmann wrote:
> Ah, right. Thanks for your analysis! Never ran into this condition as on
> the Geode systems I had the IRQ is shared between UDC and 
UOC/OTG
> (both on the CS5536 chip) and UOC never fires interrupts while UDC
> driver is loaded as both drivers (UOC/OTG driver is not in the kernel 
yet)
> register each other which makes sure that interrupts are enabled
> after  udc_pci_probe().

Ok, I understand.

> I could provide a fix within the next weeks. Currently I move to another
> company and
> have no hardware to test it.

No worries. :) I can also test your patches on my board here, if it helps 
any.

> Maybe you want to try this. It should work to place the register init
> from udc_probe()
>
> /* udc csr registers base */
> dev->csr = dev->virt_addr + UDC_CSR_ADDR;
> /* dev registers base */
> dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
> /* ep registers base */
> dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
> /* fifo's base */
> dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
> dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);
>
> just before request_irq(...) to allow the interrupt handler to read the
> interrupt status
> registers.

I'll slip this into the next kernel build and see what happens. Thanks!

-- Vadim Lobanov

