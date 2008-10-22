Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbYJVRrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbYJVRrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbYJVRgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:36:17 -0400
Received: from kroah.org ([198.145.64.141]:50453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757904AbYJVRgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:36:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/42] Staging: sxg: fix compiler warnings.
Date: Wed, 22 Oct 2008 10:29:17 -0700
Message-Id: <1224696563-5170-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof() isn't an unsigned long :(

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/sxg/sxg.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sxg/sxg.c b/drivers/staging/sxg/sxg.c
index fe935e2..5272a18 100644
--- a/drivers/staging/sxg/sxg.c
+++ b/drivers/staging/sxg/sxg.c
@@ -460,8 +460,8 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 	/* fails.  If we hit a minimum, fail. */
 
 	for (;;) {
-		DBG_ERROR("%s Allocate XmtRings size[%lx]\n", __func__,
-			  (sizeof(SXG_XMT_RING) * 1));
+		DBG_ERROR("%s Allocate XmtRings size[%x]\n", __func__,
+			  (unsigned int)(sizeof(SXG_XMT_RING) * 1));
 
 		/* Start with big items first - receive and transmit rings.  At the moment */
 		/* I'm going to keep the ring size fixed and adjust the number of */
@@ -477,8 +477,8 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 		}
 		memset(adapter->XmtRings, 0, sizeof(SXG_XMT_RING) * 1);
 
-		DBG_ERROR("%s Allocate RcvRings size[%lx]\n", __func__,
-			  (sizeof(SXG_RCV_RING) * 1));
+		DBG_ERROR("%s Allocate RcvRings size[%x]\n", __func__,
+			  (unsigned int)(sizeof(SXG_RCV_RING) * 1));
 		adapter->RcvRings =
 		    pci_alloc_consistent(adapter->pcidev,
 					 sizeof(SXG_RCV_RING) * 1,
@@ -538,8 +538,8 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 		return (STATUS_RESOURCES);
 	}
 
-	DBG_ERROR("%s Allocate EventRings size[%lx]\n", __func__,
-		  (sizeof(SXG_EVENT_RING) * RssIds));
+	DBG_ERROR("%s Allocate EventRings size[%x]\n", __func__,
+		  (unsigned int)(sizeof(SXG_EVENT_RING) * RssIds));
 
 	/* Allocate event queues. */
 	adapter->EventRings = pci_alloc_consistent(adapter->pcidev,
@@ -569,8 +569,8 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 	}
 	memset(adapter->Isr, 0, sizeof(u32) * IsrCount);
 
-	DBG_ERROR("%s Allocate shared XMT ring zero index location size[%lx]\n",
-		  __func__, sizeof(u32));
+	DBG_ERROR("%s Allocate shared XMT ring zero index location size[%x]\n",
+		  __func__, (unsigned int)sizeof(u32));
 
 	/* Allocate shared XMT ring zero index location */
 	adapter->XmtRingZeroIndex = pci_alloc_consistent(adapter->pcidev,
-- 
1.6.0.2

