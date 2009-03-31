Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbZCaOCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbZCaOCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZCaOCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:02:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:18022 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbZCaOB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:01:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="443621705"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Date: Tue, 31 Mar 2009 15:01:49 +0100
Subject: RE: [PATCH 1/2] dw_dmac: set CAP_PRIVATE capability for DW DMA
 controller
Thread-Topic: [PATCH 1/2] dw_dmac: set CAP_PRIVATE capability for DW DMA
 controller
Thread-Index: AcmsdJi398f+MMajSPWjhgHcUiHI1AFjeUPA
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8C3EB@irsmsx504.ger.corp.intel.com>
References: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
In-Reply-To: <1237894506-11622-1-git-send-email-hans-christian.egtvedt@atmel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Christian Egtvedt wrote:
> This patch adds the private capability for the DW DMA controller. This
> allows the DMA controller to do other DMA transfers than
> memory-to-memory. For example when the DMA controller is used by
> peripherals to transfer data between memory and peripheral.
> 
> Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> ---
>  drivers/dma/dw_dmac.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index a97c07e..1c5e31d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -994,6 +994,7 @@ static int __init dw_probe(struct platform_device *pdev)
>  	channel_clear_bit(dw, MASK.DST_TRAN, dw->all_chan_mask);
>  	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);
> 
> +	dma_cap_set(DMA_PRIVATE, dw->dma.cap_mask);
>  	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
>  	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
>  	dw->dma.dev = &pdev->dev;

Hi Hans,

Adding Dan...

Please note that this way you permenently exclude the device from public use.
If that's your intent that's fine.
Remember however that you can leave the device generally non-private
and attempt as needed to allocate a channel for exclusive usage by dma_request_channel()
- it would set DMA_PRIVATE flag if private channel candidate has been found.

With this note:

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

Regards,
Maciej