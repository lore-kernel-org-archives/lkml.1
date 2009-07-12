Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZGLS3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZGLS3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbZGLS26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:28:58 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:46890 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbZGLS25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:28:57 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 08/15] power: bq27200: define all register space
Date: Sun, 12 Jul 2009 21:09:30 +0300
Message-Id: <1247422177-7329-8-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-7-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
 <1247422177-7329-4-git-send-email-me@felipebalbi.com>
 <1247422177-7329-5-git-send-email-me@felipebalbi.com>
 <1247422177-7329-6-git-send-email-me@felipebalbi.com>
 <1247422177-7329-7-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and also add accessors for 8-bit wide registers

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   52 ++++++++++++++++++++++++++++++--------
 1 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index 385a505..f36633c 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -26,11 +26,31 @@
 
 #define DRIVER_VERSION			"1.0.0"
 
-#define BQ27200_REG_TEMP		0x06
-#define BQ27200_REG_VOLT		0x08
-#define BQ27200_REG_RSOC		0x0B /* Relative State-of-Charge */
-#define BQ27200_REG_AI			0x14
-#define BQ27200_REG_FLAGS		0x0A
+#define BQ27200_REG_CTRL		0x00	/* device control */
+#define BQ27200_REG_MODE		0x01	/* device mode */
+#define BQ27200_REG_AR			0x02	/* at-rate */
+#define BQ27200_REG_ARTTE		0x04	/* at-rate time-to-empty */
+#define BQ27200_REG_TEMP		0x06	/* temperature */
+#define BQ27200_REG_VOLT		0x08	/* voltage */
+#define BQ27200_REG_FLAGS		0x0a	/* status flags */
+#define BQ27200_REG_RSOC		0x0b	/* relative state-of-charge */
+#define BQ27200_REG_NAC			0x0c	/* nominal available capacity */
+#define BQ27200_REG_CACD		0x0e	/* discharge compensated NAC */
+#define BQ27200_REG_CACT		0x10	/* temperature compensated CACD */
+#define BQ27200_REG_LMD			0x12	/* last measured discharge */
+#define BQ27200_REG_AI			0x14	/* average current */
+#define BQ27200_REG_TTE			0x16	/* time-to-empty */
+#define BQ27200_REG_TTF			0x18	/* time-to-full */
+#define BQ27200_REG_SI			0x1a	/* standby current */
+#define BQ27200_REG_STTE		0x1c	/* standby time-to-empty */
+#define BQ27200_REG_MLI			0x1e	/* max load current */
+#define BQ27200_REG_MLTTE		0x20	/* max load time-to-empty */
+#define BQ27200_REG_SAE			0x22	/* available energy */
+#define BQ27200_REG_AP			0x24	/* average power */
+#define BQ27200_REG_TTECP		0x26	/* time-to-empty at constant power */
+#define BQ27200_REG_CYCL		0x28	/* cycle-count since learning cycle */
+#define BQ27200_REG_CYCT		0x2a	/* cycle-count total */
+#define BQ27200_REG_CSOC		0x2c	/* compensated state-of-charge */
 
 struct bq27200 {
 	struct power_supply	bat;
@@ -56,12 +76,22 @@ static enum power_supply_property bq27200_props[] = {
  * Common code for BQ27200 devices
  */
 
-static inline int bq27200_read(struct bq27200 *bq, u8 reg)
+static inline int bq27200_readb(struct bq27200 *bq, u8 reg)
+{
+	return i2c_smbus_read_byte_data(bq->client, reg);
+}
+
+static inline int bq27200_writeb(struct bq27200 *bq, u8 reg, u8 data)
+{
+	return i2c_smbus_write_byte_data(bq->client, reg, data);
+}
+
+static inline int bq27200_readw(struct bq27200 *bq, u8 reg)
 {
 	return i2c_smbus_read_word_data(bq->client, reg);
 }
 
-static inline int bq27200_write(struct bq27200 *bq, u8 reg, u8 data)
+static inline int bq27200_writew(struct bq27200 *bq, u8 reg, u16 data)
 {
 	return i2c_smbus_write_word_data(bq->client, reg, data);
 }
@@ -74,7 +104,7 @@ static int bq27200_temperature(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(bq, BQ27200_REG_TEMP);
+	ret = bq27200_readw(bq, BQ27200_REG_TEMP);
 	if (ret < 0) {
 		dev_err(&bq->client->dev, "error reading temperature\n");
 		return ret;
@@ -91,7 +121,7 @@ static int bq27200_voltage(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(bq, BQ27200_REG_VOLT);
+	ret = bq27200_readw(bq, BQ27200_REG_VOLT);
 	if (ret < 0)
 		dev_err(&bq->client->dev, "error reading voltage\n");
 
@@ -107,7 +137,7 @@ static int bq27200_current(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(bq, BQ27200_REG_AI);
+	ret = bq27200_readw(bq, BQ27200_REG_AI);
 	if (ret < 0) {
 		dev_err(&bq->client->dev, "error reading current\n");
 		return 0;
@@ -124,7 +154,7 @@ static int bq27200_rsoc(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(bq, BQ27200_REG_RSOC);
+	ret = bq27200_readw(bq, BQ27200_REG_RSOC);
 	if (ret < 0) {
 		dev_err(&bq->client->dev, "error reading relative State-of-Charge\n");
 		return ret;
-- 
1.6.1.3

