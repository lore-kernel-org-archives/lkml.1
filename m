Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181Ab0A2Rxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0A2Rxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331Ab0A2Rxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:53:47 -0500
Received: from gateway-2929.mvista.com ([206.112.117.47]:34968 "HELO
	gateway-2929.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752153Ab0A2Rxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:53:47 -0500
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 12:53:47 EST
Message-ID: <4B632033.2010309@ru.mvista.com>
Date: Fri, 29 Jan 2010 20:51:47 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-usb@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB mass storage and ARM cache coherency
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>	 <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com> <1264782843.4242.91.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1264782843.4242.91.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Catalin Marinas wrote:

>>> I've been trying for some time to use a rootfs (ext2) on a USB memory
>>> stick on ARM platforms but without any success. The USB HCD driver is
>>> ISP1760 which doesn't use DMA.
>>>
>>> ARM has a Harvard cache architecture and what I get is incoherency
>>> between the I and D caches. The CPU I'm using (ARM11MPCore) has PIPT
>>> caches with D-cache lines allocation on write.
>>>
>>> Basically, when user space tries to execute from a new page, it faults
>>> and the data is requested via the VFS layer, SCSI block device and USB
>>> mass storage from the ISP1760 driver. The page is then mapped into user
>>> space and update_mmu_cache() called.
>>>
>>> However, since the driver is PIO, the data copied from the USB device
>>> into RAM gets stuck in the D-cache. On the above page requesting path
>>> there is no call to flush_dcache_page() to handle D-cache maintenance
>>> (for DMA drivers, that's handled by the DMA API).
>>>
>>> Since the USB mass storage code has the information about the USB driver
>>>       
>> Sorry,  I am a little confused that usb mass storage has what information
>> about DMA or PIO of low level usb transfer?
>>     
>
> I was thinking about checking dev->bus->controller->dma_mask which the
> code (though not the storage one) seems to imply that if the dma_mask is
> 0, the HCD driver is only capable of PIO.
>
> That would be a more general solution rather than going through each HCD
> driver since my understanding is that flush_dcache_page() is only needed
> together with the mass storage support.

   Note that DMA capable driver can be doing some transfers in PIO mode 
or falling back to PIO mode if DMA mode transfer is unsuccessful (the 
musb driver is an example of the latter and if the DMA rewrite patches 
will get accepted, it'll do short transfers in PIO mode).

MBR, Sergei

