Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXKKRCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXKKRCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 12:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXKKRB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 12:01:56 -0500
Received: from mail0.scram.de ([78.47.204.202]:41514 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbXKKRBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 12:01:55 -0500
X-Spam-Score: -3.878
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <47373571.3070605@scram.de>
Date: Sun, 11 Nov 2007 18:01:37 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
CC: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
       paulus@samba.org
Subject: [PATCH] powerpc: Add EXPORT_SYMBOL for symbols required by fs_enet
 and cpm_uart
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs_enet and cpm_uart need symbols from commproc.c (for CPM1) or
cpm2_common.c. Add EXPORT_SYMBOL for cpmp, cpm_setbrg and cpm2_immr, so
the drivers can be compiled as modules.

  Building modules, stage 2.
  MODPOST 5 modules
ERROR: "cpm2_immr" [drivers/net/fs_enet/fs_enet.ko] undefined!
ERROR: "cpmp" [drivers/net/fs_enet/fs_enet.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/sysdev/commproc.c    |    3 +++
 arch/powerpc/sysdev/cpm2_common.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/sysdev/commproc.c b/arch/powerpc/sysdev/commproc.c
index f6a6378..d5a0dcf 100644
--- a/arch/powerpc/sysdev/commproc.c
+++ b/arch/powerpc/sysdev/commproc.c
@@ -51,6 +51,8 @@ static void m8xx_cpm_dpinit(void);
 static uint host_buffer; /* One page of host buffer */
 static uint host_end;    /* end + 1 */
 cpm8xx_t __iomem *cpmp;  /* Pointer to comm processor space */
+EXPORT_SYMBOL(cpmp);
+
 immap_t __iomem *mpc8xx_immr;
 static cpic8xx_t __iomem *cpic_reg;
 
@@ -302,6 +304,7 @@ cpm_setbrg(uint brg, uint rate)
 		out_be32(bp, (((BRG_UART_CLK_DIV16 / rate) - 1) << 1) |
 		             CPM_BRG_EN | CPM_BRG_DIV16);
 }
+EXPORT_SYMBOL(cpm_setbrg);
 
 #ifndef CONFIG_PPC_CPM_NEW_BINDING
 /*
diff --git a/arch/powerpc/sysdev/cpm2_common.c b/arch/powerpc/sysdev/cpm2_common.c
index 859362f..4ed5df6 100644
--- a/arch/powerpc/sysdev/cpm2_common.c
+++ b/arch/powerpc/sysdev/cpm2_common.c
@@ -51,11 +51,13 @@ static void cpm2_dpinit(void);
 #endif
 
 cpm_cpm2_t __iomem *cpmp; /* Pointer to comm processor space */
+EXPORT_SYMBOL(cpmp);
 
 /* We allocate this here because it is used almost exclusively for
  * the communication processor devices.
  */
 cpm2_map_t __iomem *cpm2_immr;
+EXPORT_SYMBOL(cpm2_immr);
 
 #define CPM_MAP_SIZE	(0x40000)	/* 256k - the PQ3 reserve this amount
 					   of space for CPM as it is larger
@@ -117,6 +119,7 @@ cpm_setbrg(uint brg, uint rate)
 
 	cpm2_unmap(bp);
 }
+EXPORT_SYMBOL(cpm_setbrg);
 
 /* This function is used to set high speed synchronous baud rate
  * clocks.
-- 
1.5.3.5


