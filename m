Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbZKDRel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbZKDRel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbZKDRej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:34:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbZKDReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BDkv3ewzGKDPb0MGlTGO8D08tU+t6QMgCWzoptNM+UMwAeINwnnl7qzx3yLwSNtm2m
         7aLj586m5kxbMWVBgfHb8l8bPP0m56xuKsGHtmyaG7Zj4/L7BHmJmspg421lxdl3o4BF
         Ji4wSTYEcTBeVbHs/IcKnU6bd1mFw76unolHo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:18 +0100
Message-Id: <20091104173418.28463.79825.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/41] rt2800usb: add rt2800_rf_[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add rt2800_rf_[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -226,6 +226,12 @@ static void rt2800usb_rf_write(struct rt
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static inline void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
+				   const unsigned int word, const u32 value)
+{
+	rt2800usb_rf_write(rt2x00dev, word, value);
+}
+
 static void rt2800usb_mcu_request(struct rt2x00_dev *rt2x00dev,
 				  const u8 command, const u8 token,
 				  const u8 arg0, const u8 arg1)
@@ -280,7 +286,7 @@ static const struct rt2x00debug rt2800us
 	},
 	.rf	= {
 		.read		= rt2x00_rf_read,
-		.write		= rt2800usb_rf_write,
+		.write		= rt2800_rf_write,
 		.word_base	= RF_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
@@ -757,24 +763,24 @@ static void rt2800usb_config_channel_rt2
 
 	rt2x00_set_field32(&rf->rf4, RF4_HT40, conf_is_ht40(conf));
 
-	rt2800usb_rf_write(rt2x00dev, 1, rf->rf1);
-	rt2800usb_rf_write(rt2x00dev, 2, rf->rf2);
-	rt2800usb_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
-	rt2800usb_rf_write(rt2x00dev, 4, rf->rf4);
+	rt2800_rf_write(rt2x00dev, 1, rf->rf1);
+	rt2800_rf_write(rt2x00dev, 2, rf->rf2);
+	rt2800_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt2800_rf_write(rt2x00dev, 4, rf->rf4);
 
 	udelay(200);
 
-	rt2800usb_rf_write(rt2x00dev, 1, rf->rf1);
-	rt2800usb_rf_write(rt2x00dev, 2, rf->rf2);
-	rt2800usb_rf_write(rt2x00dev, 3, rf->rf3 | 0x00000004);
-	rt2800usb_rf_write(rt2x00dev, 4, rf->rf4);
+	rt2800_rf_write(rt2x00dev, 1, rf->rf1);
+	rt2800_rf_write(rt2x00dev, 2, rf->rf2);
+	rt2800_rf_write(rt2x00dev, 3, rf->rf3 | 0x00000004);
+	rt2800_rf_write(rt2x00dev, 4, rf->rf4);
 
 	udelay(200);
 
-	rt2800usb_rf_write(rt2x00dev, 1, rf->rf1);
-	rt2800usb_rf_write(rt2x00dev, 2, rf->rf2);
-	rt2800usb_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
-	rt2800usb_rf_write(rt2x00dev, 4, rf->rf4);
+	rt2800_rf_write(rt2x00dev, 1, rf->rf1);
+	rt2800_rf_write(rt2x00dev, 2, rf->rf2);
+	rt2800_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt2800_rf_write(rt2x00dev, 4, rf->rf4);
 }
 
 static void rt2800usb_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
