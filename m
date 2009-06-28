Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZF1V0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZF1V0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZF1VZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:25:49 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:37677 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZF1VZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:25:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] ath9k: remove permissions from debugfs files
Date: Sun, 28 Jun 2009 23:25:28 +0200
Message-Id: <1246224328-11826-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246224328-11826-1-git-send-email-jirislaby@gmail.com>
References: <1246224328-11826-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow users to open debugfs files, because it can cause oopses.

When a user opens some file, driver unlinks it and frees the
corresponding structure, we will dereference freed memory.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 6d20725..9f99f00 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -500,31 +500,31 @@ int ath9k_init_debug(struct ath_softc *sc)
 		goto err;
 
 	sc->debug.debugfs_debug = debugfs_create_file("debug",
-		S_IRUGO | S_IWUSR, sc->debug.debugfs_phy, sc, &fops_debug);
+		S_IRUSR | S_IWUSR, sc->debug.debugfs_phy, sc, &fops_debug);
 	if (!sc->debug.debugfs_debug)
 		goto err;
 
-	sc->debug.debugfs_dma = debugfs_create_file("dma", S_IRUGO,
+	sc->debug.debugfs_dma = debugfs_create_file("dma", S_IRUSR,
 				       sc->debug.debugfs_phy, sc, &fops_dma);
 	if (!sc->debug.debugfs_dma)
 		goto err;
 
 	sc->debug.debugfs_interrupt = debugfs_create_file("interrupt",
-						     S_IRUGO,
+						     S_IRUSR,
 						     sc->debug.debugfs_phy,
 						     sc, &fops_interrupt);
 	if (!sc->debug.debugfs_interrupt)
 		goto err;
 
 	sc->debug.debugfs_rcstat = debugfs_create_file("rcstat",
-						  S_IRUGO,
+						  S_IRUSR,
 						  sc->debug.debugfs_phy,
 						  sc, &fops_rcstat);
 	if (!sc->debug.debugfs_rcstat)
 		goto err;
 
 	sc->debug.debugfs_wiphy = debugfs_create_file(
-		"wiphy", S_IRUGO | S_IWUSR, sc->debug.debugfs_phy, sc,
+		"wiphy", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy, sc,
 		&fops_wiphy);
 	if (!sc->debug.debugfs_wiphy)
 		goto err;
-- 
1.6.3.2

