Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0BMMKK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 07:10:10 -0500
Received: from woodbine.london.02.net ([87.194.255.145]:44596 "EHLO
	woodbine.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0BMMKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 07:10:08 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 07:10:08 EST
From: Gordon Mitchell <gordon@dumgoyne.me.uk>
To: gregkh@suse.de, gordon@dumgoyne.me.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8187se: Apply kernel coding style to source file r8180_93cx6.c This is a patch to the r8180_93cx6.c source file to correct all kernel coding style errors and warnings flagged by checkpatch.pl Signed-off-by: Gordon Mitchell <gordon@dumgoyne.me.uk>
Date: Sat, 13 Feb 2010 12:04:06 +0000
Message-Id: <1266062646-6584-1-git-send-email-gordon@dumgoyne.me.uk>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/rtl8187se/r8180_93cx6.c |   86 ++++++++++++++++---------------
 1 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_93cx6.c b/drivers/staging/rtl8187se/r8180_93cx6.c
index 7e4711f..c6884d6 100644
--- a/drivers/staging/rtl8187se/r8180_93cx6.c
+++ b/drivers/staging/rtl8187se/r8180_93cx6.c
@@ -22,13 +22,15 @@
 
 void eprom_cs(struct net_device *dev, short bit)
 {
-	if(bit)
+	if (bit)
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
@@ -38,24 +40,24 @@ void eprom_cs(struct net_device *dev, short bit)
 void eprom_ck_cycle(struct net_device *dev)
 {
 	write_nic_byte(dev, EPROM_CMD,
-		       (1<<EPROM_CK_SHIFT) | read_nic_byte(dev,EPROM_CMD));
+		(1<<EPROM_CK_SHIFT) | read_nic_byte(dev, EPROM_CMD));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 	write_nic_byte(dev, EPROM_CMD,
-		       read_nic_byte(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
+		read_nic_byte(dev, EPROM_CMD) & ~(1<<EPROM_CK_SHIFT));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 }
 
 
-void eprom_w(struct net_device *dev,short bit)
+void eprom_w(struct net_device *dev, short bit)
 {
-	if(bit)
+	if (bit)
 		write_nic_byte(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) | \
-			       read_nic_byte(dev,EPROM_CMD));
+			read_nic_byte(dev, EPROM_CMD));
 	else
-		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev,EPROM_CMD)\
-			       &~(1<<EPROM_W_SHIFT));
+		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
+			&~(1<<EPROM_W_SHIFT));
 
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
@@ -66,10 +68,11 @@ short eprom_r(struct net_device *dev)
 {
 	short bit;
 
-	bit=(read_nic_byte(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
+	bit = (read_nic_byte(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
 	udelay(EPROM_DELAY);
 
-	if(bit) return 1;
+	if (bit)
+		return 1;
 	return 0;
 }
 
@@ -78,7 +81,7 @@ void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 {
 	int i;
 
-	for(i=0; i<len; i++){
+	for (i = 0; i < len; i++) {
 		eprom_w(dev, b[i]);
 		eprom_ck_cycle(dev);
 	}
@@ -88,50 +91,51 @@ void eprom_send_bits_string(struct net_device *dev, short b[], int len)
 u32 eprom_read(struct net_device *dev, u32 addr)
 {
 	struct r8180_priv *priv = ieee80211_priv(dev);
-	short read_cmd[]={1,1,0};
+	short read_cmd[] = {1, 1, 0};
 	short addr_str[8];
 	int i;
 	int addr_len;
 	u32 ret;
 
-	ret=0;
-        //enable EPROM programming
+	ret = 0;
+	/* enable EPROM programming */
 	write_nic_byte(dev, EPROM_CMD,
-		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
+		(EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	force_pci_posting(dev);
 	udelay(EPROM_DELAY);
 
-	if (priv->epromtype==EPROM_93c56){
-		addr_str[7]=addr & 1;
-		addr_str[6]=addr & (1<<1);
-		addr_str[5]=addr & (1<<2);
-		addr_str[4]=addr & (1<<3);
-		addr_str[3]=addr & (1<<4);
-		addr_str[2]=addr & (1<<5);
-		addr_str[1]=addr & (1<<6);
-		addr_str[0]=addr & (1<<7);
-		addr_len=8;
-	}else{
-		addr_str[5]=addr & 1;
-		addr_str[4]=addr & (1<<1);
-		addr_str[3]=addr & (1<<2);
-		addr_str[2]=addr & (1<<3);
-		addr_str[1]=addr & (1<<4);
-		addr_str[0]=addr & (1<<5);
-		addr_len=6;
+	if (priv->epromtype == EPROM_93c56) {
+		addr_str[7] = addr & 1;
+		addr_str[6] = addr & (1<<1);
+		addr_str[5] = addr & (1<<2);
+		addr_str[4] = addr & (1<<3);
+		addr_str[3] = addr & (1<<4);
+		addr_str[2] = addr & (1<<5);
+		addr_str[1] = addr & (1<<6);
+		addr_str[0] = addr & (1<<7);
+		addr_len = 8;
+	} else {
+		addr_str[5] = addr & 1;
+		addr_str[4] = addr & (1<<1);
+		addr_str[3] = addr & (1<<2);
+		addr_str[2] = addr & (1<<3);
+		addr_str[1] = addr & (1<<4);
+		addr_str[0] = addr & (1<<5);
+		addr_len = 6;
 	}
 	eprom_cs(dev, 1);
 	eprom_ck_cycle(dev);
 	eprom_send_bits_string(dev, read_cmd, 3);
 	eprom_send_bits_string(dev, addr_str, addr_len);
 
-	//keep chip pin D to low state while reading.
-	//I'm unsure if it is necessary, but anyway shouldn't hurt
+	/* keep chip pin D to low state while reading.
+	I'm unsure if it is necessary, but anyway shouldn't hurt */
+
 	eprom_w(dev, 0);
 
-	for(i=0;i<16;i++){
-		//eeprom needs a clk cycle between writing opcode&adr
-		//and reading data. (eeprom outs a dummy 0)
+	for (i = 0; i < 16; i++) {
+		/* eeprom needs a clk cycle between writing opcode&adr
+		and reading data. (eeprom outs a dummy 0) */
 		eprom_ck_cycle(dev);
 		ret |= (eprom_r(dev)<<(15-i));
 	}
@@ -139,7 +143,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
 	eprom_cs(dev, 0);
 	eprom_ck_cycle(dev);
 
-	//disable EPROM programming
+	/* disable EPROM programming */
 	write_nic_byte(dev, EPROM_CMD,
 		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
 	return ret;
-- 
1.6.3.3

