Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYLYOeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYLYOeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYLYOeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:34:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:42501 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbYLYOeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:34:08 -0500
Date: Thu, 25 Dec 2008 15:34:04 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: olof@lixom.net, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/7] arch/powerpc/platforms/pasemi: Use DEFINE_SPINLOCK
Message-ID: <Pine.LNX.4.64.0812251533350.22039@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

SPIN_LOCK_UNLOCKED is deprecated.  The following makes the change suggested
in Documentation/spinlocks.txt

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
declarer name DEFINE_SPINLOCK;
identifier xxx_lock;
@@

- spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
+ DEFINE_SPINLOCK(xxx_lock);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/arch/powerpc/platforms/pasemi/dma_lib.c b/arch/powerpc/platforms/pasemi/dma_lib.c
--- a/arch/powerpc/platforms/pasemi/dma_lib.c
+++ b/arch/powerpc/platforms/pasemi/dma_lib.c
@@ -509,7 +509,7 @@ fallback:
  */
 int pasemi_dma_init(void)
 {
-	static spinlock_t init_lock = SPIN_LOCK_UNLOCKED;
+	static DEFINE_SPINLOCK(init_lock);
 	struct pci_dev *iob_pdev;
 	struct pci_dev *pdev;
 	struct resource res;
