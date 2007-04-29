Return-Path: <linux-kernel-owner+w=401wt.eu-S1161095AbXD2Uzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095AbXD2Uzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161151AbXD2Uzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:55:35 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:49430 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161095AbXD2Uze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:55:34 -0400
Message-id: <2822656752623520202@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 4/21] Char: cyclades, unexport struct cyclades_card
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:55:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, unexport struct cyclades_card

Do not export internal card data to userspace. cytune doesn't use this
anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 166b3f753df7acfa71c32b1069e78317f532b0f7
tree c124038b4c9749bd161bde189829700957b98a4f
parent 3441ca636014ff919d5b2b2e920b76dbe7ed9686
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Apr 2007 14:09:57 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:14:58 +0200

 drivers/char/cyclades.c  |    8 --------
 include/linux/cyclades.h |   15 ++-------------
 2 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 249f443..1b4ff13 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4049,14 +4049,6 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	case CYGETRTSDTR_INV:
 		ret_val = info->rtsdtr_inv;
 		break;
-	case CYGETCARDINFO:
-		if (copy_to_user(argp, &cy_card[info->card],
-				 sizeof(struct cyclades_card))) {
-			ret_val = -EFAULT;
-			break;
-		}
-		ret_val = 0;
-		break;
 	case CYGETCD1400VER:
 		ret_val = info->chip_rev;
 		break;
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index f0ad61f..e76f486 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -110,7 +110,6 @@ struct cyclades_idle_stats {
 #define CYZSETPOLLCYCLE		0x43590e
 #define CYZGETPOLLCYCLE		0x43590f
 #define CYGETCD1400VER		0x435910
-#define CYGETCARDINFO		0x435911
 #define	CYSETWAIT		0x435912
 #define	CYGETWAIT		0x435913
 
@@ -506,8 +505,9 @@ struct ZFW_CTRL {
 /****************** ****************** *******************/
 #endif
 
+#ifdef __KERNEL__
+
 /* Per card data structure */
-struct resource;
 struct cyclades_card {
     unsigned long base_phys;
     unsigned long ctl_phys;
@@ -520,20 +520,9 @@ struct cyclades_card {
     int bus_index;	/* address shift - 0 for ISA, 1 for PCI */
     int	intr_enabled;	/* FW Interrupt flag - 0 disabled, 1 enabled */
     struct pci_dev *pdev;
-#ifdef __KERNEL__
     spinlock_t card_lock;
-#else
-    unsigned long filler;
-#endif
 };
 
-struct cyclades_chip {
-  int filler;
-};
-
-
-#ifdef __KERNEL__
-
 /***************************************
  * Memory access functions/macros      *
  * (required to support Alpha systems) *
