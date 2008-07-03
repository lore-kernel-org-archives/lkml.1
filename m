Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYGCXeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYGCXeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYGCXeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:34:11 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:5296 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbYGCXeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=BXwIfPi07dy5UMQsZO4PzzeUfs71HoRKxsXA9yKb0BtBcbWr+5zxvfFfFdYBXxU1Dt
         YS2ZQKkIS/P2BCSf0EsiDFLNJ5ctwT0YvTNUu9/H4NlAMmrwVClWq2hBHCNQ30khJt7S
         quoWaqF+sJ7PGtW9hgA+9h7WmYTSTgX/nOsNU=
Subject: [PATCH] olpc: olpc_battery.c sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 16:33:38 -0700
Message-Id: <1215128019.16647.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/power/olpc_battery.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 32570af..5fbca26 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -205,9 +205,9 @@ static int olpc_bat_get_property(struct power_supply *psy,
 				 union power_supply_propval *val)
 {
 	int ret = 0;
-	int16_t ec_word;
+	__be16 ec_word;
 	uint8_t ec_byte;
-	uint64_t ser_buf;
+	__be64 ser_buf;
 
 	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
 	if (ret)
@@ -257,16 +257,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 9760L / 32;
+		val->intval = (int)be16_to_cpu(ec_word) * 9760L / 32;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_AVG:
 		ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 15625L / 120;
+		val->intval = (int)be16_to_cpu(ec_word) * 15625L / 120;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
@@ -278,24 +276,22 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+
+		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+		val->intval = (int)be16_to_cpu(ec_word) * 100 / 256;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
 		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 6250 / 15;
+		val->intval = (int)be16_to_cpu(ec_word) * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
-- 
1.5.6.1.281.g1087e


