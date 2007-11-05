Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbXKEQnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbXKEQnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 11:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXKEQnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 11:43:40 -0500
Received: from nic2.axis.se ([193.13.178.10]:51001 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbXKEQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 11:43:39 -0500
Date: Mon, 5 Nov 2007 17:42:17 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS: Remove MTD_AMSTD and MTD_OBSOLETE_CHIPS take two
Message-ID: <20071105164216.GQ7621@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove MTD_AMDSTD and MTD_OBSOLETE_CHIPS from defconfig, Kconfig and code,
instead we'll use MTD_CFI or MTD_JEDECPROBE.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 arch-v10/defconfig              |    2 --
 arch-v10/drivers/Kconfig        |    2 --
 arch-v10/drivers/axisflashmap.c |    8 ++++----
 arch-v32/drivers/Kconfig        |    2 --
 arch-v32/drivers/axisflashmap.c |    8 ++++----
 defconfig                       |    2 --
 6 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/cris/arch-v10/defconfig b/arch/cris/arch-v10/defconfig
index 710c20b..572f119 100644
--- a/arch/cris/arch-v10/defconfig
+++ b/arch/cris/arch-v10/defconfig
@@ -99,7 +99,6 @@ CONFIG_MTD=y
 CONFIG_MTD_CFI=y
 # CONFIG_MTD_CFI_INTELEXT is not set
 CONFIG_MTD_CFI_AMDSTD=y
-CONFIG_MTD_AMDSTD=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_ETRAX_I2C=y
@@ -145,7 +144,6 @@ CONFIG_MTD_CFI=y
 # CONFIG_MTD_CFI_GEOMETRY is not set
 # CONFIG_MTD_CFI_INTELEXT is not set
 CONFIG_MTD_CFI_AMDSTD=y
-CONFIG_MTD_AMDSTD=y
 # CONFIG_MTD_SHARP is not set
 # CONFIG_MTD_PHYSMAP is not set
 # CONFIG_MTD_NORA is not set
diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
index 03e2e68..136a0c6 100644
--- a/arch/cris/arch-v10/drivers/Kconfig
+++ b/arch/cris/arch-v10/drivers/Kconfig
@@ -605,8 +605,6 @@ config ETRAX_AXISFLASHMAP
 	select MTD
 	select MTD_CFI
 	select MTD_CFI_AMDSTD
-	select MTD_OBSOLETE_CHIPS
-	select MTD_AMDSTD
 	select MTD_CHAR
 	select MTD_BLOCK
 	select MTD_PARTITIONS
diff --git a/arch/cris/arch-v10/drivers/axisflashmap.c b/arch/cris/arch-v10/drivers/axisflashmap.c
index efd7b0f..ea3cf2e 100644
--- a/arch/cris/arch-v10/drivers/axisflashmap.c
+++ b/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -312,12 +312,12 @@ static struct mtd_info *probe_cs(struct map_info *map_cs)
                "%s: Probing a 0x%08lx bytes large window at 0x%08lx.\n",
 	       map_cs->name, map_cs->size, map_cs->map_priv_1);
 
-#ifdef CONFIG_MTD_AMDSTD
-	mtd_cs = do_map_probe("amd_flash", map_cs);
-#endif
 #ifdef CONFIG_MTD_CFI
+	mtd_cs = do_map_probe("cfi_probe", map_cs);
+#endif
+#ifdef CONFIG_MTD_JEDECPROBE
 	if (!mtd_cs) {
-		mtd_cs = do_map_probe("cfi_probe", map_cs);
+		mtd_cs = do_map_probe("jedec_probe", map_cs);
 	}
 #endif
 
diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index cc6ba54..7f72d7c 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -362,8 +362,6 @@ config ETRAX_AXISFLASHMAP
 	select MTD
 	select MTD_CFI
 	select MTD_CFI_AMDSTD
-	select MTD_OBSOLETE_CHIPS
-	select MTD_AMDSTD
 	select MTD_CHAR
 	select MTD_BLOCK
 	select MTD_PARTITIONS
diff --git a/arch/cris/arch-v32/drivers/axisflashmap.c b/arch/cris/arch-v32/drivers/axisflashmap.c
index 3ec12ea..7904d98 100644
--- a/arch/cris/arch-v32/drivers/axisflashmap.c
+++ b/arch/cris/arch-v32/drivers/axisflashmap.c
@@ -190,12 +190,12 @@ static struct mtd_info *probe_cs(struct map_info *map_cs)
 	       "%s: Probing a 0x%08lx bytes large window at 0x%08lx.\n",
 	       map_cs->name, map_cs->size, map_cs->map_priv_1);
 
-#ifdef CONFIG_MTD_AMDSTD
-	mtd_cs = do_map_probe("amd_flash", map_cs);
-#endif
 #ifdef CONFIG_MTD_CFI
-	if (!mtd_cs) {
 		mtd_cs = do_map_probe("cfi_probe", map_cs);
+#endif
+#ifdef CONFIG_MTD_JEDECPROBE
+	if (!mtd_cs) {
+		mtd_cs = do_map_probe("jedec_probe", map_cs);
 	}
 #endif
 
diff --git a/arch/cris/defconfig b/arch/cris/defconfig
index 142a108..e3e91f6 100644
--- a/arch/cris/defconfig
+++ b/arch/cris/defconfig
@@ -226,8 +226,6 @@ CONFIG_MTD_CFI_UTIL=y
 CONFIG_MTD_RAM=y
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-CONFIG_MTD_OBSOLETE_CHIPS=y
-CONFIG_MTD_AMDSTD=y
 # CONFIG_MTD_SHARP is not set
 # CONFIG_MTD_JEDEC is not set
 
/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
