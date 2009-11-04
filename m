Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbZKDRea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbZKDRea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932169AbZKDRe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:34:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbZKDReX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lvm3DFFjERC/GiGBsLAudvIfHtHTbRz1gwPs8KJuTN71JrNvvM8os0wGj4f+O+CPz1
         ZvULyk4iorp3ag1bnAX6NsjKylMcfhlwIhx0on+Ci1rXn/i7AeUWxiKUkvHHOWh/1l4m
         Y0HjnQGePQU30ngxV9QAEu+YsVnqJibup33lQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:04 +0100
Message-Id: <20091104173404.28463.65125.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 17/41] rt2800usb: add rt2800_rfcsr_[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: add rt2800_rfcsr_[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   94 ++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 41 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -189,6 +189,18 @@ static void rt2800usb_rfcsr_read(struct 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static inline void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
+				      const unsigned int word, const u8 value)
+{
+	rt2800usb_rfcsr_write(rt2x00dev, word, value);
+}
+
+static inline void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
+				     const unsigned int word, u8 *value)
+{
+	rt2800usb_rfcsr_read(rt2x00dev, word, value);
+}
+
 static void rt2800usb_rf_write(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, const u32 value)
 {
@@ -772,28 +784,28 @@ static void rt2800usb_config_channel_rt3
 {
 	u8 rfcsr;
 
-	rt2800usb_rfcsr_write(rt2x00dev, 2, rf->rf1);
-	rt2800usb_rfcsr_write(rt2x00dev, 2, rf->rf3);
+	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf1);
+	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf3);
 
-	rt2800usb_rfcsr_read(rt2x00dev, 6, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR6_R, rf->rf2);
-	rt2800usb_rfcsr_write(rt2x00dev, 6, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
 
-	rt2800usb_rfcsr_read(rt2x00dev, 12, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 12, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
 			  TXPOWER_G_TO_DEV(info->tx_power1));
-	rt2800usb_rfcsr_write(rt2x00dev, 12, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
-	rt2800usb_rfcsr_read(rt2x00dev, 23, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
-	rt2800usb_rfcsr_write(rt2x00dev, 23, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
 
-	rt2800usb_rfcsr_write(rt2x00dev, 24,
+	rt2800_rfcsr_write(rt2x00dev, 24,
 			      rt2x00dev->calibration[conf_is_ht40(conf)]);
 
-	rt2800usb_rfcsr_read(rt2x00dev, 23, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
-	rt2800usb_rfcsr_write(rt2x00dev, 23, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
 }
 
 static void rt2800usb_config_channel(struct rt2x00_dev *rt2x00dev,
@@ -1666,15 +1678,15 @@ static u8 rt2800usb_init_rx_filter(struc
 	u8 stopband;
 	u8 overtuned = 0;
 
-	rt2800usb_rfcsr_write(rt2x00dev, 24, rfcsr24);
+	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
 
 	rt2800_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * bw40);
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
-	rt2800usb_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 1);
-	rt2800usb_rfcsr_write(rt2x00dev, 22, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
 
 	/*
 	 * Set power & frequency of passband test tone
@@ -1707,12 +1719,12 @@ static u8 rt2800usb_init_rx_filter(struc
 		} else
 			break;
 
-		rt2800usb_rfcsr_write(rt2x00dev, 24, rfcsr24);
+		rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
 	}
 
 	rfcsr24 -= !!overtuned;
 
-	rt2800usb_rfcsr_write(rt2x00dev, 24, rfcsr24);
+	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
 	return rfcsr24;
 }
 
@@ -1727,33 +1739,33 @@ static int rt2800usb_init_rfcsr(struct r
 	/*
 	 * Init RF calibration.
 	 */
-	rt2800usb_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-	rt2800usb_rfcsr_write(rt2x00dev, 30, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 	msleep(1);
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-	rt2800usb_rfcsr_write(rt2x00dev, 30, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
-	rt2800usb_rfcsr_write(rt2x00dev, 4, 0x40);
-	rt2800usb_rfcsr_write(rt2x00dev, 5, 0x03);
-	rt2800usb_rfcsr_write(rt2x00dev, 6, 0x02);
-	rt2800usb_rfcsr_write(rt2x00dev, 7, 0x70);
-	rt2800usb_rfcsr_write(rt2x00dev, 9, 0x0f);
-	rt2800usb_rfcsr_write(rt2x00dev, 10, 0x71);
-	rt2800usb_rfcsr_write(rt2x00dev, 11, 0x21);
-	rt2800usb_rfcsr_write(rt2x00dev, 12, 0x7b);
-	rt2800usb_rfcsr_write(rt2x00dev, 14, 0x90);
-	rt2800usb_rfcsr_write(rt2x00dev, 15, 0x58);
-	rt2800usb_rfcsr_write(rt2x00dev, 16, 0xb3);
-	rt2800usb_rfcsr_write(rt2x00dev, 17, 0x92);
-	rt2800usb_rfcsr_write(rt2x00dev, 18, 0x2c);
-	rt2800usb_rfcsr_write(rt2x00dev, 19, 0x02);
-	rt2800usb_rfcsr_write(rt2x00dev, 20, 0xba);
-	rt2800usb_rfcsr_write(rt2x00dev, 21, 0xdb);
-	rt2800usb_rfcsr_write(rt2x00dev, 24, 0x16);
-	rt2800usb_rfcsr_write(rt2x00dev, 25, 0x01);
-	rt2800usb_rfcsr_write(rt2x00dev, 27, 0x03);
-	rt2800usb_rfcsr_write(rt2x00dev, 29, 0x1f);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x71);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
+	rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
 
 	/*
 	 * Set RX Filter calibration for 20MHz and 40MHz
@@ -1768,9 +1780,9 @@ static int rt2800usb_init_rfcsr(struct r
 	 */
 	rt2800_bbp_write(rt2x00dev, 24, 0);
 
-	rt2800usb_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
-	rt2800usb_rfcsr_write(rt2x00dev, 22, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
 
 	/*
 	 * set BBP back to BW20
