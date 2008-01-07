Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYAGQ7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYAGQ7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756419AbYAGQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:58:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:25054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbYAGQ6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:58:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,254,1196668800"; 
   d="scan'208";a="250630004"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/4] async_tx: kill tx_set_src and tx_set_dest methods
Date: Mon, 7 Jan 2008 16:58:38 -0000
Message-ID: <7F38996F7185A24AB9071ED4950AD8C1FAED2F@swsmsx413.ger.corp.intel.com>
In-Reply-To: <BAE9DCEF64577A439B3A37F36F9B691C03BAD67F@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/4] async_tx: kill tx_set_src and tx_set_dest methods
thread-index: AchENztu2VTCUyw/S4CqjB0ZfG4iUwK48EBAAAAX8aAAjChuEA==
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, <yur@emcraft.com>,
       <hskinnemoen@atmel.com>, <olof@lixom.net>, <wei.zhang@freescale.com>
X-OriginalArrivalTime: 07 Jan 2008 16:58:38.0727 (UTC) FILETIME=[8C8AE170:01C8514E]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
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

>From ioat_dma point of view this change just makes life easier as it
simplifies dma_async_tx_descriptor - it looks ok.

Maciej Sosnowski

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

