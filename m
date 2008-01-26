Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYAZKSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYAZKSd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 05:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYAZKSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 05:18:25 -0500
Received: from main.gmane.org ([80.91.229.2]:57828 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYAZKSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 05:18:24 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 1/6] Core driver for WM97xx touchscreens
Date: Sat, 26 Jan 2008 10:18:16 +0000 (UTC)
Message-ID: <fnf1d8$n6i$1@ger.gmane.org>
References: <20080121152402.GA7518@rakim.wolfsonmicro.main>
	<1200929100-17224-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<fnf084$ju9$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp78-37-18-87.pppoe.avangarddsl.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please apply this patch. BTW: Could you please also add me to the "CC" list
of this patch serie?

>From 1e61dd8a8c8346f925f09cae34275c9754bf2be1 Mon Sep 17 00:00:00 2001
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Date: Sat, 26 Jan 2008 13:04:29 +0300
Subject: [PATCH] Fix wm97xx_resume

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/input/touchscreen/wm97xx-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index 06030a8..27a0a99 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -639,7 +639,7 @@ static int wm97xx_remove(struct device *dev)
 }
 
 #ifdef CONFIG_PM
-int wm97xx_resume(struct device *dev)
+static int wm97xx_resume(struct device *dev)
 {
 	struct wm97xx *wm = dev_get_drvdata(dev);
 
@@ -647,7 +647,7 @@ int wm97xx_resume(struct device *dev)
 	if (wm->id == WM9713_ID2) {
 		wm97xx_reg_write(wm, AC97_WM9713_DIG1, wm->dig[0]);
 		wm97xx_reg_write(wm, 0x5a, wm->misc);
-		if (wm->ts_use_count) {
+		if (wm->input_dev->users) {
 			u16 reg;
 			reg = wm97xx_reg_read(wm, AC97_EXTENDED_MID) & 0x7fff;
 			wm97xx_reg_write(wm, AC97_EXTENDED_MID, reg);
-- 
1.5.3.8



-- 
With best wishes
Dmitry


