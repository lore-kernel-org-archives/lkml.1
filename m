Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYGaJ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYGaJ6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYGaJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:58:25 -0400
Received: from web31702.mail.mud.yahoo.com ([68.142.201.182]:48356 "HELO
	web31702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752999AbYGaJ6Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:58:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gRSHyvNX4uUgsS4OrMQpMJEI7v4KUXLxPQXRHbH4nG2f/bM29x5DRNj+VquxMwJiyzNYbLliaOFrvyU9OuHyAow5vObL/pXX0+qEVyd7mcTzZPKO0+sbwS4Cu+T7PTirOkcYf6ugLovmRbl7cglE3//0HjStEjoBfzQlA929j38=;
X-Mailer: YahooMailRC/1042.48 YahooMailWebService/0.7.218
Date: Thu, 31 Jul 2008 02:58:23 -0700 (PDT)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: Re: PCIe device driver question
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <811595.67429.qm@web31702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Thanks for that, I did not notice that in the spec. I am currently using 64 bit format unconditionally and this must be what is going wrong. 

Thank you so much for that.


Sanka


----- Original Message ----
From: Robert Hancock <hancockr@shaw.ca>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Sent: Thursday, 31 July, 2008 6:14:54 PM
Subject: Re: PCIe device driver question

Sanka Piyaratna wrote:
> I allocate memory in the user land using memalign function (typically I allocate about 500 MB) and pass this to the kernel space. In my device driver, I call get_user_pages() to lock down the memory and extract the relevant pages. A scatter-gather list is generated using these page addresses and hence derive the dma_addresses using page_to_phys() function. These addresses are programmed into a FIFO in the hardware device using a memory mapped register interface (PCI BAR based). Subsequently the hardware start filling up the pages and interrupt when a block of pages are complete. I notice the hardware hang (PCIe packets don't seem to get the acknowledgements from the root complex) when the DMA address is < 0x0000_0001_0000_0000. I have verified in the hardware that the PCIe packet is created with the correct address as programed by the device driver dma_address. If i can guard some how that the memory allocation is with in a certain area, I can stop the
>  problem from occuring. Are there any bridge functionality in the Intel architecture that may mask a certain region of memory?

How are you formatting the addresses in the TLP? The PCI Express spec 
says that for addresses below 4GB the 32-bit addressing format must be 
used (you can't use the 64-bit format unconditionally). It could be that 
is what is making the chipset unhappy.



      Find a better answer, faster with the new Yahoo!7 Search. www.yahoo7.com.au/search
