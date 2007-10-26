Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbXJ0Gcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbXJ0Gcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXJ0Gcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:32:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:57192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbXJ0Gcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:32:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,336,1188802800"; 
   d="scan'208";a="306437315"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH] DMAENGINE: too many kref_put calls
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: shannon.nelson@intel.com, greg@kroah.com, hskinnemoen@atmel.com,
       dan.j.williams@intel.com
Date: Fri, 26 Oct 2007 16:56:48 -0700
Message-ID: <20071026235648.5737.45405.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a channel is removed from dmaengine, too many kref_put() calls
are made and the device removal happens too soon, usually causing
a panic.

Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/dmaengine.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 84257f7..245da53 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -134,8 +134,7 @@ static void dma_async_device_cleanup(struct kref *kref);
 
 static void dma_dev_release(struct device *dev)
 {
-	struct dma_chan *chan = to_dma_chan(dev);
-	kref_put(&chan->device->refcount, dma_async_device_cleanup);
+	return;
 }
 
 static struct class dma_devclass = {
