Return-Path: <linux-kernel-owner+w=401wt.eu-S1762866AbZLLATB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866AbZLLATB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:19:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762728AbZLLAS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:18:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:52768 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762564AbZLLASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F8mnppYAHdOSgU8g2UTMvtVmcAkP4LFmv/lFaRQMw8Ws32Gm+yVGsCZJi2a8UpojhS
         aMnfEvYwx5VRCJB+kqq3E8C4ilbuA2VzEhypafGdXFQ+XawA3rXEbOEV9uYP4evhr+t6
         LedvzzHWe09o3IJvJZaRkAaEm7twoXIVha3Yw=
Subject: Re: Does pci_map_single magicly work on > 32 bit address for 32bit
 capable device?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B22DEA7.8040202@gmail.com>
References: <1260567582.5983.23.camel@maxim-laptop>
	 <4B22DEA7.8040202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 02:18:57 +0200
Message-ID: <1260577137.8536.20.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 18:07 -0600, Robert Hancock wrote: 
> On 12/11/2009 03:39 PM, Maxim Levitsky wrote:
> > Hi,
> >
> > I am writing a driver, and I am faced with following problem:
> >
> > I receive a kernel pointer, and I want device to dma into that memory.
> > However, device is only capable of 32 bit dma.
> >
> > I can create a 'consistent' mapping and use memcpy from/to it, but it
> > feels like waste of performance.
> >
> >
> > According to Documentation/DMA-mapping.txt, I can tell that hw supports
> > 32 bit dma using pci_set_dma_mask, however, what will happen if I pass
> > arbitrary kernel address into pci_map_single.
> > What will happen if the address is above 32 bit?
> 
> The kernel should set up an IOMMU (either hardware or software) mapping 
> for that memory so that the device can access it through an address 
> below 4GB. This is assuming it's a 64-bit kernel (on 32-bit, a kernel 
> memory address will always be below 4GB).

What do you mean by software IOMMU?

On my system there is no IOMMU present, so only way to ensure 32 bit
address is to copy pages.
pci_map_single could copy the data for write case, and pci_unmap_single
for read case, but I now strongly doubt they do.
I am not sure at all that these functions will fail if too high address
is specified....

Also, very recently, I found that in
Documentation/DMA-API.txt, there is a statement that says that
pci_map_single fails for >32 bit memory address.

I guess I just do a memcpy...

Best regards,
Maxim Levitsky





