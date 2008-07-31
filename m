Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYGaUnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYGaUnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYGaUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:43:37 -0400
Received: from smtp.net4india.com ([202.71.129.66]:48981 "EHLO
	smtp.net4india.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752949AbYGaUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:43:36 -0400
Subject: Re: PCIe device driver question
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Sanka Piyaratna <cesanka@yahoo.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48920A00.1060902@shaw.ca>
References: <fa.PmBLCqOb4Xo53y3W9hAdnsU50Og@ifi.uio.no>
	 <fa.42mxuHHJP7XQmYeyxNoEC/NFUHA@ifi.uio.no> <4890BF39.6060608@shaw.ca>
	 <1217509868.2156.18.camel@atlas> <4891F847.7030100@shaw.ca>
	 <1217530046.7668.29.camel@atlas>  <48920A00.1060902@shaw.ca>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 02:17:45 +0530
Message-Id: <1217537265.8075.3.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Robert !

Unfortunately, I cannot test this with recent kernels, since this was a
WiMAX card based on a CardBus inteface  and the Toshiba laptop I have
has only 512 MB RAM ( though I have PCs with more RAM, the PCs don't
have a CardBus interface ).

BRgds

RK


On Thu, 2008-07-31 at 12:52 -0600, Robert Hancock wrote:
> V.Radhakrishnan wrote:
> >> My guess there was a bug in your DMA mapping code. I don't think kmap is 
> >> what is normally used for this. I think with get_user_pages one usually 
> >> takes the returned page pointers to create an SG list and uses 
> >> dma_map_sg to create a DMA mapping for them.
> > 
> > Looking at the actual code, I see that I had used kmap() only to obtain
> > kernel virtual addresses for the array of struct pages obtained from
> > user space by using get_user_pages.
> > 
> > Subsequently, I had used dma_map_single() and dma_unmap_single() calls
> > for single buffer calls.
> 
> I'm suspicious about this usage, I don't know if that will actually 
> work. There is a dma_map_page call which is meant for doing a DMA 
> mapping on a struct page which should likely be used instead.
> 
> > 
> > The code didn't have bugs IMHO since it was used for extensive stress
> > testing the initial FPGA prototype as well as the final ASIC chip ,
> > sometimes running for over 4 days non-stop without breaking.
> > 
> > However, using Test Access Points on the board and using a Logic
> > Analyzer showed that DMA was NOT taking place when RAM > 896 MB was
> > used. The hardware gurus said that PCI bus cycles just didn't seem to be
> > taking place when RAM > 896 MB was used as the source OR destination
> > address.
> 
> Are you sure the address being passed to the device was correct in this 
> case? There should be nothing magical about 896MB from a hardware point 
> of view, and the kernel in general cannot stop you from DMAing anywhere 
> you like.
> 
> > 
> > Perhaps this was a problem in the earlier kernel(s) and has since been
> > rectified ? ( I was using 2.6.15 then ... )
> > 
> > I am just curious since Sanka Piyaratna reported a 'similar' kind of
> > situation.
> > 
> > Regards
> > 
> > V. Radhakrishnan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

