Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYGaNHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYGaNHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 09:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYGaNHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 09:07:24 -0400
Received: from smtp.net4india.com ([202.71.129.66]:42436 "EHLO
	smtp.net4india.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751064AbYGaNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:07:23 -0400
Subject: Re: PCIe device driver question
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Sanka Piyaratna <cesanka@yahoo.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4890BF39.6060608@shaw.ca>
References: <fa.PmBLCqOb4Xo53y3W9hAdnsU50Og@ifi.uio.no>
	 <fa.42mxuHHJP7XQmYeyxNoEC/NFUHA@ifi.uio.no>  <4890BF39.6060608@shaw.ca>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 18:41:08 +0530
Message-Id: <1217509868.2156.18.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Thanks for the reply. I was thinking that the MMIO and reserve memory
will be below 4 GB was only applicable for 32-bit environments, since I
don't have much experience in 64-bit.

However, I had an IDENTICAL problem over 2 years ago. I had used
posix_memalign() in user space to allocate pages aligned to 4096 byte
pages, allocated several additional memaligned pages in user space, used
mlock() to lock all these pages, gathered the user space addresses into
the original pages as arrays of structures, passed this array into the
kernel using an ioctl() call, used get_user_pages() to extract the
struct page pointers, performed a kmap() to get the kernel virtual
addresses and then extracted the physical addresses and 'sent' this to
the chip to perform DMA.

This situation is almost identical to what has been reported and hence
my interest.

However, I had a PCI access problem. The DMA was just NOT happening on
any machine which had highmem, i.e over 896 MB.

I "solved" the problem since I didn't have much time to do R&D, by
booting with kernel command line option of mem=512M and the DMA went
thru successfully.

This was the linux-2.6.15 kernel then. Since the project was basically
to test the DMA capability of the device, the actual address to where it
was DMA-ed didn't matter, and I got paid for my work. However, this
matter was always at the back of my head.

What could have been the problem with the x86 32-bit PCI ? 

Thanks and regards

V. Radhakrishnan
www.atr-labs.com

On Wed, 2008-07-30 at 13:21 -0600, Robert Hancock wrote:
> V.Radhakrishnan wrote:
> >>> am testing this in an X86_64 architecture machine with 4 GB of RAM. I
> >>> am able to successfully dma data into any memory (dma) address >
> >>> 0x0000_0001_0000_0000.
> > 
> > How can you DMA "successfully" into this address which is > 4 GB when
> > you have only 4 GB RAM ? Or am I missing something ?
> 
> The MMIO and other reserved memory space at the top of the 32-bit memory 
> space will cause the top part of memory to be relocated above 4GB.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

