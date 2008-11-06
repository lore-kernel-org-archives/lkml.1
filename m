Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYKFNn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYKFNn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYKFNnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:43:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60243 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754077AbYKFNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:43:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] mfd: Add some documentation for WM8350 register lock
Date: Thu,  6 Nov 2008 13:43:04 +0000
Message-Id: <1225978986-25990-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1225978986-25990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081106134254.GA21855@rakim.wolfsonmicro.main>
 <1225978986-25990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this will make the purpose of these functions a bit clearer,
it's not immediately obvious that the lock is a hardware feature.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 0d47fb9..d63a530 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -299,6 +299,13 @@ int wm8350_block_write(struct wm8350 *wm8350, int start_reg, int regs,
 }
 EXPORT_SYMBOL_GPL(wm8350_block_write);
 
+/**
+ * wm8350_reg_lock()
+ *
+ * The WM8350 has a hardware lock which can be used to prevent writes to
+ * some registers (generally those which can cause particularly serious
+ * problems if misused).  This function enables that lock.
+ */
 int wm8350_reg_lock(struct wm8350 *wm8350)
 {
 	u16 key = WM8350_LOCK_KEY;
@@ -314,6 +321,15 @@ int wm8350_reg_lock(struct wm8350 *wm8350)
 }
 EXPORT_SYMBOL_GPL(wm8350_reg_lock);
 
+/**
+ * wm8350_reg_unlock()
+ *
+ * The WM8350 has a hardware lock which can be used to prevent writes to
+ * some registers (generally those which can cause particularly serious
+ * problems if misused).  This function disables that lock so updates
+ * can be performed.  For maximum safety this should be done only when
+ * required.
+ */
 int wm8350_reg_unlock(struct wm8350 *wm8350)
 {
 	u16 key = WM8350_UNLOCK_KEY;
-- 
1.5.6.5

