Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZAILlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZAILlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 06:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZAILlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 06:41:37 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:42575 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbZAILlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 06:41:36 -0500
Message-ID: <496737E1.1090607@arcor.de>
Date: Fri, 09 Jan 2009 12:41:21 +0100
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Vadim Lobanov <vlobanov@speakeasy.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: amd5536udc interrupts bug
References: <49661E83.2070703@arcor.de> <49662C7C.2040500@arcor.de> <200901081802.43625.vlobanov@speakeasy.net>
In-Reply-To: <200901081802.43625.vlobanov@speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vadim Lobanov schrieb:
> On Thursday 08 January 2009 08:40:28 Thomas Dahlmann wrote:
>   
>> Maybe you want to try this. It should work to place the register init
>> from udc_probe()
>>
>> /* udc csr registers base */
>> dev->csr = dev->virt_addr + UDC_CSR_ADDR;
>> /* dev registers base */
>> dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
>> /* ep registers base */spin_lock_init(&dev->lock);
>> dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
>> /* fifo's base */
>> dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
>> dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);
>>
>> just before request_irq(...) to allow the interrupt handler to read the
>> interrupt status
>> registers.
>>     
>
> I did this. Actually, I also yanked the "spin_lock_init(&dev->lock)" bit 
> before the request_irq() as well, since that field was also obviously 
> needed for the irq routine. (I didn't check for any other necessary but 
> less-obvious fields.) With these changes, the module modprobes just 
> fine.
>   

Thanks for the test!

> Alas, the hardware doesn't work. When I try plugging in the other end of 
> the USB cable, absolutely nothing happens. Not even an interrupt: 
> /proc/interrupts for the amd5536udc line stays at zero. Any thoughts on 
> possible ways to tackle this / what could be going wrong / etc?
>   

Is there any output in the kernel messages on the host side complaining 
about that device is
not answering? If not than USB device port is probably not connected to 
UDC PHY. Please
check in BIOS setup that port 4 is assigned to UDC.

This will set bits PAD_EN and APU in UOC controller (DEVID 0x2097):
http://www.amd.com/files/connectivitysolutions/geode/geode_lx/33238G_cs5536_db.pdf

Thomas
> -- Vadim Lobanov
>
>   


