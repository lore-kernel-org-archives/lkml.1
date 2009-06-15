Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbZFOQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbZFOQ0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZFOQ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:26:11 -0400
Received: from mga06.intel.com ([134.134.136.21]:24305 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754303AbZFOQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:26:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,223,1243839600"; 
   d="scan'208";a="422000079"
Date: Mon, 15 Jun 2009 18:28:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mike Rapoport <mike@compulab.co.il>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Balaji Rao <balajirrao@openmoko.org>, Eric Miao <eric.miao@marvell.com>
Subject: [PATCH] mfd: early init for MFD running regulators
Message-ID: <20090615162813.GE4094@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Samuel Ortiz <sameo@linux.intel.com>

For MFDs running regulator cores, we really want them to be brought up early
during boot.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/da903x.c        |    2 +-
 drivers/mfd/pcf50633-core.c |    2 +-
 drivers/mfd/wm8400-core.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 7283d88..e5ffe56 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -561,7 +561,7 @@ static int __init da903x_init(void)
 {
 	return i2c_add_driver(&da903x_driver);
 }
-module_init(da903x_init);
+subsys_initcall(da903x_init);
 
 static void __exit da903x_exit(void)
 {
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 082c197..8d3c38b 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -705,5 +705,5 @@ MODULE_DESCRIPTION("I2C chip driver for NXP PCF50633 PMU");
 MODULE_AUTHOR("Harald Welte <laforge@openmoko.org>");
 MODULE_LICENSE("GPL");
 
-module_init(pcf50633_init);
+subsys_initcall(pcf50633_init);
 module_exit(pcf50633_exit);
diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 7c21bf7..ecfc8bb 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -460,7 +460,7 @@ static int __init wm8400_module_init(void)
 
 	return ret;
 }
-module_init(wm8400_module_init);
+subsys_initcall(wm8400_module_init);
 
 static void __exit wm8400_module_exit(void)
 {
-- 
1.6.3.1

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
