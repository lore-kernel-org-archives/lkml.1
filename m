Return-Path: <linux-kernel-owner+w=401wt.eu-S1422931AbXBGWhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422931AbXBGWhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422935AbXBGWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:37:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:5159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422931AbXBGWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KPS87OiPuadTuo/C8M+O11iWj1nDOtrYeFgQeqbjwsWVj2WRnUQqp4V/m3ebCp6NMMGqYeaMk9Umaj0SNB7rLtRadERUZ8utg18KtWg7PwHl2nMbLJSlU0xrHjTBpGv9hnXgdEpxafw/tWjGCH1MXkdalLL+bl9EsZNV6cYyXJc=
Message-ID: <e9c3a7c20702071436s3e481c13ue1fe70cc68f19f27@mail.gmail.com>
Date: Wed, 7 Feb 2007 15:36:52 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Leech, Christopher" <christopher.leech@intel.com>
Subject: Re: [RFC][PATCH 00/12] md raid acceleration and performance analysis
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <BD524EA7912ED5469DFD0BAEF6BC752F0136DE23@orsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e9c3a7c20701222016q6e06dee6y7977f1525eacf042@mail.gmail.com>
	 <BD524EA7912ED5469DFD0BAEF6BC752F0136DE23@orsmsx411.amr.corp.intel.com>
X-Google-Sender-Auth: b609fa3ceeedcef8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Leech, Christopher <christopher.leech@intel.com> wrote:
> Hi Dan,
>
> I've been looking over how your patches change the ioatdma driver.  I
> like the idea of removing the multiple entry points for virtual address
> vs. page struct arguments, and just using dma_addr_t for the driver
> interfaces.
>
> But, I don't think having both ioatdma and iop-adma implement map_page,
> map_single, unmap_page, and unmap_single entry points is much better.
> Do you see a reason why it wouldn't work to expose the generic device
> for a DMA channel, and replace instances of
>
>         dma_device->map_single(dma_chan, src, len, DMA_TO_DEVICE)
>
> with
>
>         dma_map_single(dma_device->dev, src, len, DMA_TO_DEVICE)
>

I was initially concerned about a case where dma_map_single was not
equivalent to pci_map_single.  Looking now, it appears that case would
be a bug, so I will integrate this change.

> I am a little concerned about having the DMA mapping happen outside of
> the driver, but the unmapping is still in the driver cleanup routine.
> I'm not sure if it's really a problem, or how I'd change it though.
>
> - Chris

Thanks,
Dan
