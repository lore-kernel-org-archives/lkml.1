Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYHXIkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYHXIkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYHXIkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:40:05 -0400
Received: from main.gmane.org ([80.91.229.2]:37725 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbYHXIkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:40:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@cante.net>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Sun, 24 Aug 2008 11:37:54 +0300
Organization: Private
Message-ID: <874p5a24gt.fsf@jondo.cante.net>
References: <87od3k2egi.fsf@jondo.cante.net>
	<m3vdxrhq0o.fsf@maximus.localdomain>
	<200808231458.39206.alistair@devzero.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:AVqmlk+JWh0NeDiRhdHZwq9/BtU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan <alistair@devzero.co.uk> writes:

> On Saturday 23 August 2008 13:31:03 Krzysztof Halasa wrote:
>
>> Jari Aalto <jari.aalto@cante.net> writes:
>> >         [1] Aug 21 11:01:19 jondo kernel: [174628.275859] DMA: Out of
>> > SW-IOMMU space for 65536 bytes at device 0000:00:0d.0 model name      :
>> > AMD Athlon(tm) X2 Dual Core Processor
>> >         BE-2400
>>
>> grep GART_IOMMU .config
>
> Agreed, you shouldn't be using the SW-IOMMU on this processor.

Are these the correct boot options, without swiotlb?

   iommu=noagp,noaperture,off

Or just:

   iommu=off

> That said, do you use the r8169 driver with jumbo frames enabled? Francois
> Romieu just fixed a leak in it that affected Intel platforms (because some
> have no hardware IOMMU).

The onboard WiFi is in use:

        $ lsmod | grep rtl
	rtl8187   39424  0

        $ dmesg

	[    2.758861] usb 1-9: new full speed USB device using ohci_hcd and address 4
	[    2.978258] usb 1-9: configuration #1 chosen from 1 choice
	[    2.985369] usb 1-9: New USB device found, idVendor=0bda, idProduct=8187
	[    2.985372] usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=3
	[    2.985374] usb 1-9: Product: RTL8187_Wireless
	[    2.985376] usb 1-9: Manufacturer: Manufacturer_Realtek_RTL8187_
	[    2.985378] usb 1-9: SerialNumber: 0015AF0B59A6

Jari

