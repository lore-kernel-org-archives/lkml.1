Return-Path: <linux-kernel-owner+w=401wt.eu-S1764968AbXHDROT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764968AbXHDROT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760709AbXHDROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:14:12 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:31216 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760644AbXHDROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:14:10 -0400
Date: Sat, 04 Aug 2007 11:14:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit DMA mapping"
In-reply-to: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Message-id: <46B4B3DC.7020609@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Date: Wed, 1 Aug 2007 20:30:36 +0200 (CEST)
> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: ieee1394: revert "sbp2: enforce 32bit DMA mapping"
> 
> Revert commit 0555659d63c285ceb7ead3115532e1b71b0f27a7 from 2.6.22-rc1.
> The dma_set_mask call somehow failed on a PowerMac G5, PPC64:
> http://lkml.org/lkml/2007/8/1/344
> 
> Should there ever occur a DMA mapping beyond the physical DMA range, a
> proper SBP-2 firmware will report transport errors.  So let's leave it
> at that.

Isn't this a rather poor workaround? All this means is that if we fail 
to set a 32-bit DMA mask, we're likely to blow up at runtime instead of 
at initialization time, when we get a DMA mapping over 4GB.

If setting 32-bit DMA mask fails on ppc64, that sounds like a problem 
with the DMA implementation on that architecture. There are enough cards 
out there that only support 32-bit DMA that this really needs to work..

> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Tested-by: Olaf Hering <olh@suse.de>
> ---
> Same as commit a9c2f18800753c82c45fc13b27bdc148849bdbb2.
> 
>  drivers/ieee1394/sbp2.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> Index: linux-2.6.22/drivers/ieee1394/sbp2.c
> ===================================================================
> --- linux-2.6.22.orig/drivers/ieee1394/sbp2.c
> +++ linux-2.6.22/drivers/ieee1394/sbp2.c
> @@ -774,11 +774,6 @@ static struct sbp2_lu *sbp2_alloc_device
>  			SBP2_ERR("failed to register lower 4GB address range");
>  			goto failed_alloc;
>  		}
> -#else
> -		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
> -			SBP2_ERR("failed to set 4GB DMA mask");
> -			goto failed_alloc;
> -		}
>  #endif
>  	}
>  
> 

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

