Return-Path: <linux-kernel-owner+w=401wt.eu-S1751062AbXBCSiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbXBCSiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 13:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXBCSiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 13:38:22 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50229 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbXBCSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 13:38:22 -0500
Date: Sat, 3 Feb 2007 19:38:16 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070203183812.20821.90016.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/media/radio/: Convert to generic boolean-values
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/media/radio/radio-gemtek-pci.c b/drivers/media/radio/radio-gemtek-pci.c
index eb14106..45649cc 100644
--- a/drivers/media/radio/radio-gemtek-pci.c
+++ b/drivers/media/radio/radio-gemtek-pci.c
@@ -89,14 +89,6 @@ static struct v4l2_queryctrl radio_qctrl[] = {
 #define GEMTEK_PCI_RANGE_HIGH (108*16000)
 #endif
 
-#ifndef TRUE
-#define TRUE (1)
-#endif
-
-#ifndef FALSE
-#define FALSE (0)
-#endif
-
 struct gemtek_pci_card {
 	struct video_device *videodev;
 
@@ -146,12 +138,12 @@ static void __gemtek_pci_cmd( u16 value, u32 port, u8 *last_byte, int keep )
 
 static inline void gemtek_pci_nil( u32 port, u8 *last_byte )
 {
-	__gemtek_pci_cmd( 0x00, port, last_byte, FALSE );
+	__gemtek_pci_cmd( 0x00, port, last_byte, false );
 }
 
 static inline void gemtek_pci_cmd( u16 cmd, u32 port, u8 *last_byte )
 {
-	__gemtek_pci_cmd( cmd, port, last_byte, TRUE );
+	__gemtek_pci_cmd( cmd, port, last_byte, true );
 }
 
 static void gemtek_pci_setfrequency( struct gemtek_pci_card *card, unsigned long frequency )
@@ -184,14 +176,14 @@ static void gemtek_pci_setfrequency( struct gemtek_pci_card *card, unsigned long
 static inline void gemtek_pci_mute( struct gemtek_pci_card *card )
 {
 	outb( 0x1f, card->iobase );
-	card->mute = TRUE;
+	card->mute = true;
 }
 
 static inline void gemtek_pci_unmute( struct gemtek_pci_card *card )
 {
 	if ( card->mute ) {
 		gemtek_pci_setfrequency( card, card->current_frequency );
-		card->mute = FALSE;
+		card->mute = false;
 	}
 }
 
@@ -259,7 +251,7 @@ static int gemtek_pci_do_ioctl(struct inode *inode, struct file *file,
 
 			gemtek_pci_setfrequency( card, f->frequency );
 			card->current_frequency = f->frequency;
-			card->mute = FALSE;
+			card->mute = false;
 			return 0;
 		}
 		case VIDIOC_QUERYCTRL:
