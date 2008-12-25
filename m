Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbYLYOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbYLYOdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYLYOdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:33:39 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:51280 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYLYOdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:33:38 -0500
Date: Thu, 25 Dec 2008 15:33:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: tnt@246tNt.com, grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/7] arch/powerpc/platforms/52xx: Use DEFINE_SPINLOCK
Message-ID: <Pine.LNX.4.64.0812251533130.22039@ask.diku.dk>
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
diff -u -p a/arch/powerpc/platforms/52xx/mpc52xx_common.c b/arch/powerpc/platforms/52xx/mpc52xx_common.c
--- a/arch/powerpc/platforms/52xx/mpc52xx_common.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_common.c
@@ -42,7 +42,7 @@ static struct of_device_id mpc52xx_bus_i
  * from interrupt context while node mapping (which calls ioremap())
  * cannot be used at such point.
  */
-static spinlock_t mpc52xx_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(mpc52xx_lock);
 static struct mpc52xx_gpt __iomem *mpc52xx_wdt;
 static struct mpc52xx_cdm __iomem *mpc52xx_cdm;
 
