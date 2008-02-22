Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbYBVWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbYBVWMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbYBVWKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:10:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215AbYBVWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:10:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=PCc25xqx80iaUlQgvu7FUv46MF77tr8frdx+L7w48NSB6H+wXixlvXycgTJedbPG0Ax+nYXyHPHdDiTvt3J7LmoVCDr5x2jNguHp6zusvXpgCgYGdXqwXcAENjPCEpp7jIOCl76beLHkaWM1ys3bg+sKm8avREP/yA5iMkrINrE=
Date: Fri, 22 Feb 2008 23:10:06 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/20] x86: Coding Style fixes to arch/x86/kernel/mca_32.c
Message-ID: <20080222231006.243c1035@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/mca_32.c |   96 +++++++++++++++++++++++++--------------------
 1 files changed, 53 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/mca_32.c b/arch/x86/kernel/mca_32.c
index 9482033..2dc1837 100644
--- a/arch/x86/kernel/mca_32.c
+++ b/arch/x86/kernel/mca_32.c
@@ -53,9 +53,9 @@
 #include <linux/init.h>
 #include <asm/arch_hooks.h>
 
-static unsigned char which_scsi = 0;
+static unsigned char which_scsi;
 
-int MCA_bus = 0;
+int MCA_bus;
 EXPORT_SYMBOL(MCA_bus);
 
 /*
@@ -68,15 +68,17 @@ static DEFINE_SPINLOCK(mca_lock);
 
 /* Build the status info for the adapter */
 
