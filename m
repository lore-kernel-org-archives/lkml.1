Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYHUEts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYHUEts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 00:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYHUErP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 00:47:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:60667 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYHUErJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 00:47:09 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 7/9] powerpc: convert CONFIG_PPC_MERGE to CONFIG_PPC for legacy io checks
Date: Wed, 20 Aug 2008 23:46:56 -0500
Message-Id: <1219294018-12557-8-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1219294018-12557-7-git-send-email-galak@kernel.crashing.org>
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-2-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-3-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-4-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-5-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-6-git-send-email-galak@kernel.crashing.org>
 <1219294018-12557-7-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that arch/ppc is dead CONFIG_PPC_MERGE is always defined for all
powerpc platforms and we want to get rid of CONFIG_PPC_MERGE use
CONFIG_PPC instead.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/block/floppy.c           |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c |    2 +-
 drivers/i2c/busses/i2c-pca-isa.c |    2 +-
 drivers/input/serio/i8042-io.h   |    2 +-
 drivers/pnp/isapnp/core.c        |    2 +-
 drivers/pnp/pnpbios/core.c       |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 395f8ea..5813e0d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4165,7 +4165,7 @@ static int __init floppy_init(void)
 	int i, unit, drive;
 	int err, dr;
 
-#if defined(CONFIG_PPC_MERGE)
+#if defined(CONFIG_PPC)
 	if (check_legacy_ioport(FDC1))
 		return -ENODEV;
 #endif
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 8e8afb6..3123bf5 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2695,7 +2695,7 @@ static __devinit void default_find_bmc(void)
 	for (i = 0; ; i++) {
 		if (!ipmi_defaults[i].port)
 			break;
-#ifdef CONFIG_PPC_MERGE
+#ifdef CONFIG_PPC
 		if (check_legacy_ioport(ipmi_defaults[i].port))
 			continue;
 #endif
diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
index a119784..28d8463 100644
--- a/drivers/i2c/busses/i2c-pca-isa.c
+++ b/drivers/i2c/busses/i2c-pca-isa.c
@@ -113,7 +113,7 @@ static int __devinit pca_isa_probe(struct device *dev, unsigned int id)
 
 	dev_info(dev, "i/o base %#08lx. irq %d\n", base, irq);
 
-#ifdef CONFIG_PPC_MERGE
+#ifdef CONFIG_PPC
 	if (check_legacy_ioport(base)) {
 		dev_err(dev, "I/O address %#08lx is not available\n", base);
 		goto out;
diff --git a/drivers/input/serio/i8042-io.h b/drivers/input/serio/i8042-io.h
index f451c73..847f4aa 100644
--- a/drivers/input/serio/i8042-io.h
+++ b/drivers/input/serio/i8042-io.h
@@ -67,7 +67,7 @@ static inline int i8042_platform_init(void)
  * On some platforms touching the i8042 data register region can do really
  * bad things. Because of this the region is always reserved on such boxes.
  */
-#if defined(CONFIG_PPC_MERGE)
+#if defined(CONFIG_PPC)
 	if (check_legacy_ioport(I8042_DATA_REG))
 		return -ENODEV;
 #endif
diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index 101a835..46455fb 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -1012,7 +1012,7 @@ static int __init isapnp_init(void)
 		printk(KERN_INFO "isapnp: ISA Plug & Play support disabled\n");
 		return 0;
 	}
-#ifdef CONFIG_PPC_MERGE
+#ifdef CONFIG_PPC
 	if (check_legacy_ioport(_PIDXR) || check_legacy_ioport(_PNPWRP))
 		return -EINVAL;
 #endif
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 19a4be1..0797dd1 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -519,7 +519,7 @@ static int __init pnpbios_init(void)
 {
 	int ret;
 
-#if defined(CONFIG_PPC_MERGE)
+#if defined(CONFIG_PPC)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return -ENODEV;
 #endif
@@ -577,7 +577,7 @@ static int __init pnpbios_thread_init(void)
 {
 	struct task_struct *task;
 
-#if defined(CONFIG_PPC_MERGE)
+#if defined(CONFIG_PPC)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return 0;
 #endif
-- 
1.5.5.1

