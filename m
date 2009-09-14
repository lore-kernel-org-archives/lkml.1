Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZINPAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZINPAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZINPAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:00:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:30844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbZINPA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:00:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="448322946"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 14 Sep 2009 16:00:24 +0100
Subject: RE: [PATCH 21/29] ioat2,3: dynamically resize descriptor ring
Thread-Topic: [PATCH 21/29] ioat2,3: dynamically resize descriptor ring
Thread-Index: AcotB+1XHftN1MgaRNWJ7CNa6Qh4bgIQb+7g
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548192@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023216.32667.55942.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904023216.32667.55942.stgit@dwillia2-linux.ch.intel.com>
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
> Increment the allocation order of the descriptor ring every time we run
> out of descriptors up to a maximum of allocation order specified by the
> module parameter 'ioat_max_alloc_order'.  After each idle period
> decrement the allocation order to a minimum order of
> 'ioat_ring_alloc_order' (i.e. the default ring size, tunable as a module
> parameter).
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>

Just one thing:

> +static int ioat_ring_max_alloc_order = IOAT_MAX_ORDER;
> +module_param(ioat_ring_max_alloc_order, int, 0644);
> +MODULE_PARM_DESC(ioat_ring_max_alloc_order,
> +		 "ioat2+: upper limit for dynamic ring resizing (default: n=16)");
[...]
> --- a/drivers/dma/ioat/dma_v2.h
> +++ b/drivers/dma/ioat/dma_v2.h
> @@ -37,6 +37,8 @@ extern int ioat_pending_level;
>  #define IOAT_MAX_ORDER 16
>  #define ioat_get_alloc_order() \
>  	(min(ioat_ring_alloc_order, IOAT_MAX_ORDER))
> +#define ioat_get_max_alloc_order() \
> +	(min(ioat_ring_max_alloc_order, IOAT_MAX_ORDER))

Making the max_alloc_order a module parameter gives impression
that it can be modified by an user, including making it larger than default.
The default is however its maximum value, which may be confusing.
Why not to use parameter only as the upper limit?

Thanks,
Maciej