Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbYEMNE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbYEMNE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbYEMNEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:04:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:61452 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbYEMNEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:04:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,479,1204531200"; 
   d="scan'208";a="246108221"
Content-class: urn:content-classes:message
MIME-Version: 1.0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 1/1] dma: 
Date: Tue, 13 May 2008 14:04:34 +0100
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101902E66@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080512205052.C1DFB7000085@mwinf2b01.orange.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] dma: 
Thread-Index: Aci0ceMyxavh3hQ8RfC/W1+9L+rMNgAh6MmQ
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
Cc: "linux" <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>
X-OriginalArrivalTime: 13 May 2008 13:04:36.0581 (UTC) FILETIME=[E53BB150:01C8B4F9]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Jaillet wrote:
> ﻿From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/dma/iop-adma.c which :
> 
> 1) Remove an explicit memset(.., 0, ...) to a variable allocated with
> kzalloc (i.e. 'dest').
> 
> 2) Allocate 'src' with kmalloc instead of kzalloc as all elements of the
> 'src' buffer are initialized in a 'for(...)' loop just after.
> 
> 3) remove useless 'sizeof(u8)', which always returns 1, when computing the
> size of the memory to be allocated.
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> ---
> 
> --- linux/drivers/dma/iop-adma.c	2008-04-17 04:49:44.000000000 +0200
> +++ linux/drivers/dma/iop-adma.c.cj	2008-05-12 22:39:14.000000000 +0200
> @@ -825,10 +825,10 @@ static int __devinit iop_adma_memcpy_sel
> 
>  	dev_dbg(device->common.dev, "%s\n", __func__);
> 
> -	src = kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
> +	src = kmalloc(IOP_ADMA_TEST_SIZE, GFP_KERNEL);
>  	if (!src)
>  		return -ENOMEM;
> -	dest = kzalloc(sizeof(u8) * IOP_ADMA_TEST_SIZE, GFP_KERNEL);
> +	dest = kzalloc(IOP_ADMA_TEST_SIZE, GFP_KERNEL);
>  	if (!dest) {
>  		kfree(src);
>  		return -ENOMEM;
> @@ -838,8 +838,6 @@ static int __devinit iop_adma_memcpy_sel
>  	for (i = 0; i < IOP_ADMA_TEST_SIZE; i++)
>  		((u8 *) src)[i] = (u8)i;
> 
> -	memset(dest, 0, IOP_ADMA_TEST_SIZE);
> -
>  	/* Start copy, using first DMA channel */
>  	dma_chan = container_of(device->common.channels.next,
>  				struct dma_chan,

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

