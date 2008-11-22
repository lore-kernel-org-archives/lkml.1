Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYKVDXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYKVDXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYKVDW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:22:58 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:43973 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYKVDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=RGXa8tRi5KhSE0Glgszjpg2cWrPPgb/8MVcrJscsbupCZsTGv2AdGcGi7rFctcjylT
         BClpJnJIsgIQVqUKbAS12llvwD1NAS+DXu2Ax/r9FMmfW8G3N9XFHGXVJH7GxqR4XH3e
         3kF9NTfx2EO02oZbk4h9QhWIKO9jZgTYNh4Xg=
From: crquan@gmail.com
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, ath5k-devel@venema.h4ckr.net
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath5k: fix Security issue in DebugFS part of ath5k
Date: Sat, 22 Nov 2008 11:22:49 +0800
Message-Id: <1227324169-13260-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

http://bugzilla.kernel.org/show_bug.cgi?id=12076

Remove any write access to groups and others, only keep write permission
to its owner, usually only root user.

Reported-by: Jérôme Poulin <jeromepoulin@gmail.com>
Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/net/wireless/ath5k/debug.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 19980cb..ccaeb5c 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -417,19 +417,19 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
 				ath5k_global_debugfs);
 
-	sc->debug.debugfs_debug = debugfs_create_file("debug", 0666,
+	sc->debug.debugfs_debug = debugfs_create_file("debug", S_IWUSR | S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_debug);
 
-	sc->debug.debugfs_registers = debugfs_create_file("registers", 0444,
+	sc->debug.debugfs_registers = debugfs_create_file("registers", S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_registers);
 
-	sc->debug.debugfs_tsf = debugfs_create_file("tsf", 0666,
+	sc->debug.debugfs_tsf = debugfs_create_file("tsf", S_IWUSR | S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_tsf);
 
-	sc->debug.debugfs_beacon = debugfs_create_file("beacon", 0666,
+	sc->debug.debugfs_beacon = debugfs_create_file("beacon", S_IWUSR | S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_beacon);
 
-	sc->debug.debugfs_reset = debugfs_create_file("reset", 0222,
+	sc->debug.debugfs_reset = debugfs_create_file("reset", S_IWUSR,
 				sc->debug.debugfs_phydir, sc, &fops_reset);
 }
 
-- 
1.6.0.4.758.g36c05

