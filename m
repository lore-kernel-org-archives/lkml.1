Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbXH1P7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbXH1P7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbXH1P73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:59:29 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47727 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbXH1P72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:59:28 -0400
Message-id: <309922776495964008@pripojeni.net>
In-reply-to: <2713029743177393055@pripojeni.net>
Subject: [PATCH 2/5] Net: ath5k, switch to ioread/iowrite
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Date: Tue, 28 Aug 2007 11:59:28 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k, switch to ioread/iowrite

Do not use readl/writel, since iomap retval is platform dependent and
needn't be virtual address awaited by readl/writel.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 64b9d0578668fe8c7a43eadace673bc3e57fc22b
tree 4990ed95e4112d79830d306ab6ae7afb2235f190
parent f65aa1c7d680d1bcde1ae20749eeda6d3ec02652
author Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:06:28 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:24:50 +0200

 drivers/net/wireless/ath5k.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k.h b/drivers/net/wireless/ath5k.h
index 0bb62dc..26f1229 100644
--- a/drivers/net/wireless/ath5k.h
+++ b/drivers/net/wireless/ath5k.h
@@ -1018,12 +1018,12 @@ extern int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power);
 
 static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
 {
-	return readl(hal->ah_sh + reg);
+	return ioread32(hal->ah_sh + reg);
 }
 
 static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
 {
-	writel(val, hal->ah_sh + reg);
+	iowrite32(val, hal->ah_sh + reg);
 }
 
 #endif
