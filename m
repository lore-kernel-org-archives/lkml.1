Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab0BPQgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:36:43 -0500
Received: from business.midphase.com ([67.213.211.48]:41931 "EHLO
	business.midphase.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab0BPQgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:36:42 -0500
From: tim@weberpafrica.com
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Tim Schofield <tim.schofield1960@googlemail.com>
Subject: [PATCH] Staging:rtl8192e: fix comments style issue in r8180_93cx6.c This is a patch to the r8180_93cx6.c file that fixes up the comments styling issues found by the checkpatch.pl tool Signed-off-by: Tim Schofield <tim@weberpafrica.com>
Date: Tue, 16 Feb 2010 16:35:16 +0000
Message-Id: <1266338116-27482-1-git-send-email-tim@weberpafrica.com>
X-Mailer: git-send-email 1.6.3.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - business.midphase.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - weberpafrica.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Schofield <tim.schofield1960@googlemail.com>

---
 drivers/staging/rtl8192e/r8180_93cx6.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8180_93cx6.c b/drivers/staging/rtl8192e/r8180_93cx6.c
index 262ed5f..60fba80 100644
--- a/drivers/staging/rtl8192e/r8180_93cx6.c
+++ b/drivers/staging/rtl8192e/r8180_93cx6.c
@@ -23,12 +23,14 @@
 static void eprom_cs(struct net_device *dev, short bit)
 {
 	if (bit)
+		/* enable EPROM */
 		write_nic_byte(dev, EPROM_CMD,
 			       (1<<EPROM_CS_SHIFT) | \
-			       read_nic_byte(dev, EPROM_CMD)); //enable EPROM
+			       read_nic_byte(dev, EPROM_CMD));
 	else
+		/* disable EPROM */
 		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
-			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
+			       &~(1<<EPROM_CS_SHIFT));
 
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
@@ -96,7 +98,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	u32 ret;
 
 	ret = 0;
-        //enable EPROM programming
+	/* enable EPROM programming */
 	write_nic_byte(dev, EPROM_CMD,
 		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
@@ -126,13 +128,17 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_send_bits_string(dev, read_cmd, 3);
 	eprom_send_bits_string(dev, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/*
+	 * keep chip pin D to low state while reading.
+	 * I'm unsure if it is necessary, but anyway shouldn't hurt
+	 */
 	eprom_w(dev, 0);
 
 	for (i = 0; i < 16; i++) {
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+		/*
+		 * eeprom needs a clk cycle between writing opcode&adr
+		 * and reading data. (eeprom outs a dummy 0)
+		 */
 		eprom_ck_cycle(dev);
 		ret |= (eprom_r(dev)<<(15-i));
 	}
@@ -140,7 +146,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_cs(dev, 0);
 	eprom_ck_cycle(dev);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte(dev, EPROM_CMD,
 		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
-- 
1.6.3.3

