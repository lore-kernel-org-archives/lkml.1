Return-Path: <linux-kernel-owner+w=401wt.eu-S1763647AbYEYK0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763647AbYEYK0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762114AbYEYKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:23:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41996 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762129AbYEYKXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:23:48 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 16/28] atmel: treat firmware data as const
Message-Id: <E1K0DOD-0007Do-Rm@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:45 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/atmel.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 438e63e..d1acef7 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -560,7 +560,7 @@ static const struct {
 static void build_wpa_mib(struct atmel_private *priv);
 static int atmel_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void atmel_copy_to_card(struct net_device *dev, u16 dest,
-			       unsigned char *src, u16 len);
+			       const unsigned char *src, u16 len);
 static void atmel_copy_to_host(struct net_device *dev, unsigned char *dest,
 			       u16 src, u16 len);
 static void atmel_set_gcr(struct net_device *dev, u16 mask);
@@ -3853,7 +3853,7 @@ static int reset_atmel_card(struct net_device *dev)
 	if (priv->card_type == CARD_TYPE_EEPROM) {
 		/* copy in firmware if needed */
 		const struct firmware *fw_entry = NULL;
-		unsigned char *fw;
+		const unsigned char *fw;
 		int len = priv->firmware_length;
 		if (!(fw = priv->firmware)) {
 			if (priv->firmware_type == ATMEL_FW_TYPE_NONE) {
@@ -4120,7 +4120,7 @@ static void atmel_writeAR(struct net_device *dev, u16 data)
 }
 
 static void atmel_copy_to_card(struct net_device *dev, u16 dest,
-			       unsigned char *src, u16 len)
+			       const unsigned char *src, u16 len)
 {
 	int i;
 	atmel_writeAR(dev, dest);
-- 
1.5.4.5

