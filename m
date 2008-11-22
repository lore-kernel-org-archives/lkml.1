Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbYKVRgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbYKVRgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759203AbYKVRfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:35:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55395 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbYKVRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:35:06 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 11/32] of_platform_driver noise on sparce
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1L3wNs-0006R4-JQ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:35:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


switch to __init for those; unlike powerpc sparc has no hotplug support
for that stuff and their ->probe() tends to call __init functions while
being declared __devinit.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc64/kernel/pci_fire.c   |    2 +-
 arch/sparc64/kernel/pci_psycho.c |    4 ++--
 arch/sparc64/kernel/pci_sun4v.c  |    2 +-
 drivers/sbus/char/bbc_i2c.c      |    6 +++---
 sound/sparc/cs4231.c             |   10 +++++-----
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/sparc64/kernel/pci_fire.c b/arch/sparc64/kernel/pci_fire.c
--- a/arch/sparc64/kernel/pci_fire.c
+++ b/arch/sparc64/kernel/pci_fire.c
@@ -455,7 +455,7 @@ static int __init pci_fire_pbm_init(struct pci_pbm_info *pbm,
 	return 0;
 }
 
-static int __devinit fire_probe(struct of_device *op,
+static int __init fire_probe(struct of_device *op,
 				const struct of_device_id *match)
 {
 	struct device_node *dp = op->node;
diff --git a/arch/sparc64/kernel/pci_psycho.c b/arch/sparc64/kernel/pci_psycho.c
--- a/arch/sparc64/kernel/pci_psycho.c
+++ b/arch/sparc64/kernel/pci_psycho.c
@@ -493,7 +493,7 @@ static void __init psycho_pbm_init(struct pci_pbm_info *pbm,
 	psycho_scan_bus(pbm, &op->dev);
 }
 
-static struct pci_pbm_info * __devinit psycho_find_sibling(u32 upa_portid)
+static struct pci_pbm_info * __init psycho_find_sibling(u32 upa_portid)
 {
 	struct pci_pbm_info *pbm;
 
@@ -506,7 +506,7 @@ static struct pci_pbm_info * __devinit psycho_find_sibling(u32 upa_portid)
 
 #define PSYCHO_CONFIGSPACE	0x001000000UL
 
-static int __devinit psycho_probe(struct of_device *op,
+static int __init psycho_probe(struct of_device *op,
 				  const struct of_device_id *match)
 {
 	const struct linux_prom64_registers *pr_regs;
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -929,7 +929,7 @@ static int __init pci_sun4v_pbm_init(struct pci_pbm_info *pbm,
 	return 0;
 }
 
-static int __devinit pci_sun4v_probe(struct of_device *op,
+static int __init pci_sun4v_probe(struct of_device *op,
 				     const struct of_device_id *match)
 {
 	const struct linux_prom64_registers *regs;
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -361,7 +361,7 @@ fail:
 extern int bbc_envctrl_init(struct bbc_i2c_bus *bp);
 extern void bbc_envctrl_cleanup(struct bbc_i2c_bus *bp);
 
-static int __devinit bbc_i2c_probe(struct of_device *op,
+static int __init bbc_i2c_probe(struct of_device *op,
 				   const struct of_device_id *match)
 {
 	struct bbc_i2c_bus *bp;
@@ -386,7 +386,7 @@ static int __devinit bbc_i2c_probe(struct of_device *op,
 	return err;
 }
 
-static int __devexit bbc_i2c_remove(struct of_device *op)
+static int __exit bbc_i2c_remove(struct of_device *op)
 {
 	struct bbc_i2c_bus *bp = dev_get_drvdata(&op->dev);
 
@@ -417,7 +417,7 @@ static struct of_platform_driver bbc_i2c_driver = {
 	.name		= "bbc_i2c",
 	.match_table	= bbc_i2c_match,
 	.probe		= bbc_i2c_probe,
-	.remove		= __devexit_p(bbc_i2c_remove),
+	.remove		= __exit_p(bbc_i2c_remove),
 };
 
 static int __init bbc_i2c_init(void)
diff --git a/sound/sparc/cs4231.c b/sound/sparc/cs4231.c
--- a/sound/sparc/cs4231.c
+++ b/sound/sparc/cs4231.c
@@ -1856,7 +1856,7 @@ static int __init snd_cs4231_sbus_create(struct snd_card *card,
 	return 0;
 }
 
-static int __devinit cs4231_sbus_probe(struct of_device *op, const struct of_device_id *match)
+static int __init cs4231_sbus_probe(struct of_device *op, const struct of_device_id *match)
 {
 	struct resource *rp = &op->resource[0];
 	struct snd_card *card;
@@ -2048,7 +2048,7 @@ static int __init snd_cs4231_ebus_create(struct snd_card *card,
 	return 0;
 }
 
-static int __devinit cs4231_ebus_probe(struct of_device *op, const struct of_device_id *match)
+static int __init cs4231_ebus_probe(struct of_device *op, const struct of_device_id *match)
 {
 	struct snd_card *card;
 	int err;
@@ -2072,7 +2072,7 @@ static int __devinit cs4231_ebus_probe(struct of_device *op, const struct of_dev
 }
 #endif
 
-static int __devinit cs4231_probe(struct of_device *op, const struct of_device_id *match)
+static int __init cs4231_probe(struct of_device *op, const struct of_device_id *match)
 {
 #ifdef EBUS_SUPPORT
 	if (!strcmp(op->node->parent->name, "ebus"))
@@ -2086,7 +2086,7 @@ static int __devinit cs4231_probe(struct of_device *op, const struct of_device_i
 	return -ENODEV;
 }
 
-static int __devexit cs4231_remove(struct of_device *op)
+static int __exit cs4231_remove(struct of_device *op)
 {
 	struct snd_cs4231 *chip = dev_get_drvdata(&op->dev);
 
@@ -2112,7 +2112,7 @@ static struct of_platform_driver cs4231_driver = {
 	.name		= "audio",
 	.match_table	= cs4231_match,
 	.probe		= cs4231_probe,
-	.remove		= __devexit_p(cs4231_remove),
+	.remove		= __exit_p(cs4231_remove),
 };
 
 static int __init cs4231_init(void)
