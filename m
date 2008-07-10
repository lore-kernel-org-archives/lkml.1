Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYGJVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYGJVPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYGJVOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:14:53 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3530 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbYGJVOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:14:52 -0400
Date: Thu, 10 Jul 2008 16:14:18 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <for-27-patch1-0@bga.com>
Message-Id: <for-27-patch1-00@bga.com>
Subject: mtd: remove __PPC__ hardcoded address from nand/diskonchip and devices/docprobe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Such a hardcoded address can cause a checkstop or machine check if
the driver is in the kernel but the address is not acknowledged.

Both drivers allow an address to be specified as either a module
parameter or config option.   Any future powerpc board should either
use one of these methods or find the address in the device tree.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
There is no powerpc defconfig that sets either CONFIG_DOC200{0,1*} nor
CONFIG_MTD_NAND_DISKONCHIP in next-20080710.

diff --git a/drivers/mtd/devices/docprobe.c b/drivers/mtd/devices/docprobe.c
index 6e5d811..6e62922 100644
--- a/drivers/mtd/devices/docprobe.c
+++ b/drivers/mtd/devices/docprobe.c
@@ -76,8 +76,6 @@ static unsigned long __initdata doc_locations[] = {
 	0xe0000, 0xe2000, 0xe4000, 0xe6000,
 	0xe8000, 0xea000, 0xec000, 0xee000,
 #endif /*  CONFIG_MTD_DOCPROBE_HIGH */
-#elif defined(__PPC__)
-	0xe4000000,
 #else
 #warning Unknown architecture for DiskOnChip. No default probe locations defined
 #endif
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index cd4393c..765d4f0 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -52,8 +52,6 @@ static unsigned long __initdata doc_locations[] = {
 	0xe0000, 0xe2000, 0xe4000, 0xe6000,
 	0xe8000, 0xea000, 0xec000, 0xee000,
 #endif /*  CONFIG_MTD_DOCPROBE_HIGH */
-#elif defined(__PPC__)
-	0xe4000000,
 #else
 #warning Unknown architecture for DiskOnChip. No default probe locations defined
 #endif
