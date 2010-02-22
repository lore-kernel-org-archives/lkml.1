Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0BVRko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:40:44 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:52118 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0BVRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:40:42 -0500
X-Spam-Processed: digidescorp.com, Mon, 22 Feb 2010 11:40:37 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16695eb497=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Zhang Wei <zw@zh-kernel.org>, Li Yang <leoli@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [async_tx-next PATCH 1/2] fsldma: Fix cookie issues
Date: Mon, 22 Feb 2010 11:40:31 -0600
Message-Id: <1266860431-17310-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsl_dma_tx_submit() only sets the cookie on the first descriptor of a
transaction. It should set the cookie on all.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c	2010-02-22 11:16:36.000000000 -0600
+++ b/drivers/dma/fsldma.c	2010-02-22 11:24:01.000000000 -0600
@@ -362,7 +362,7 @@ static dma_cookie_t fsl_dma_tx_submit(st
 		if (cookie < 0)
 			cookie = 1;
 
-		desc->async_tx.cookie = cookie;
+		child->async_tx.cookie = cookie;
 	}
 
 	chan->common.cookie = cookie;

