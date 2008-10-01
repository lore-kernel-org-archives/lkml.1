Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYJAIuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYJAIuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJAIua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:50:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:22166 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYJAIu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:50:29 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, drzeus@drzeus.cx, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] sdhci: 'scratch' may be used uninitialized
Date: Wed,  1 Oct 2008 01:50:25 -0700
Message-Id: <1222851025-30619-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081001083532.GE31009@elte.hu>
References: <20081001083532.GE31009@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'scratch' is always initialized before it's used. The
conditional which is responsible for initialization of 'scratch' will
always evaluate 'true' when the first loop iteration occurs, and thus,
it's properly initialized. GCC doesn't see this, of course, so using
the uninitialized_var() macro seems to work for silencing this case.

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/mmc/host/sdhci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index e3a8133..6257677 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -177,7 +177,7 @@ static void sdhci_read_block_pio(struct sdhci_host *host)
 {
 	unsigned long flags;
 	size_t blksize, len, chunk;
-	u32 scratch;
+	u32 uninitialized_var(scratch);
 	u8 *buf;
 
 	DBG("PIO reading\n");
-- 
1.6.0.2

