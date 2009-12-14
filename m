Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbZLNNds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbZLNNds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZLNNdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:33:45 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:48964 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbZLNNdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:33:44 -0500
From: Vishnu Suresh <Vishnu@freescale.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dan.j.williams@intel.com,
       linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc: B04825@freescale.com, R58472@freescale.com,
       Vishnu Suresh <Vishnu@freescale.com>
Subject: [PATCH v0] Crypto: Talitos: re-initialize async_tx descriptors
Date: Mon, 14 Dec 2009 19:03:22 +0530
Message-Id: <1260797602-7476-1-git-send-email-Vishnu@freescale.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The async_tx descriptors contains dangling pointers.
Hence, re-initialize them to NULL before use.

Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
---
o. Rebased to linux-next as of 20091214

 drivers/crypto/talitos.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 87f06be..9e261c6 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -952,6 +952,9 @@ static struct dma_async_tx_descriptor * talitos_prep_dma_xor(
 		return NULL;
 	}
 	dma_async_tx_descriptor_init(&new->async_tx, &xor_chan->common);
+	new->async_tx.parent = NULL;
+	new->async_tx.next = NULL;
+
 
 	desc = &new->hwdesc;
 	/* Set destination: Last pointer pair */
-- 
1.6.4.2

