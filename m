Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYEVE1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYEVE1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYEVE05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:26:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:36422 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbYEVE04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:26:56 -0400
Date: Wed, 21 May 2008 23:26:08 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: dougthompson@xmission.com
cc: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@osdl.org>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] edac: mpc85xx - Fix building as a module
Message-ID: <Pine.LNX.4.64.0805212326000.32442@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

including of <asm/mpc85xx.h> causes build problems since it doesn't exist.

Also removed warning:
drivers/edac/mpc85xx_edac.c:45: warning: 'mpc85xx_ctl_name' defined but not used

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

This is a fix for 2.6.26.

- k

 drivers/edac/mpc85xx_edac.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 065732d..d49361b 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -20,7 +20,6 @@

 #include <linux/of_platform.h>
 #include <linux/of_device.h>
-#include <asm/mpc85xx.h>
 #include "edac_module.h"
 #include "edac_core.h"
 #include "mpc85xx_edac.h"
@@ -43,8 +42,6 @@ static u32 orig_pci_err_en;
 static u32 orig_l2_err_disable;
 static u32 orig_hid1;

-static const char *mpc85xx_ctl_name = "MPC85xx";
-
 /************************ MC SYSFS parts ***********************************/

 static ssize_t mpc85xx_mc_inject_data_hi_show(struct mem_ctl_info *mci,
-- 
1.5.4.5