-static void mca_configure_adapter_status(struct mca_device *mca_dev) {
+static void mca_configure_adapter_status(struct mca_device *mca_dev)
+{
 	mca_dev->status = MCA_ADAPTER_NONE;
 
 	mca_dev->pos_id = mca_dev->pos[0]
 		+ (mca_dev->pos[1] << 8);
 
-	if(!mca_dev->pos_id && mca_dev->slot < MCA_MAX_SLOT_NR) {
+	if (!mca_dev->pos_id && mca_dev->slot < MCA_MAX_SLOT_NR) {
 
-		/* id = 0x0000 usually indicates hardware failure,
+		/*
+		 * id = 0x0000 usually indicates hardware failure,
 		 * however, ZP Gu (zpg@castle.net> reports that his 9556
 		 * has 0x0000 as id and everything still works. There
 		 * also seem to be an adapter with id = 0x0000; the
@@ -87,9 +89,10 @@ static void mca_configure_adapter_status(struct mca_device *mca_dev) {
 		mca_dev->status = MCA_ADAPTER_ERROR;
 
 		return;
-	} else if(mca_dev->pos_id != 0xffff) {
+	} else if (mca_dev->pos_id != 0xffff) {
 
-		/* 0xffff usually indicates that there's no adapter,
+		/*
+		 * 0xffff usually indicates that there's no adapter,
 		 * however, some integrated adapters may have 0xffff as
 		 * their id and still be valid. Examples are on-board
 		 * VGA of the 55sx, the integrated SCSI of the 56 & 57,
@@ -99,19 +102,19 @@ static void mca_configure_adapter_status(struct mca_device *mca_dev) {
 		mca_dev->status = MCA_ADAPTER_NORMAL;
 	}
 
-	if((mca_dev->pos_id == 0xffff ||
+	if ((mca_dev->pos_id == 0xffff ||
 	    mca_dev->pos_id == 0x0000) && mca_dev->slot >= MCA_MAX_SLOT_NR) {
 		int j;
 
-		for(j = 2; j < 8; j++) {
-			if(mca_dev->pos[j] != 0xff) {
+		for (j = 2; j < 8; j++) {
+			if (mca_dev->pos[j] != 0xff) {
 				mca_dev->status = MCA_ADAPTER_NORMAL;
 				break;
 			}
 		}
 	}
 
-	if(!(mca_dev->pos[2] & MCA_ENABLED)) {
+	if (!(mca_dev->pos[2] & MCA_ENABLED)) {
 
 		/* enabled bit is in POS 2 */
 
@@ -133,7 +136,7 @@ static struct resource mca_standard_resources[] = {
 
 #define MCA_STANDARD_RESOURCES	ARRAY_SIZE(mca_standard_resources)
 
-/**
+/*
  *	mca_read_and_store_pos - read the POS registers into a memory buffer
  *      @pos: a char pointer to 8 bytes, contains the POS register value on
  *            successful return
@@ -141,12 +144,14 @@ static struct resource mca_standard_resources[] = {
  *	Returns 1 if a card actually exists (i.e. the pos isn't
  *	all 0xff) or 0 otherwise
  */
-static int mca_read_and_store_pos(unsigned char *pos) {
+static int mca_read_and_store_pos(unsigned char *pos)
+{
 	int j;
 	int found = 0;
 
-	for(j=0; j<8; j++) {
-		if((pos[j] = inb_p(MCA_POS_REG(j))) != 0xff) {
+	for (j = 0; j < 8; j++) {
+		pos[j] = inb_p(MCA_POS_REG(j));
+		if (pos[j] != 0xff) {
 			/* 0xff all across means no device. 0x00 means
 			 * something's broken, but a device is
 			 * probably there.  However, if you get 0x00
@@ -167,11 +172,11 @@ static unsigned char mca_pc_read_pos(struct mca_device *mca_dev, int reg)
 	unsigned char byte;
 	unsigned long flags;
 
-	if(reg < 0 || reg >= 8)
+	if (reg < 0 || reg >= 8)
 		return 0;
 
 	spin_lock_irqsave(&mca_lock, flags);
-	if(mca_dev->pos_register) {
+	if (mca_dev->pos_register) {
 		/* Disable adapter setup, enable motherboard setup */
 
 		outb_p(0, MCA_ADAPTER_SETUP_REG);
@@ -203,7 +208,7 @@ static void mca_pc_write_pos(struct mca_device *mca_dev, int reg,
 {
 	unsigned long flags;
 
-	if(reg < 0 || reg >= 8)
+	if (reg < 0 || reg >= 8)
 		return;
 
 	spin_lock_irqsave(&mca_lock, flags);
@@ -227,17 +232,17 @@ static void mca_pc_write_pos(struct mca_device *mca_dev, int reg,
 }
 
 /* for the primary MCA bus, we have identity transforms */
-static int mca_dummy_transform_irq(struct mca_device * mca_dev, int irq)
+static int mca_dummy_transform_irq(struct mca_device *mca_dev, int irq)
 {
 	return irq;
 }
 
-static int mca_dummy_transform_ioport(struct mca_device * mca_dev, int port)
+static int mca_dummy_transform_ioport(struct mca_device *mca_dev, int port)
 {
 	return port;
 }
 
-static void *mca_dummy_transform_memory(struct mca_device * mca_dev, void *mem)
+static void *mca_dummy_transform_memory(struct mca_device *mca_dev, void *mem)
 {
 	return mem;
 }
@@ -251,7 +256,8 @@ static int __init mca_init(void)
 	short mca_builtin_scsi_ports[] = {0xf7, 0xfd, 0x00};
 	struct mca_bus *bus;
 
-	/* WARNING: Be careful when making changes here. Putting an adapter
+	/*
+	 * WARNING: Be careful when making changes here. Putting an adapter
 	 * and the motherboard simultaneously into setup mode may result in
 	 * damage to chips (according to The Indispensible PC Hardware Book
 	 * by Hans-Peter Messmer). Also, we disable system interrupts (so
@@ -283,7 +289,7 @@ static int __init mca_init(void)
 
 	/* get the motherboard device */
 	mca_dev = kzalloc(sizeof(struct mca_device), GFP_KERNEL);
-	if(unlikely(!mca_dev))
+	if (unlikely(!mca_dev))
 		goto out_nomem;
 
 	/*
@@ -309,7 +315,7 @@ static int __init mca_init(void)
 	mca_register_device(MCA_PRIMARY_BUS, mca_dev);
 
 	mca_dev = kzalloc(sizeof(struct mca_device), GFP_ATOMIC);
-	if(unlikely(!mca_dev))
+	if (unlikely(!mca_dev))
 		goto out_unlock_nomem;
 
 	/* Put motherboard into video setup mode, read integrated video
@@ -326,7 +332,8 @@ static int __init mca_init(void)
 	mca_dev->slot = MCA_INTEGVIDEO;
 	mca_register_device(MCA_PRIMARY_BUS, mca_dev);
 
-	/* Put motherboard into scsi setup mode, read integrated scsi
+	/*
+	 * Put motherboard into scsi setup mode, read integrated scsi
 	 * POS registers, and turn motherboard setup off.
 	 *
 	 * It seems there are two possible SCSI registers. Martin says that
@@ -338,18 +345,18 @@ static int __init mca_init(void)
 	 * machine.
 	 */
 
-	for(i = 0; (which_scsi = mca_builtin_scsi_ports[i]) != 0; i++) {
+	for (i = 0; (which_scsi = mca_builtin_scsi_ports[i]) != 0; i++) {
 		outb_p(which_scsi, MCA_MOTHERBOARD_SETUP_REG);
-		if(mca_read_and_store_pos(pos))
+		if (mca_read_and_store_pos(pos))
 			break;
 	}
-	if(which_scsi) {
+	if (which_scsi) {
 		/* found a scsi card */
 		mca_dev = kzalloc(sizeof(struct mca_device), GFP_ATOMIC);
-		if(unlikely(!mca_dev))
+		if (unlikely(!mca_dev))
 			goto out_unlock_nomem;
 
-		for(j = 0; j < 8; j++)
+		for (j = 0; j < 8; j++)
 			mca_dev->pos[j] = pos[j];
 
 		mca_configure_adapter_status(mca_dev);
@@ -364,21 +371,22 @@ static int __init mca_init(void)
 
 	outb_p(0xff, MCA_MOTHERBOARD_SETUP_REG);
 
-	/* Now loop over MCA slots: put each adapter into setup mode, and
+	/*
+	 * Now loop over MCA slots: put each adapter into setup mode, and
 	 * read its POS registers. Then put adapter setup off.
 	 */
 
-	for(i=0; i<MCA_MAX_SLOT_NR; i++) {
+	for (i = 0; i < MCA_MAX_SLOT_NR; i++) {
 		outb_p(0x8|(i&0xf), MCA_ADAPTER_SETUP_REG);
-		if(!mca_read_and_store_pos(pos))
+		if (!mca_read_and_store_pos(pos))
 			continue;
 
 		mca_dev = kzalloc(sizeof(struct mca_device), GFP_ATOMIC);
-		if(unlikely(!mca_dev))
+		if (unlikely(!mca_dev))
 			goto out_unlock_nomem;
 
-		for(j=0; j<8; j++)
-			mca_dev->pos[j]=pos[j];
+		for (j = 0; j < 8; j++)
+			mca_dev->pos[j] = pos[j];
 
 		mca_dev->driver_loaded = 0;
 		mca_dev->slot = i;
@@ -414,20 +422,20 @@ mca_handle_nmi_device(struct mca_device *mca_dev, int check_flag)
 {
 	int slot = mca_dev->slot;
 
-	if(slot == MCA_INTEGSCSI) {
+	if (slot == MCA_INTEGSCSI) {
 		printk(KERN_CRIT "NMI: caused by MCA integrated SCSI adapter (%s)\n",
 			mca_dev->name);
-	} else if(slot == MCA_INTEGVIDEO) {
+	} else if (slot == MCA_INTEGVIDEO) {
 		printk(KERN_CRIT "NMI: caused by MCA integrated video adapter (%s)\n",
 			mca_dev->name);
-	} else if(slot == MCA_MOTHERBOARD) {
+	} else if (slot == MCA_MOTHERBOARD) {
 		printk(KERN_CRIT "NMI: caused by motherboard (%s)\n",
 			mca_dev->name);
 	}
 
 	/* More info available in POS 6 and 7? */
 
-	if(check_flag) {
+	if (check_flag) {
 		unsigned char pos6, pos7;
 
 		pos6 = mca_device_read_pos(mca_dev, 6);
@@ -447,8 +455,9 @@ static int __kprobes mca_handle_nmi_callback(struct device *dev, void *data)
 
 	pos5 = mca_device_read_pos(mca_dev, 5);
 
-	if(!(pos5 & 0x80)) {
-		/* Bit 7 of POS 5 is reset when this adapter has a hardware
+	if (!(pos5 & 0x80)) {
+		/*
+		 *  Bit 7 of POS 5 is reset when this adapter has a hardware
 		 * error. Bit 7 it reset if there's error information
 		 * available in POS 6 and 7.
 		 */
@@ -460,7 +469,8 @@ static int __kprobes mca_handle_nmi_callback(struct device *dev, void *data)
 
 void __kprobes mca_handle_nmi(void)
 {
-	/* First try - scan the various adapters and see if a specific
+	/*
+	 *  First try - scan the various adapters and see if a specific
 	 * adapter was responsible for the error.
 	 */
 	bus_for_each_dev(&mca_bus_type, NULL, NULL, mca_handle_nmi_callback);
-- 
1.5.4.GIT

