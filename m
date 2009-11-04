Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZKDReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZKDReg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbZKDRee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:34:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbZKDRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VMGnVunmfqyhO1UMV9OdzuYMQMfuIUH5fGN6yN8msaMQNZCxfkf5bNm5kJLXjx7CdS
         oqCTO2CZCaI4sXGVuTP0Sn7hDhbwGq8FDIZgHfJmj/8Kv16fJD19kwzNST8fP4RWZ8vL
         F1cbFrPBJLAi0b/OEFBjP/U7NA84wiy1kW8Vg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:34:11 +0100
Message-Id: <20091104173411.28463.16599.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/41] rt2800pci: add rt2800_rfcsr_[read,write]() wrappers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800pci: add rt2800_rfcsr_[read,write]() wrappers

Part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |  114 +++++++++++++++++---------------
 1 file changed, 63 insertions(+), 51 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -199,6 +199,18 @@ static void rt2800pci_rfcsr_read(struct 
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static inline void rt2800_rfcsr_write(struct rt2x00_dev *rt2x00dev,
+				      const unsigned int word, const u8 value)
+{
+	rt2800pci_rfcsr_write(rt2x00dev, word, value);
+}
+
+static inline void rt2800_rfcsr_read(struct rt2x00_dev *rt2x00dev,
+				     const unsigned int word, u8 *value)
+{
+	rt2800pci_rfcsr_read(rt2x00dev, word, value);
+}
+
 static void rt2800pci_rf_write(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, const u32 value)
 {
@@ -912,28 +924,28 @@ static void rt2800pci_config_channel_rt3
 {
 	u8 rfcsr;
 
-	rt2800pci_rfcsr_write(rt2x00dev, 2, rf->rf1);
-	rt2800pci_rfcsr_write(rt2x00dev, 2, rf->rf3);
+	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf1);
+	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf3);
 
-	rt2800pci_rfcsr_read(rt2x00dev, 6, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR6_R, rf->rf2);
-	rt2800pci_rfcsr_write(rt2x00dev, 6, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
 
-	rt2800pci_rfcsr_read(rt2x00dev, 12, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 12, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
 			  TXPOWER_G_TO_DEV(info->tx_power1));
-	rt2800pci_rfcsr_write(rt2x00dev, 12, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
-	rt2800pci_rfcsr_read(rt2x00dev, 23, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
-	rt2800pci_rfcsr_write(rt2x00dev, 23, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
 
-	rt2800pci_rfcsr_write(rt2x00dev, 24,
+	rt2800_rfcsr_write(rt2x00dev, 24,
 			      rt2x00dev->calibration[conf_is_ht40(conf)]);
 
-	rt2800pci_rfcsr_read(rt2x00dev, 23, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
-	rt2800pci_rfcsr_write(rt2x00dev, 23, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
 }
 
 static void rt2800pci_config_channel(struct rt2x00_dev *rt2x00dev,
@@ -1802,15 +1814,15 @@ static u8 rt2800pci_init_rx_filter(struc
 	u8 stopband;
 	u8 overtuned = 0;
 
-	rt2800pci_rfcsr_write(rt2x00dev, 24, rfcsr24);
+	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
 
 	rt2800_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * bw40);
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
-	rt2800pci_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 1);
-	rt2800pci_rfcsr_write(rt2x00dev, 22, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
 
 	/*
 	 * Set power & frequency of passband test tone
@@ -1843,12 +1855,12 @@ static u8 rt2800pci_init_rx_filter(struc
 		} else
 			break;
 
-		rt2800pci_rfcsr_write(rt2x00dev, 24, rfcsr24);
+		rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
 	}
 
 	rfcsr24 -= !!overtuned;
 
-	rt2800pci_rfcsr_write(rt2x00dev, 24, rfcsr24);
+	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
 	return rfcsr24;
 }
 
@@ -1865,43 +1877,43 @@ static int rt2800pci_init_rfcsr(struct r
 	/*
 	 * Init RF calibration.
 	 */
-	rt2800pci_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
-	rt2800pci_rfcsr_write(rt2x00dev, 30, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 	msleep(1);
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
-	rt2800pci_rfcsr_write(rt2x00dev, 30, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
-	rt2800pci_rfcsr_write(rt2x00dev, 0, 0x50);
-	rt2800pci_rfcsr_write(rt2x00dev, 1, 0x01);
-	rt2800pci_rfcsr_write(rt2x00dev, 2, 0xf7);
-	rt2800pci_rfcsr_write(rt2x00dev, 3, 0x75);
-	rt2800pci_rfcsr_write(rt2x00dev, 4, 0x40);
-	rt2800pci_rfcsr_write(rt2x00dev, 5, 0x03);
-	rt2800pci_rfcsr_write(rt2x00dev, 6, 0x02);
-	rt2800pci_rfcsr_write(rt2x00dev, 7, 0x50);
-	rt2800pci_rfcsr_write(rt2x00dev, 8, 0x39);
-	rt2800pci_rfcsr_write(rt2x00dev, 9, 0x0f);
-	rt2800pci_rfcsr_write(rt2x00dev, 10, 0x60);
-	rt2800pci_rfcsr_write(rt2x00dev, 11, 0x21);
-	rt2800pci_rfcsr_write(rt2x00dev, 12, 0x75);
-	rt2800pci_rfcsr_write(rt2x00dev, 13, 0x75);
-	rt2800pci_rfcsr_write(rt2x00dev, 14, 0x90);
-	rt2800pci_rfcsr_write(rt2x00dev, 15, 0x58);
-	rt2800pci_rfcsr_write(rt2x00dev, 16, 0xb3);
-	rt2800pci_rfcsr_write(rt2x00dev, 17, 0x92);
-	rt2800pci_rfcsr_write(rt2x00dev, 18, 0x2c);
-	rt2800pci_rfcsr_write(rt2x00dev, 19, 0x02);
-	rt2800pci_rfcsr_write(rt2x00dev, 20, 0xba);
-	rt2800pci_rfcsr_write(rt2x00dev, 21, 0xdb);
-	rt2800pci_rfcsr_write(rt2x00dev, 22, 0x00);
-	rt2800pci_rfcsr_write(rt2x00dev, 23, 0x31);
-	rt2800pci_rfcsr_write(rt2x00dev, 24, 0x08);
-	rt2800pci_rfcsr_write(rt2x00dev, 25, 0x01);
-	rt2800pci_rfcsr_write(rt2x00dev, 26, 0x25);
-	rt2800pci_rfcsr_write(rt2x00dev, 27, 0x23);
-	rt2800pci_rfcsr_write(rt2x00dev, 28, 0x13);
-	rt2800pci_rfcsr_write(rt2x00dev, 29, 0x83);
+	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
+	rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
+	rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
 
 	/*
 	 * Set RX Filter calibration for 20MHz and 40MHz
@@ -1916,9 +1928,9 @@ static int rt2800pci_init_rfcsr(struct r
 	 */
 	rt2800_bbp_write(rt2x00dev, 24, 0);
 
-	rt2800pci_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
-	rt2800pci_rfcsr_write(rt2x00dev, 22, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
 
 	/*
 	 * set BBP back to BW20
