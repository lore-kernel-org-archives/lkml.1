Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYHYJuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYHYJuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYHYJuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:50:05 -0400
Received: from main.gmane.org ([80.91.229.2]:37579 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbYHYJuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:50:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jari Aalto <jari.aalto@tamk.fi>
Subject: Re: 2.6.25 DMA: Out of SW-IOMMU space - Asus M2N32 AMD 8GB memory
Date: Sat, 23 Aug 2008 18:23:12 +0300
Organization: Private
Message-ID: <87r68f21sv.fsf@jondo.cante.net>
References: <87od3k2egi.fsf@jondo.cante.net>
	<m3vdxrhq0o.fsf@maximus.localdomain>
	<200808231458.39206.alistair@devzero.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: a91-155-179-127.elisa-laajakaista.fi
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:OSAsP8wmUSXGW7VbEQnM4XjvIzM=
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
>
> Agreed, you shouldn't be using the SW-IOMMU on this processor.

So the correct boot paramer is?

  imoou=off,noagp,noaperture

no swiotlb setting at all?

> That said, do you use the r8169 driver with jumbo frames enabled? Francois
> Romieu just fixed a leak in it that affected Intel platforms (because some
> have no hardware IOMMU).

I'm using the onboard WiFi:

$ lsmod | grep rtl
rtl8187                39424  0

$ dmesg ...

[    2.758861] usb 1-9: new full speed USB device using ohci_hcd and address 4
[    2.978258] usb 1-9: configuration #1 chosen from 1 choice
[    2.985369] usb 1-9: New USB device found, idVendor=0bda, idProduct=8187
[    2.985372] usb 1-9: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.985374] usb 1-9: Product: RTL8187_Wireless
[    2.985376] usb 1-9: Manufacturer: Manufacturer_Realtek_RTL8187_
[    2.985378] usb 1-9: SerialNumber: 0015AF0B59A6

I'm not sure how it maps to pci -nn:

00:04.0 PCI bridge [0604]: nVidia Corporation C51 PCI Express Bridge [10de:02fb] (rev a1)
00:09.0 ISA bridge [0601]: nVidia Corporation MCP55 LPC Bridge [10de:0360] (rev a2)
00:09.1 SMBus [0c05]: nVidia Corporation MCP55 SMBus [10de:0368] (rev a2)
00:0a.0 USB Controller [0c03]: nVidia Corporation MCP55 USB Controller [10de:036c] (rev a1)
00:0a.1 USB Controller [0c03]: nVidia Corporation MCP55 USB Controller [10de:036d] (rev a2)
00:0e.0 PCI bridge [0604]: nVidia Corporation MCP55 PCI bridge [10de:0370] (rev a2)
00:10.0 Bridge [0680]: nVidia Corporation MCP55 Ethernet [10de:0373] (rev a2)
00:11.0 Bridge [0680]: nVidia Corporation MCP55 Ethernet [10de:0373] (rev a2)
00:16.0 PCI bridge [0604]: nVidia Corporation MCP55 PCI Express bridge [10de:0375] (rev a2)

Thank you,
Jari

