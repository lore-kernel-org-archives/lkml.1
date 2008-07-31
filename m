Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbYGaIpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbYGaIpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 04:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYGaIpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 04:45:03 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:44636 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750841AbYGaIpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 04:45:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=obykrJOqHXjTeSBiZj8A:9 a=7DM4QyotIB5jUXLofIAA:7 a=ZId6AISCVTsk_GDNWturlOOeMSkA:4
Message-ID: <48917B86.8030600@shaw.ca>
Date: Thu, 31 Jul 2008 02:44:54 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Sanka Piyaratna <cesanka@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCIe device driver question
References: <490172.6073.qm@web31708.mail.mud.yahoo.com>
In-Reply-To: <490172.6073.qm@web31708.mail.mud.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanka Piyaratna wrote:
> I allocate memory in the user land using memalign function (typically I allocate about 500 MB) and pass this to the kernel space. In my device driver, I call get_user_pages() to lock down the memory and extract the relevant pages. A scatter-gather list is generated using these page addresses and hence derive the dma_addresses using page_to_phys() function. These addresses are programmed into a FIFO in the hardware device using a memory mapped register interface (PCI BAR based). Subsequently the hardware start filling up the pages and interrupt when a block of pages are complete. I notice the hardware hang (PCIe packets don't seem to get the acknowledgements from the root complex) when the DMA address is < 0x0000_0001_0000_0000. I have verified in the hardware that the PCIe packet is created with the correct address as programed by the device driver dma_address. If i can guard some how that the memory allocation is with in a certain area, I can stop the
>  problem from occuring. Are there any bridge functionality in the Intel architecture that may mask a certain region of memory?

How are you formatting the addresses in the TLP? The PCI Express spec 
says that for addresses below 4GB the 32-bit addressing format must be 
used (you can't use the 64-bit format unconditionally). It could be that 
is what is making the chipset unhappy.
