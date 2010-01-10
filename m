Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868Ab0AJJBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab0AJJBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 04:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532Ab0AJJBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 04:01:22 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:38455 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0AJJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 04:01:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-mtd@lists.infradead.org
Subject: [PATCH 1/1] MTD: chips/cfi, remove unneeded NULL checks
Date: Sun, 10 Jan 2010 10:01:19 +0100
Message-Id: <1263114079-8347-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cfi_intelext_setup and cfi_amdstd_setup, mtd is never NULL.
Remove unnecessary checks.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/chips/cfi_cmdset_0001.c |    6 ++----
 drivers/mtd/chips/cfi_cmdset_0002.c |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 5fbf29e..9253043 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -615,10 +615,8 @@ static struct mtd_info *cfi_intelext_setup(struct mtd_info *mtd)
 	return mtd;
 
  setup_err:
-	if(mtd) {
-		kfree(mtd->eraseregions);
-		kfree(mtd);
-	}
+	kfree(mtd->eraseregions);
+	kfree(mtd);
 	kfree(cfi->cmdset_priv);
 	return NULL;
 }
diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index f3600e8..1ebdcdd 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -494,10 +494,8 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
 	return mtd;
 
  setup_err:
-	if(mtd) {
-		kfree(mtd->eraseregions);
-		kfree(mtd);
-	}
+	kfree(mtd->eraseregions);
+	kfree(mtd);
 	kfree(cfi->cmdset_priv);
 	kfree(cfi->cfiq);
 	return NULL;
-- 
1.6.5.7

