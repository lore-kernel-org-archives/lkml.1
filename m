Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZGOQVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZGOQVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbZGOQVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:21:01 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43766 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbZGOQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:20:59 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 2/4] ds2760: export more features
Date: Wed, 15 Jul 2009 18:20:39 +0200
Message-Id: <1247674841-9909-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW and POWER_SUPPLY_PROP_CAPACITY
features to the power supply core.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/ds2760_battery.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index cf07c43..f439071 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -337,6 +337,12 @@ static int ds2760_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = di->temp_C;
 		break;
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
+		val->intval = di->life_sec;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = di->rem_capacity;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -353,6 +359,8 @@ static enum power_supply_property ds2760_battery_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_EMPTY,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
 };
 
 static int ds2760_battery_probe(struct platform_device *pdev)
-- 
1.6.3.1

