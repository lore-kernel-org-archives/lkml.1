Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYADVrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYADVrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbYADVrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:47:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:57523 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbYADVrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:47:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,247,1196668800"; 
   d="scan'208";a="314862360"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4] async_tx: replace 'int_en' with operation preparationflags
Date: Fri, 4 Jan 2008 13:47:02 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03BAD67D@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071222010653.15576.69686.stgit@dwillia2-linux.ch.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] async_tx: replace 'int_en' with operation preparationflags
Thread-Index: AchENvNqejPSYO8LReCLBpnUMwmRkQK5ChxA
References: <20071222010537.15576.31788.stgit@dwillia2-linux.ch.intel.com> <20071222010653.15576.69686.stgit@dwillia2-linux.ch.intel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
Cc: <yur@emcraft.com>, <hskinnemoen@atmel.com>, <olof@lixom.net>,
       <wei.zhang@freescale.com>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
X-OriginalArrivalTime: 04 Jan 2008 21:47:03.0207 (UTC) FILETIME=[5793BB70:01C84F1B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Williams, Dan J 
>
>Pass a full set of flags to drivers' per-operation 'prep' routines.
>Currently the only flag passed is DMA_PREP_INTERRUPT.  The 
>expectation is
>that arch-specific async_tx_find_channel() implementations can 
>exploit this
>capability to find the best channel for an operation.
>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
>
> crypto/async_tx/async_memcpy.c         |    3 ++-
> crypto/async_tx/async_memset.c         |    3 ++-
> crypto/async_tx/async_xor.c            |   10 ++++++----
> drivers/dma/ioat_dma.c                 |    4 ++--
> drivers/dma/iop-adma.c                 |   20 ++++++++++----------
> include/asm-arm/arch-iop13xx/adma.h    |   18 ++++++++++--------
> include/asm-arm/hardware/iop3xx-adma.h |   30 
>+++++++++++++++++-------------
> include/linux/dmaengine.h              |   17 +++++++++++++----
> 8 files changed, 62 insertions(+), 43 deletions(-)


Yep - this is good.  This will allow us to add an interrupt request flag
to the transaction request in the future.

Acked by: Shannon Nelson <shannon.nelson@intel.com>
