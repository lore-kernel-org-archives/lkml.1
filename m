Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbXEYIA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbXEYIA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbXEYIAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:00:53 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:51707 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751156AbXEYIAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:00:52 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: kernel-janitors@lists.osdl.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] potential parse error in ifdef 
Date: Fri, 25 May 2007 09:56:43 +0200
Message-ID: <87abvtfi9w.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

I have made a tool to parse the kernel that does not pre-process the
source. That means that my parser tries to parse all the code, including
code in the #else branch or code that is not often compiled because
the driver is not very used (or not used at all). So, my parser
sometimes reports parse error not originally detected by gcc. 
Here is my (first) patch.

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 
Acked-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/char/watchdog/ixp2000_wdt.c |    2 +-
 drivers/mtd/devices/pmc551.c        |    2 +-
 drivers/mtd/nand/autcpu12.c         |    2 +-
 drivers/mtd/nand/ppchameleonevb.c   |    2 +-
 drivers/net/amd8111e.c              |    2 +-
 drivers/net/skfp/smt.c              |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 sound/arm/sa11xx-uda1341.c          |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/drivers/char/watchdog/ixp2000_wdt.c b/drivers/char/watchdog/ixp2000_wdt.c
index fd955db..dc7548d 100644
--- a/drivers/char/watchdog/ixp2000_wdt.c
+++ b/drivers/char/watchdog/ixp2000_wdt.c
@@ -205,7 +205,7 @@ static void __exit ixp2000_wdt_exit(void
 module_init(ixp2000_wdt_init);
 module_exit(ixp2000_wdt_exit);
 
-MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net">);
+MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
 MODULE_DESCRIPTION("IXP2000 Network Processor Watchdog");
 
 module_param(heartbeat, int, 0);
diff --git a/drivers/mtd/devices/pmc551.c b/drivers/mtd/devices/pmc551.c
index a4873ab..e8f686f 100644
--- a/drivers/mtd/devices/pmc551.c
+++ b/drivers/mtd/devices/pmc551.c
@@ -650,7 +650,7 @@ MODULE_DESCRIPTION(PMC551_VERSION);
  */
 static int msize = 0;
 #if defined(CONFIG_MTD_PMC551_APERTURE_SIZE)
-static int asize = CONFIG_MTD_PMC551_APERTURE_SIZE
+static int asize = CONFIG_MTD_PMC551_APERTURE_SIZE;
 #else
 static int asize = 0;
 #endif
diff --git a/drivers/mtd/nand/autcpu12.c b/drivers/mtd/nand/autcpu12.c
index fe94ae9..e3744eb 100644
--- a/drivers/mtd/nand/autcpu12.c
+++ b/drivers/mtd/nand/autcpu12.c
@@ -101,7 +101,7 @@ static void autcpu12_hwcontrol(struct mt
 	struct nand_chip *chip = mtd->priv;
 
 	if (ctrl & NAND_CTRL_CHANGE) {
-		void __iomem *addr
+		void __iomem *addr;
 		unsigned char bits;
 
 		addr = CS89712_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
diff --git a/drivers/mtd/nand/ppchameleonevb.c b/drivers/mtd/nand/ppchameleonevb.c
index eb7d4d4..38fe9e9 100644
--- a/drivers/mtd/nand/ppchameleonevb.c
+++ b/drivers/mtd/nand/ppchameleonevb.c
@@ -81,7 +81,7 @@ #ifdef CONFIG_MTD_PARTITIONS
  */
 static struct mtd_partition partition_info_hi[] = {
       { .name = "PPChameleon HI Nand Flash",
-	offset = 0,
+	.offset = 0,
 	.size = 128 * 1024 * 1024
       }
 };
diff --git a/drivers/net/amd8111e.c b/drivers/net/amd8111e.c
index 675fe91..84b8164 100644
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -155,7 +155,7 @@ This function will write into PHY regist
 */
 static int amd8111e_write_phy(struct amd8111e_priv* lp,int phy_id, int reg, u32 val)
 {
-	unsigned int repeat = REPEAT_CNT
+	unsigned int repeat = REPEAT_CNT;
 	void __iomem *mmio = lp->mmio;
 	unsigned int reg_val;
 
diff --git a/drivers/net/skfp/smt.c b/drivers/net/skfp/smt.c
index fe84780..75afc1f 100644
--- a/drivers/net/skfp/smt.c
+++ b/drivers/net/skfp/smt.c
@@ -1748,7 +1748,7 @@ char *addr_to_string(struct fddi_addr *a
 #endif
 
 #ifdef	AM29K
-smt_ifconfig(int argc, char *argv[])
+int smt_ifconfig(int argc, char *argv[])
 {
 	if (argc >= 2 && !strcmp(argv[0],"opt_bypass") &&
 	    !strcmp(argv[1],"yes")) {
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 9ddc6e4..05f692b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -5180,7 +5180,7 @@ #ifdef AHD_TARGET_MODE
 			cur_lun = lun;
 			max_lun = lun;
 		}
-		for (cur_lun <= max_lun; cur_lun++) {
+		for (;cur_lun <= max_lun; cur_lun++) {
 			struct ahd_tmode_lstate* lstate;
 
 			lstate = tstate->enabled_luns[cur_lun];
diff --git a/sound/arm/sa11xx-uda1341.c b/sound/arm/sa11xx-uda1341.c
index c7e1b26..e7ed868 100644
--- a/sound/arm/sa11xx-uda1341.c
+++ b/sound/arm/sa11xx-uda1341.c
@@ -987,7 +987,7 @@ static int __init sa11xx_uda1341_init(vo
 		if (platform_get_drvdata(device))
 			return 0;
 		platform_device_unregister(device);
-		err = -ENODEV
+		err = -ENODEV;
 	} else
 		err = PTR_ERR(device);
 	platform_driver_unregister(&sa11xx_uda1341_driver);




