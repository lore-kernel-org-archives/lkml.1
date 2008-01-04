Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYADVrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYADVrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYADVr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:47:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:19970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbYADVr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:47:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,247,1196668800"; 
   d="scan'208";a="358024769"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/4] async_tx: kill tx_set_src and tx_set_dest methods
Date: Fri, 4 Jan 2008 13:45:15 -0800
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C03BAD677@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20071222010648.15576.51113.stgit@dwillia2-linux.ch.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/4] async_tx: kill tx_set_src and tx_set_dest methods
Thread-Index: AchENztu2VTCUyw/S4CqjB0ZfG4iUwK48EBA
References: <20071222010537.15576.31788.stgit@dwillia2-linux.ch.intel.com> <20071222010648.15576.51113.stgit@dwillia2-linux.ch.intel.com>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>
Cc: <yur@emcraft.com>, <hskinnemoen@atmel.com>, <olof@lixom.net>,
       <wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Jan 2008 21:45:16.0458 (UTC) FILETIME=[17F320A0:01C84F1B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Williams, Dan J 
>
>The tx_set_src and tx_set_dest methods were originally 
>implemented to allow
>an array of addresses to be passed down from async_xor to the dmaengine
>driver while minimizing stack overhead.  Removing these methods allows
>drivers to have all transaction parameters available at 'prep' 
>time, saves
>two function pointers in struct dma_async_tx_descriptor, and 
>reduces the
>number of indirect branches..
>
>A consequence of moving this data to the 'prep' routine is that
>multi-source routines like async_xor need temporary storage to 
>convert an
>array of linear addresses into an array of dma addresses.  In 
>order to keep
>the same stack footprint of the previous implementation the 
>input array is
>reused as storage for the dma addresses.  This requires that
>sizeof(dma_addr_t) be less than or equal to sizeof(void *).  As a
>consequence CONFIG_DMADEVICES now depends on 
>!CONFIG_HIGHMEM64G.  It also
>requires that drivers be able to make descriptor resources 
>available when
>the 'prep' routine is polled.
>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
[... Snip ...]

Sorry I took so long to get back to this.  The ioatdma related changes
look fine - I like this approach much better.

Acked by: Shannon Nelson <shannon.nelson@intel.com>
