Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZGLWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZGLWs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZGLWqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:38 -0400
Received: from kroah.org ([198.145.64.141]:33522 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbZGLWqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 9/9] wm97xx_batery: replace driver_data with dev_get_drvdata()
Date: Sun, 12 Jul 2009 15:46:06 -0700
Message-Id: <1247438766-17266-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

direct access of driver_data is going away.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/power/wm97xx_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 8bde921..b787335 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -33,14 +33,14 @@ static enum power_supply_property *prop;
 
 static unsigned long wm97xx_read_bat(struct power_supply *bat_ps)
 {
-	return wm97xx_read_aux_adc(bat_ps->dev->parent->driver_data,
+	return wm97xx_read_aux_adc(dev_get_drvdata(bat_ps->dev->parent),
 					pdata->batt_aux) * pdata->batt_mult /
 					pdata->batt_div;
 }
 
 static unsigned long wm97xx_read_temp(struct power_supply *bat_ps)
 {
-	return wm97xx_read_aux_adc(bat_ps->dev->parent->driver_data,
+	return wm97xx_read_aux_adc(dev_get_drvdata(bat_ps->dev->parent),
 					pdata->temp_aux) * pdata->temp_mult /
 					pdata->temp_div;
 }
-- 
1.6.3.2

