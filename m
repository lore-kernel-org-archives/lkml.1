Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbYJOKVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbYJOKVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYJOKU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:20:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34488 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753722AbYJOKU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:20:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Don't use NO_IRQ in WM8350
Date: Wed, 15 Oct 2008 11:20:54 +0100
Message-Id: <1224066054-24401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NO_IRQ is only defined on some architectures - the general way to test
for an invalid IRQ in the modern kernel is by comparing with zero.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This is a build fix for platforms that don't define NO_IRQ (which is
most of them).  Please merge as soon as possible.

 drivers/mfd/wm8350-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 25a7a5d..bf87f67 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1217,7 +1217,7 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
-	if (irq != NO_IRQ) {
+	if (irq) {
 		ret = request_irq(irq, wm8350_irq, 0,
 				  "wm8350", wm8350);
 		if (ret != 0) {
-- 
1.5.6.5

