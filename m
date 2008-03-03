Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYCCSUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYCCSUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYCCST4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:19:56 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:34850 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYCCSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:19:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GbgKabaVvhawcQgtXPuoZ7MdheuU4Ey0QU+u8Pf9oIUv1PgcjRxA587pXvhEDk6/K9C1kV66d4IfsGkceSybKdawc/CCLJ2Qa7L84fY9CE5eJ5YCT7Gvw9oHx9LKbUoaTb4c5s0ErXJGglOegWD+XU5fzBwrq8kbR2GMV4ln+lk=
Subject: [PATCH] blackfin: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 10:19:49 -0800
Message-Id: <1204568389.3266.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/blackfin/kernel/bfin_gpio.c                |    8 ++++----
 arch/blackfin/kernel/dma-mapping.c              |    4 ++--
 arch/blackfin/mach-bf527/boards/ezkit.c         |    4 ++--
 arch/blackfin/mach-bf533/boards/H8606.c         |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf533/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c |    4 ++--
 arch/blackfin/mach-bf537/boards/minotaur.c      |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c        |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    4 ++--
 arch/blackfin/mach-bf548/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf561/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf561/boards/tepla.c         |    2 +-
 arch/blackfin/mach-common/ints-priority.c       |    2 +-
 arch/blackfin/oprofile/common.c                 |    2 +-
 arch/blackfin/oprofile/op_model_bf533.c         |    2 +-
 21 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 08788f7..ad935e6 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -823,7 +823,7 @@ int peripheral_request(unsigned short per, const char *label)
 	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
 		printk(KERN_ERR
 		    "%s: Peripheral %d is already reserved as GPIO by %s !\n",
-		       __FUNCTION__, ident, get_label(ident));
+		       __func__, ident, get_label(ident));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -850,7 +850,7 @@ int peripheral_request(unsigned short per, const char *label)
 
 			printk(KERN_ERR
 			       "%s: Peripheral %d function %d is already reserved by %s !\n",
-			       __FUNCTION__, ident, P_FUNCT2MUX(per), get_label(ident));
+			       __func__, ident, P_FUNCT2MUX(per), get_label(ident));
 			dump_stack();
 			local_irq_restore(flags);
 			return -EBUSY;
@@ -893,7 +893,7 @@ int peripheral_request(unsigned short per, const char *label)
 	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
 		printk(KERN_ERR
 		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
-		       __FUNCTION__, ident, get_label(ident));
+		       __func__, ident, get_label(ident));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -921,7 +921,7 @@ int peripheral_request(unsigned short per, const char *label)
 			printk(KERN_ERR
 			       "%s: Peripheral %d function %d is already"
 			       " reserved by %s !\n",
-			       __FUNCTION__, ident, P_FUNCT2MUX(per),
+			       __func__, ident, P_FUNCT2MUX(per),
 				get_label(ident));
 			dump_stack();
 			local_irq_restore(flags);
diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
index d6b61d5..2f62a9f 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -59,7 +59,7 @@ void dma_alloc_init(unsigned long start, unsigned long end)
 	memset((void *)dma_base, 0, DMA_UNCACHED_REGION);
 	dma_initialized = 1;
 
-	printk(KERN_INFO "%s: dma_page @ 0x%p - %d pages at 0x%08lx\n", __FUNCTION__,
+	printk(KERN_INFO "%s: dma_page @ 0x%p - %d pages at 0x%08lx\n", __func__,
 	       dma_page, dma_pages, dma_base);
 }
 
