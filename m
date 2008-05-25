Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYEYKc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYEYKc4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762571AbYEYKY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43343 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762585AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 14/28] rt2x00: treat firmware data as const
Message-Id: <E1K0DOB-0007Dg-OJ@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:43 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00pci.h |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c   |    6 +++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 57bdc15..79eabaa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -506,8 +506,8 @@ struct rt2x00lib_ops {
 	 */
 	int (*probe_hw) (struct rt2x00_dev *rt2x00dev);
 	char *(*get_firmware_name) (struct rt2x00_dev *rt2x00dev);
-	u16 (*get_firmware_crc) (void *data, const size_t len);
-	int (*load_firmware) (struct rt2x00_dev *rt2x00dev, void *data,
+	u16 (*get_firmware_crc) (const void *data, const size_t len);
+	int (*load_firmware) (struct rt2x00_dev *rt2x00dev, const void *data,
 			      const size_t len);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 9d1cdb9..b41967e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -82,7 +82,7 @@ static inline void rt2x00pci_register_write(struct rt2x00_dev *rt2x00dev,
 static inline void
 rt2x00pci_register_multiwrite(struct rt2x00_dev *rt2x00dev,
 			      const unsigned long offset,
-			      void *value, const u16 length)
+			      const void *value, const u16 length)
 {
 	memcpy_toio(rt2x00dev->csr.base + offset, value, length);
 }
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 14bc7b2..bb78de5 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -915,7 +915,7 @@ static char *rt61pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return fw_name;
 }
 
-static u16 rt61pci_get_firmware_crc(void *data, const size_t len)
+static u16 rt61pci_get_firmware_crc(const void *data, const size_t len)
 {
 	u16 crc;
 
@@ -932,7 +932,7 @@ static u16 rt61pci_get_firmware_crc(void *data, const size_t len)
 	return crc;
 }
 
-static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
+static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
 				 const size_t len)
 {
 	int i;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index da19a3a..36c2f17 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -850,7 +850,7 @@ static char *rt73usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return FIRMWARE_RT2571;
 }
 
-static u16 rt73usb_get_firmware_crc(void *data, const size_t len)
+static u16 rt73usb_get_firmware_crc(const void *data, const size_t len)
 {
 	u16 crc;
 
@@ -867,13 +867,13 @@ static u16 rt73usb_get_firmware_crc(void *data, const size_t len)
 	return crc;
 }
 
-static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
+static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
 				 const size_t len)
 {
 	unsigned int i;
 	int status;
 	u32 reg;
-	char *ptr = data;
+	const char *ptr = data;
 	char *cache;
 	int buflen;
 	int timeout;
-- 
1.5.4.5

