Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZIOQHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZIOQHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZIOQHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:07:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:12600 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbZIOQGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:06:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,390,1249282800"; 
   d="scan'208";a="727156817"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Tue, 15 Sep 2009 17:05:28 +0100
Subject: RE: [PATCH 02/18] dmaengine, async_tx: add a "no channel switch"
 allocator
Thread-Topic: [PATCH 02/18] dmaengine, async_tx: add a "no channel switch"
 allocator
Thread-Index: AcotKzJvaeWLByqDRIe675rK/b0j0AI8eIwg
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548785@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064445.7141.18693.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064445.7141.18693.stgit@dwillia2-linux.ch.intel.com>
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

Williams, Dan J wrote:
> Channel switching is problematic for some dmaengine drivers as the
> architecture precludes separating the ->prep from ->submit.  In these
> cases the driver can select ASYNC_TX_DISABLE_CHANNEL_SWITCH to modify
> the async_tx allocator to only return channels that support all of the
> required asynchronous operations.
> 
> For example MD_RAID456=y selects support for asynchronous xor, xor
> validate, pq, pq validate, and memcpy.  When
> ASYNC_TX_DISABLE_CHANNEL_SWITCH=y any channel with all these
> capabilities is marked DMA_ASYNC_TX allowing async_tx_find_channel() to
> quickly locate compatible channels with the guarantee that dependency
> chains will remain on one channel.  When
> ASYNC_TX_DISABLE_CHANNEL_SWITCH=n async_tx_find_channel() may select
> channels that lead to operation chains that need to cross channel
> boundaries using the async_tx channel switch capability.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

with one question:

> +	/* note: this only matters in the
> +	 * CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y case
> +	 */
> +	if (device_has_all_tx_types(device))
> +		dma_cap_set(DMA_ASYNC_TX, device->cap_mask);

Why not to put this part plus device_has_all_tx_types()
into #ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH then?

Thanks,
Maciej