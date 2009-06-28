Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZF1V0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZF1V0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZF1VZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:25:52 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:37679 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbZF1VZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:25:50 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] ath5k: remove permissions from debugfs files
Date: Sun, 28 Jun 2009 23:25:27 +0200
Message-Id: <1246224328-11826-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow users to open debugfs files, because it can cause oopses.

When a user opens some file, driver unlinks it and frees the
corresponding structure, we will dereference freed memory.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/ath/ath5k/debug.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 4904a07..747508c 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -380,13 +380,15 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
 				ath5k_global_debugfs);
 
-	sc->debug.debugfs_debug = debugfs_create_file("debug", S_IWUSR | S_IRUGO,
+	sc->debug.debugfs_debug = debugfs_create_file("debug",
+				S_IWUSR | S_IRUSR,
 				sc->debug.debugfs_phydir, sc, &fops_debug);
 
-	sc->debug.debugfs_registers = debugfs_create_file("registers", S_IRUGO,
+	sc->debug.debugfs_registers = debugfs_create_file("registers", S_IRUSR,
 				sc->debug.debugfs_phydir, sc, &fops_registers);
 
-	sc->debug.debugfs_beacon = debugfs_create_file("beacon", S_IWUSR | S_IRUGO,
+	sc->debug.debugfs_beacon = debugfs_create_file("beacon",
+				S_IWUSR | S_IRUSR,
 				sc->debug.debugfs_phydir, sc, &fops_beacon);
 
 	sc->debug.debugfs_reset = debugfs_create_file("reset", S_IWUSR,
-- 
1.6.3.2

