Return-Path: <linux-kernel-owner+w=401wt.eu-S1765331AbXJZRLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765331AbXJZRLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761037AbXJZRK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:10:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:27519 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbXJZRK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,334,1188802800"; 
   d="scan'208";a="187592633"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] DMA: Fix broken device refcounting
Date: Fri, 26 Oct 2007 10:10:17 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C034CC702@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] DMA: Fix broken device refcounting
Thread-Index: AcgX6xO6uG3w9lkWQU2JQWJBlHK/CQABg9ZwAABqQLA=
References: <1193415162504-git-send-email-hskinnemoen@atmel.com> 
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Nelson, Shannon" <shannon.nelson@intel.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 26 Oct 2007 17:10:18.0118 (UTC) FILETIME=[1541BA60:01C817F3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Nelson, Shannon 
>Sent: Friday, October 26, 2007 10:00 AM
>To: 'Haavard Skinnemoen'
>Cc: Williams, Dan J; linux-kernel@vger.kernel.org; 
>akpm@linux-foundation.org
>Subject: RE: [PATCH] DMA: Fix broken device refcounting
>
>--
>
>When a channel is removed from dmaengine, too many kref_put() calls
>are made and the device removal happens too soon, usually causing
>a panic.
>
>Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
>---
>
> drivers/dma/dmaengine.c |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
>index 8248992..144a1b7 100644
>--- a/drivers/dma/dmaengine.c
>+++ b/drivers/dma/dmaengine.c
>@@ -131,7 +131,6 @@ static void 
>dma_async_device_cleanup(struct kref *kref);
> static void dma_class_dev_release(struct class_device *cd)
> {
> 	struct dma_chan *chan = container_of(cd, struct 
>dma_chan, class_dev);
>-	kref_put(&chan->device->refcount, dma_async_device_cleanup);
> }
> 
> static struct class dma_devclass = {

Of course, to avoid compiler complaints, it might be better as something
like:

static void dma_class_dev_release(struct class_device *cd)
{
-	struct dma_chan *chan = container_of(cd, struct dma_chan,
class_dev);
-	kref_put(&chan->device->refcount, dma_async_device_cleanup);
+	return;
}

sln
