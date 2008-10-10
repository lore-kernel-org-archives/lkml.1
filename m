Return-Path: <linux-kernel-owner+w=401wt.eu-S1763974AbYJJW7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763974AbYJJW7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYJJW6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:58:22 -0400
Received: from kroah.org ([198.145.64.141]:54692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110AbYJJW5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:57:33 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "J.R. Mauro" <jrm8005@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/23] Staging: Fix gcc warnings in sxg
Date: Fri, 10 Oct 2008 15:42:41 -0700
Message-Id: <1223678567-30143-17-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081010224130.GA30117@kroah.com>
References: <20081010224130.GA30117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J.R. Mauro <jrm8005@gmail.com>

Fix for compiler warning about format specifier in prints in
drivers/staging/sxg/sxg.c
Prints were using %x to print unsigned long data.


Signed-off-by: J.R. Mauro <jrm8005@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/sxg/sxg.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sxg/sxg.c b/drivers/staging/sxg/sxg.c
index a91c9f3..0117d51 100644
--- a/drivers/staging/sxg/sxg.c
+++ b/drivers/staging/sxg/sxg.c
@@ -453,7 +453,7 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 	// fails.  If we hit a minimum, fail.
 
 	for (;;) {
-		DBG_ERROR("%s Allocate XmtRings size[%x]\n", __FUNCTION__,
+		DBG_ERROR("%s Allocate XmtRings size[%lx]\n", __FUNCTION__,
 			  (sizeof(SXG_XMT_RING) * 1));
 
 		// Start with big items first - receive and transmit rings.  At the moment
@@ -470,7 +470,7 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 		}
 		memset(adapter->XmtRings, 0, sizeof(SXG_XMT_RING) * 1);
 
-		DBG_ERROR("%s Allocate RcvRings size[%x]\n", __FUNCTION__,
+		DBG_ERROR("%s Allocate RcvRings size[%lx]\n", __FUNCTION__,
 			  (sizeof(SXG_RCV_RING) * 1));
 		adapter->RcvRings =
 		    pci_alloc_consistent(adapter->pcidev,
@@ -531,7 +531,7 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 		return (STATUS_RESOURCES);
 	}
 
-	DBG_ERROR("%s Allocate EventRings size[%x]\n", __FUNCTION__,
+	DBG_ERROR("%s Allocate EventRings size[%lx]\n", __FUNCTION__,
 		  (sizeof(SXG_EVENT_RING) * RssIds));
 
 	// Allocate event queues.
@@ -562,7 +562,7 @@ static int sxg_allocate_resources(p_adapter_t adapter)
 	}
 	memset(adapter->Isr, 0, sizeof(u32) * IsrCount);
 
-	DBG_ERROR("%s Allocate shared XMT ring zero index location size[%x]\n",
+	DBG_ERROR("%s Allocate shared XMT ring zero index location size[%lx]\n",
 		  __FUNCTION__, sizeof(u32));
 
 	// Allocate shared XMT ring zero index location
-- 
1.6.0.2

