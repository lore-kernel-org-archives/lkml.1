Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbZKDReu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbZKDReu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbZKDRer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:34:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbZKDReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Xqb0o/ZNQoP6fbU0iEsJA09/mixO6KLnRX+Cx7duZbGkuv7j83xmEEZY1N7HESUwXX
         x2z93/aETaL6pzXqTaUCsarV9SJZ7gEXadN1pram1QzMrdrKrJA1aHvgByJ4UGyMCkiP
         D43jeOZy7Dwz1xtBI/+pnHDyZuJQVDriCPGEM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:25 +0100
Message-Id: <20091104173425.28463.74288.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/41] rt2800pci: add rt2800_rf_[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: add rt2800_rf_[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -236,6 +236,12 @@ static void rt2800pci_rf_write(struct rt
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static inline void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
+				   const unsigned int word, const u32 value)
+{
+	rt2800pci_rf_write(rt2x00dev, word, value);
+}
+
 static void rt2800pci_mcu_request(struct rt2x00_dev *rt2x00dev,
 				  const u8 command, const u8 token,
 				  const u8 arg0, const u8 arg1)
@@ -428,7 +434,7 @@ static const struct rt2x00debug rt2800pc
 	},
 	.rf	= {
 		.read		= rt2x00_rf_read,
-		.write		= rt2800pci_rf_write,
+		.write		= rt2800_rf_write,
 		.word_base	= RF_BASE,
 		.word_size	= sizeof(u32),
 		.word_count	= RF_SIZE / sizeof(u32),
@@ -897,24 +903,24 @@ static void rt2800pci_config_channel_rt2
 
 	rt2x00_set_field32(&rf->rf4, RF4_HT40, conf_is_ht40(conf));
 
-	rt2800pci_rf_write(rt2x00dev, 1, rf->rf1);
-	rt2800pci_rf_write(rt2x00dev, 2, rf->rf2);
-	rt2800pci_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
-	rt2800pci_rf_write(rt2x00dev, 4, rf->rf4);
+	rt2800_rf_write(rt2x00dev, 1, rf->rf1);
+	rt2800_rf_write(rt2x00dev, 2, rf->rf2);
+	rt2800_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt2800_rf_write(rt2x00dev, 4, rf->rf4);
 
 	udelay(200);
 
-	rt2800pci_rf_write(rt2x00dev, 1, rf->rf1);
-	rt2800pci_rf_write(rt2x00dev, 2, rf->rf2);
-	rt2800pci_rf_write(rt2x00dev, 3, rf->rf3 | 0x00000004);
-	rt2800pci_rf_write(rt2x00dev, 4, rf->rf4);
+	rt2800_rf_write(rt2x00dev, 1, rf->rf1);
+	rt2800_rf_write(rt2x00dev, 2, rf->rf2);
+	rt2800_rf_write(rt2x00dev, 3, rf->rf3 | 0x00000004);
+	rt2800_rf_write(rt2x00dev, 4, rf->rf4);
 
 	udelay(200);
 
-	rt2800pci_rf_write(rt2x00dev, 1, rf->rf1);
-	rt2800pci_rf_write(rt2x00dev, 2, rf->rf2);
-	rt2800pci_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
-	rt2800pci_rf_write(rt2x00dev, 4, rf->rf4);
+	rt2800_rf_write(rt2x00dev, 1, rf->rf1);
+	rt2800_rf_write(rt2x00dev, 2, rf->rf2);
+	rt2800_rf_write(rt2x00dev, 3, rf->rf3 & ~0x00000004);
+	rt2800_rf_write(rt2x00dev, 4, rf->rf4);
 }
 
 static void rt2800pci_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
