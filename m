Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYG3Wz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYG3Wz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYG3Wzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:55:47 -0400
Received: from web31708.mail.mud.yahoo.com ([68.142.201.188]:23963 "HELO
	web31708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751929AbYG3Wzr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:55:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=GK+pgkKKe+pPxX0rVAE7nv+fDry0NtR/cUZcrjgBjj22OHaeJZ5Lrt/tGD1PMfV8YO+MIywJTK3OJyG0tXjbGxLsKsA0lCfuymWhMc3+/JOA7KB2eGScrzxxNgVRQpaXMCvs6oxM5S7W/ViaOK99TQWXHntMIRASd2qShvn/KBg=;
X-Mailer: YahooMailRC/1042.48 YahooMailWebService/0.7.218
Date: Wed, 30 Jul 2008 15:55:46 -0700 (PDT)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: Re: PCIe device driver question
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <490172.6073.qm@web31708.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I allocate memory in the user land using memalign function (typically I allocate about 500 MB) and pass this to the kernel space. In my device driver, I call get_user_pages() to lock down the memory and extract the relevant pages. A scatter-gather list is generated using these page addresses and hence derive the dma_addresses using page_to_phys() function. These addresses are programmed into a FIFO in the hardware device using a memory mapped register interface (PCI BAR based). Subsequently the hardware start filling up the pages and interrupt when a block of pages are complete. I notice the hardware hang (PCIe packets don't seem to get the acknowledgements from the root complex) when the DMA address is < 0x0000_0001_0000_0000. I have verified in the hardware that the PCIe packet is created with the correct address as programed by the device driver dma_address. If i can guard some how that the memory allocation is with in a certain area, I can stop the
 problem from occuring. Are there any bridge functionality in the Intel architecture that may mask a certain region of memory?

Thanks and regards,

Sanka



----- Original Message ----
From: Robert Hancock <hancockr@shaw.ca>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Sent: Thursday, 31 July, 2008 4:54:48 AM
Subject: Re: PCIe device driver question

Sanka Piyaratna wrote:
> Hi,
> 
> I am currently developing a PCIe data capture card hardware and the
> device drivers to drive this. I have implemented DMA on the data
> capture and the scatter-gather DMA is implemented in the hardware.  I
> am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> am able to successfully dma data into any memory (dma) address >
> 0x0000_0001_0000_0000. However, my problem is to dma data to any
> address less than this. When I try to DMA data to an address less than
> 0x0000_0001_0000_0000, the hardware device hangs indicating that the
> address does not exist.
> 
> I have implemented the DMA mask to be full 64 bit and my hardware is
> capable of transfering data to any address < 8TB. I am using kernel
> version 2.6.23.11. 
> 
> Could you please let me know what I might be doing wrong?

The kernel can't do anything to stop you from DMAing anywhere you want 
(barring the system having special IOMMU hardware). If you overwrite 
something you shouldn't have you'll cause a crash, but the kernel has no 
influence on it really.

Unless you're messing up the DMA addresses somehow and writing into a 
space that's not actually RAM (like the MMIO memory hole or something), 
my guess is it's likely a hardware problem..



      Find a better answer, faster with the new Yahoo!7 Search. www.yahoo7.com.au/search
