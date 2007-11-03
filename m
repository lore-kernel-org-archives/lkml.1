Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbXKCUqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbXKCUqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 16:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbXKCUpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 16:45:52 -0400
Received: from mail0.scram.de ([78.47.204.202]:52128 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbXKCUpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 16:45:51 -0400
X-Spam-Score: -3.868
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <472CDE02.1020804@scram.de>
Date: Sat, 03 Nov 2007 21:45:54 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
CC: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH] [POWERPC] Fix fs_enet module build
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If fs_enet is build as module, mii-fec/mii-bitbang should be build as
module, as well. Otherwise some symbols remain undefined.

  Building modules, stage 2.
  MODPOST 5 modules
ERROR: "fs_scc_ops" [drivers/net/fs_enet/fs_enet.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---

This can be pulled from git://git.bocc.de/dbox2.git for-2.6.24

 drivers/net/fs_enet/Makefile |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/fs_enet/Makefile b/drivers/net/fs_enet/Makefile
index 02d4dc1..2f7563a 100644
--- a/drivers/net/fs_enet/Makefile
+++ b/drivers/net/fs_enet/Makefile
@@ -4,7 +4,15 @@
 
 obj-$(CONFIG_FS_ENET) += fs_enet.o
 
-obj-$(CONFIG_8xx) += mac-fec.o mac-scc.o mii-fec.o
-obj-$(CONFIG_CPM2) += mac-fcc.o mii-bitbang.o
+fs_enet-$(CONFIG_8xx) += mac-fec.o mac-scc.o
+fs_enet-$(CONFIG_CPM2) += mac-fcc.o
+
+ifeq ($(CONFIG_8xx),y)
+        obj-$(CONFIG_FS_ENET) += mii-fec.o
+endif
+
+ifeq ($(CONFIG_CPM2),y)
+        obj-$(CONFIG_FS_ENET) += mii-bitbang.o
+endif
 
 fs_enet-objs := fs_enet-main.o
-- 
1.5.3.4

