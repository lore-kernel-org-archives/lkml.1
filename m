Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbYCKQpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYCKQpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYCKQpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:45:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:18433 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYCKQpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,480,1199692800"; 
   d="scan'208";a="532139759"
Content-class: urn:content-classes:message
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 1/2] Fix a bug about BUG_ON() on DMA engine capability DMA_INTERRUPT.
Date: Tue, 11 Mar 2008 16:42:19 -0000
Message-ID: <7F38996F7185A24AB9071ED4950AD8C10145C83E@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240803110717w54790c90l1f9dc335c3e34fb4@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] Fix a bug about BUG_ON() on DMA engine capability DMA_INTERRUPT.
Thread-Index: AciDg54HzcByFzHdTfShc1Fc78mVGAAEmTNQ
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <wei.zhang@freescale.com>, <linux-kernel@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
X-OriginalArrivalTime: 11 Mar 2008 16:42:23.0778 (UTC) FILETIME=[E1DD7820:01C88396]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Zhang Wei <wei.zhang@freescale.com>
> Date: Mar 11, 2008 4:25 AM
> Subject: [PATCH 1/2] Fix a bug about BUG_ON() on DMA engine capability
> DMA_INTERRUPT.
> To: dan.j.williams@intel.com
> Cc: linux-kernel@vger.kernel.org, Zhang Wei <wei.zhang@freescale.com>
> 
> 
> The device->device_prep_dma_interrupt function is used by
> DMA_INTERRUPT capability, not DMA_ZERO_SUM.
> 
> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> ---
>  drivers/dma/dmaengine.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
> index 2996523..8db0e7f 100644
> --- a/drivers/dma/dmaengine.c
> +++ b/drivers/dma/dmaengine.c
> @@ -357,7 +357,7 @@ int dma_async_device_register(struct dma_device
*device)
>                !device->device_prep_dma_zero_sum);
>        BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
>                !device->device_prep_dma_memset);
> -       BUG_ON(dma_has_cap(DMA_ZERO_SUM, device->cap_mask) &&
> +       BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
>                !device->device_prep_dma_interrupt);
> 
>        BUG_ON(!device->device_alloc_chan_resources);
> --
> 1.5.4

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

