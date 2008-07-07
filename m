Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbYGGV1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbYGGV1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYGGV0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:26:53 -0400
Received: from mail.queued.net ([207.210.101.209]:4761 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbYGGV0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:26:53 -0400
Date: Mon, 7 Jul 2008 17:26:46 -0400
From: Andres Salomon <dilinger@queued.net>
To: drzeus-sdhci@drzeus.cx
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mmc: have mmc_align_data_size use ALIGN() macro
Message-ID: <20080707172646.79cc214c@fred>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No sense manually doing the alignment dance, there's a macro for that.
Once the optimal alignment stuff is added, this could
probably turn into something like this (in core.h):

static inline u32 mmc_align_data_size(struct mmc_card *card, u32 sz)
{
	return ALIGN(sz, card->align_sz);
}

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/mmc/core/core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 3ee5b8c..e306061 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -315,9 +315,7 @@ unsigned int mmc_align_data_size(struct mmc_card *card, unsigned int sz)
 	 * the core about its problems yet, so for now we just 32-bit
 	 * align the size.
 	 */
-	sz = ((sz + 3) / 4) * 4;
-
-	return sz;
+	return ALIGN(sz, 4);
 }
 EXPORT_SYMBOL(mmc_align_data_size);
 
-- 
1.5.5.3
