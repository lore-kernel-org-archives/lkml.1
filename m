Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742Ab0AZJ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0AZJ0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 04:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377Ab0AZJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 04:26:09 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:34400 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0AZJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 04:26:08 -0500
X-Auth-Info: b/+wWJ0aCAB75GAK/7oGZAExyx4oWrC9LlU7fofzgAw=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dmaengine: fix memleak in dma_async_device_unregister
Date: Tue, 26 Jan 2010 10:26:06 +0100
Message-Id: <1264497966-23688-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging a dma driver I noticed a memleak after
unloading the driver module.

Caught by kmemleak.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>

---
 drivers/dma/dmaengine.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 6f51a0a..e7a3230 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -826,6 +826,7 @@ void dma_async_device_unregister(struct dma_device *device)
 		chan->dev->chan = NULL;
 		mutex_unlock(&dma_list_mutex);
 		device_unregister(&chan->dev->device);
+		free_percpu(chan->local);
 	}
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
-- 
1.6.2.5

