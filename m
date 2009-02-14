Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZBNVR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZBNVR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZBNVPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:15:09 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:54906 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbZBNVPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:15:07 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 12/43] drivers/net/atl1e: fix sparse warnings: fix signedness
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:14:58 +0100
Message-ID: <20090214211452.23489.8257.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  drivers/net/atl1e/atl1e_main.c:716:39: warning: incorrect type in argument 2 (different signedness)
  drivers/net/atl1e/atl1e_param.c:57:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atl1e/atl1e_param.c:68:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atl1e/atl1e_param.c:81:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atl1e/atl1e_param.c:92:1: warning: incorrect type in initializer (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/atl1e/atl1e.h       |    2 +-
 drivers/net/atl1e/atl1e_param.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/atl1e/atl1e.h b/drivers/net/atl1e/atl1e.h
index c49550d..2bf63b4 100644
--- a/drivers/net/atl1e/atl1e.h
+++ b/drivers/net/atl1e/atl1e.h
@@ -448,7 +448,7 @@ struct atl1e_adapter {
 	/* All Descriptor memory */
 	dma_addr_t  	ring_dma;
 	void     	*ring_vir_addr;
-	int             ring_size;
+	u32             ring_size;
 
 	struct atl1e_tx_ring tx_ring;
 	struct atl1e_rx_ring rx_ring;
diff --git a/drivers/net/atl1e/atl1e_param.c b/drivers/net/atl1e/atl1e_param.c
index f72abb3..b3be59f 100644
--- a/drivers/net/atl1e/atl1e_param.c
+++ b/drivers/net/atl1e/atl1e_param.c
@@ -41,7 +41,7 @@
 
 #define ATL1E_PARAM(x, desc) \
 	static int __devinitdata x[ATL1E_MAX_NIC + 1] = ATL1E_PARAM_INIT; \
-	static int num_##x; \
+	static unsigned int num_##x; \
 	module_param_array_named(x, x, int, &num_##x, 0); \
 	MODULE_PARM_DESC(x, desc);
 

