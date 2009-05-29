Return-Path: <linux-kernel-owner+w=401wt.eu-S1760551AbZE2Nni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551AbZE2Nni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760319AbZE2Nmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:42:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:38722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759928AbZE2Nmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="416798692"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:41:50 +0100
Subject: RE: [PATCH v2 04/11] async_xor: permit callers to pass in a
 'dma/page scribble' region
Thread-Topic: [PATCH v2 04/11] async_xor: permit callers to pass in a
 'dma/page scribble' region
Thread-Index: AcndInQ6+ncNwczlRfaMhdozOUMBXADNx86g
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C6F@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005946.4104.28803.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250320w523fc657w3bca47f23442f46e@mail.gmail.com>
In-Reply-To: <f12847240905250320w523fc657w3bca47f23442f46e@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> async_xor() needs space to perform dma and page address conversions.  In
> most cases the code can simply reuse the struct page * array because the
> size of the native pointer matches the size of a dma/page address.  In
> order to support archs where sizeof(dma_addr_t) is larger than
> sizeof(struct page *), or to preserve the input parameters, we utilize a
> memory region passed in by the caller.
> 
> Since the code is now prepared to handle the case where it cannot
> perform address conversions on the stack, we no longer need the
> !HIGHMEM64G dependency in drivers/dma/Kconfig.
> 
> [ Impact: don't clobber input buffers for address conversions ]
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/async_xor.c |   59 ++++++++++++++++++++-----------------------
>  drivers/dma/Kconfig         |    2 +
>  2 files changed, 29 insertions(+), 32 deletions(-)

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>