@@ -100,7 +100,7 @@ static void __free_dma_pages(unsigned long addr, unsigned int pages)
 	int i;
 
 	if ((page + pages) > dma_pages) {
-		printk(KERN_ERR "%s: freeing outside range.\n", __FUNCTION__);
+		printk(KERN_ERR "%s: freeing outside range.\n", __func__);
 		BUG();
 	}
 
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index cf4bc0d..1452391 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -94,7 +94,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
@@ -896,7 +896,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 97378b0..39c3dd3 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -411,7 +411,7 @@ static struct platform_device *h8606_devices[] __initdata = {
 static int __init H8606_init(void)
 {
 	printk(KERN_INFO "HV Sistemas H8606 board support by http://www.hvsistemas.com\n");
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(h8606_devices, ARRAY_SIZE(h8606_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index 886f260..7e7b7c9 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -355,7 +355,7 @@ static struct platform_device *cm_bf533_devices[] __initdata = {
 
 static int __init cm_bf533_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf533_devices, ARRAY_SIZE(cm_bf533_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 241b5a2..35c1efd 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -369,7 +369,7 @@ static struct platform_device *ezkit_devices[] __initdata = {
 
 static int __init ezkit_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff --git a/arch/blackfin/mach-bf533/boards/generic_board.c b/arch/blackfin/mach-bf533/boards/generic_board.c
index e359a0d..82b1f6a 100644
--- a/arch/blackfin/mach-bf533/boards/generic_board.c
+++ b/arch/blackfin/mach-bf533/boards/generic_board.c
@@ -84,7 +84,7 @@ static struct platform_device *generic_board_devices[] __initdata = {
 
 static int __init generic_board_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	return platform_add_devices(generic_board_devices, ARRAY_SIZE(generic_board_devices));
 }
 
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index b2ac481..681686d 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -522,7 +522,7 @@ static int __init stamp_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	ret = platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	if (ret < 0)
 		return ret;
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index f7c1f96..3abb78d 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -425,7 +425,7 @@ static struct platform_device *cm_bf537_devices[] __initdata = {
 
 static int __init cm_bf537_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf537_devices, ARRAY_SIZE(cm_bf537_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c b/arch/blackfin/mach-bf537/boards/generic_board.c
index c95395b..b3d78ea 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -90,7 +90,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
@@ -690,7 +690,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff --git a/arch/blackfin/mach-bf537/boards/minotaur.c b/arch/blackfin/mach-bf537/boards/minotaur.c
index d71e0be..815ad40 100644
--- a/arch/blackfin/mach-bf537/boards/minotaur.c
+++ b/arch/blackfin/mach-bf537/boards/minotaur.c
@@ -297,7 +297,7 @@ static struct platform_device *minotaur_devices[] __initdata = {
 
 static int __init minotaur_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(minotaur_devices, ARRAY_SIZE(minotaur_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 509a8a2..0b3e22b 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -497,7 +497,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index ea83148..0a87eb4 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -90,7 +90,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
@@ -823,7 +823,7 @@ static struct platform_device *stamp_devices[] __initdata = {
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index a0950c1..e3cf090 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -666,7 +666,7 @@ static struct platform_device *ezkit_devices[] __initdata = {
 
 static int __init ezkit_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index bf9e738..4a3e085 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -349,7 +349,7 @@ static struct platform_device *cm_bf561_devices[] __initdata = {
 
 static int __init cm_bf561_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf561_devices, ARRAY_SIZE(cm_bf561_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index d357f64..17fe6b2 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -78,7 +78,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
diff --git a/arch/blackfin/mach-bf561/boards/generic_board.c b/arch/blackfin/mach-bf561/boards/generic_board.c
index fc80c5d..2faa007 100644
--- a/arch/blackfin/mach-bf561/boards/generic_board.c
+++ b/arch/blackfin/mach-bf561/boards/generic_board.c
@@ -70,7 +70,7 @@ static struct platform_device *generic_board_devices[] __initdata = {
 
 static int __init generic_board_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	return platform_add_devices(generic_board_devices,
 				    ARRAY_SIZE(generic_board_devices));
 }
diff --git a/arch/blackfin/mach-bf561/boards/tepla.c b/arch/blackfin/mach-bf561/boards/tepla.c
index ec6a220..c9174b3 100644
--- a/arch/blackfin/mach-bf561/boards/tepla.c
+++ b/arch/blackfin/mach-bf561/boards/tepla.c
@@ -50,7 +50,7 @@ static struct platform_device *tepla_devices[] __initdata = {
 
 static int __init tepla_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	return platform_add_devices(tepla_devices, ARRAY_SIZE(tepla_devices));
 }
 
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 225ef14..a2a1171 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -316,7 +316,7 @@ static void bfin_demux_error_irq(unsigned int int_err_irq,
 		printk(KERN_ERR
 		       "%s : %s : LINE %d :\nIRQ ?: PERIPHERAL ERROR"
 		       " INTERRUPT ASSERTED BUT NO SOURCE FOUND\n",
-		       __FUNCTION__, __FILE__, __LINE__);
+		       __func__, __FILE__, __LINE__);
 
 }
 #endif				/* BF537_GENERIC_ERROR_INT_DEMUX */
diff --git a/arch/blackfin/oprofile/common.c b/arch/blackfin/oprofile/common.c
index cb8b8d5..0f6d303 100644
--- a/arch/blackfin/oprofile/common.c
+++ b/arch/blackfin/oprofile/common.c
@@ -75,7 +75,7 @@ static int op_bfin_start(void)
 {
 	int ret = -EBUSY;
 
-	printk(KERN_INFO "KSDBG:in %s\n", __FUNCTION__);
+	printk(KERN_INFO "KSDBG:in %s\n", __func__);
 	mutex_lock(&pfmon_lock);
 	if (!pfmon_enabled) {
 		ret = model->start(ctr);
diff --git a/arch/blackfin/oprofile/op_model_bf533.c b/arch/blackfin/oprofile/op_model_bf533.c
index 872dffe..d1c698b 100644
--- a/arch/blackfin/oprofile/op_model_bf533.c
+++ b/arch/blackfin/oprofile/op_model_bf533.c
@@ -125,7 +125,7 @@ int pm_overflow_handler(int irq, struct pt_regs *regs)
 	unsigned int pc, pfctl;
 	unsigned int count[2];
 
-	pr_debug("get interrupt in %s\n", __FUNCTION__);
+	pr_debug("get interrupt in %s\n", __func__);
 	if (oprofile_running == 0) {
 		pr_debug("error: entering interrupt when oprofile is stopped.\n\r");
 		return -1;
-- 
1.5.4.3.500.g83a2c



