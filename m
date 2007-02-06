Return-Path: <linux-kernel-owner+w=401wt.eu-S965602AbXBFXwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602AbXBFXwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965600AbXBFXwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:52:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:14815 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965590AbXBFXwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:52:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,291,1167638400"; 
   d="scan'208"; a="178087926:sNHT42870849"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 00/12] md raid acceleration and performance analysis
Date: Tue, 6 Feb 2007 15:49:03 -0800
Message-ID: <BD524EA7912ED5469DFD0BAEF6BC752F0136DE23@orsmsx411.amr.corp.intel.com>
In-Reply-To: <e9c3a7c20701222016q6e06dee6y7977f1525eacf042@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 00/12] md raid acceleration and performance analysis
thread-index: Acc+pTTWmiAx19rgQMyH/qBcnWwbvQLno0vw
From: "Leech, Christopher" <christopher.leech@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "NeilBrown" <neilb@suse.de>,
       <linux-raid@vger.kernel.org>
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Arjan van de Ven" <arjan@infradead.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Feb 2007 23:49:03.0787 (UTC) FILETIME=[61D697B0:01C74A49]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

I've been looking over how your patches change the ioatdma driver.  I
like the idea of removing the multiple entry points for virtual address
vs. page struct arguments, and just using dma_addr_t for the driver
interfaces.

But, I don't think having both ioatdma and iop-adma implement map_page,
map_single, unmap_page, and unmap_single entry points is much better.
Do you see a reason why it wouldn't work to expose the generic device
for a DMA channel, and replace instances of

	dma_device->map_single(dma_chan, src, len, DMA_TO_DEVICE)

with

	dma_map_single(dma_device->dev, src, len, DMA_TO_DEVICE)

I am a little concerned about having the DMA mapping happen outside of
the driver, but the unmapping is still in the driver cleanup routine.
I'm not sure if it's really a problem, or how I'd change it though.

- Chris
