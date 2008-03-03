Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYCCSc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYCCSc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbYCCScr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:32:47 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:62847 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbYCCSco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:32:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Kcn+1qHesq1A/tHeBuEIkP3rDRje5i5nWiB7Q+Y+a/t95jq15qNEPnRZI/GDIU3xw8RayarPQOpJJ4H5/qyMXlyGO639prKN9f9J3pnf/rr9QuveJ/I50w4QObzl1Zd3/AzgKVCiSIxeFJTO9ss+U0VHFm2UHf3FaYMKyKSKZoo=
Subject: [PATCH] mips: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 10:32:40 -0800
Message-Id: <1204569160.3266.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mips/au1000/common/power.c                    |    2 +-
 arch/mips/kernel/signal-common.h                   |    2 +-
 arch/mips/pci/ops-pnx8550.c                        |    4 ++--
 arch/mips/sgi-ip32/ip32-reset.c                    |    2 +-
 .../tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c |    2 +-
 .../toshiba_rbtx4927/toshiba_rbtx4927_setup.c      |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/au1000/common/power.c b/arch/mips/au1000/common/power.c
index 54047d6..ca4b3de 100644
--- a/arch/mips/au1000/common/power.c
+++ b/arch/mips/au1000/common/power.c
@@ -47,7 +47,7 @@
 
 #define DEBUG 1
 #ifdef DEBUG
-#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __FUNCTION__ , ## args)
+#  define DPRINTK(fmt, args...)	printk("%s: " fmt, __func__, ## args)
 #else
 #  define DPRINTK(fmt, args...)
 #endif
diff --git a/arch/mips/kernel/signal-common.h b/arch/mips/kernel/signal-common.h
index c0faabd..6c8e8c4 100644
--- a/arch/mips/kernel/signal-common.h
+++ b/arch/mips/kernel/signal-common.h
@@ -14,7 +14,7 @@
 /* #define DEBUG_SIG */
 
 #ifdef DEBUG_SIG
-#  define DEBUGP(fmt, args...) printk("%s: " fmt, __FUNCTION__ , ##args)
+#  define DEBUGP(fmt, args...) printk("%s: " fmt, __func__, ##args)
 #else
 #  define DEBUGP(fmt, args...)
 #endif
diff --git a/arch/mips/pci/ops-pnx8550.c b/arch/mips/pci/ops-pnx8550.c
index d610646..0e160d9 100644
--- a/arch/mips/pci/ops-pnx8550.c
+++ b/arch/mips/pci/ops-pnx8550.c
@@ -90,14 +90,14 @@ config_access(unsigned int pci_cmd, struct pci_bus *bus, unsigned int devfn, int
 
 		loops--;
 		if (loops == 0) {
-			printk("%s : Arbiter Locked.\n", __FUNCTION__);
+			printk("%s : Arbiter Locked.\n", __func__);
 		}
 	}
 
 	clear_status();
 	if ((pci_cmd == PCI_CMD_IOR) || (pci_cmd == PCI_CMD_IOW)) {
 		printk("%s timeout (GPPM_CTRL=%X) ioaddr %lX pci_cmd %X\n",
-		       __FUNCTION__, inl(PCI_BASE | PCI_GPPM_CTRL), ioaddr,
+		       __func__, inl(PCI_BASE | PCI_GPPM_CTRL), ioaddr,
 		       pci_cmd);
 	}
 
diff --git a/arch/mips/sgi-ip32/ip32-reset.c b/arch/mips/sgi-ip32/ip32-reset.c
index 624bbdb..b6cab08 100644
--- a/arch/mips/sgi-ip32/ip32-reset.c
+++ b/arch/mips/sgi-ip32/ip32-reset.c
@@ -142,7 +142,7 @@ static irqreturn_t ip32_rtc_int(int irq, void *dev_id)
 	reg_c = CMOS_READ(RTC_INTR_FLAGS);
 	if (!(reg_c & RTC_IRQF)) {
 		printk(KERN_WARNING
-			"%s: RTC IRQ without RTC_IRQF\n", __FUNCTION__);
+			"%s: RTC IRQ without RTC_IRQF\n", __func__);
 	}
 	/* Wait until interrupt goes away */
 	disable_irq(MACEISA_RTC_IRQ);
diff --git a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c b/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c
index 3f808b6..6d31f2a 100644
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c
+++ b/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c
@@ -173,7 +173,7 @@ static const u32 toshiba_rbtx4927_irq_debug_flag =
         { \
            char tmp[100]; \
            sprintf( tmp, str ); \
-           printk( "%s(%s:%u)::%s", __FUNCTION__, __FILE__, __LINE__, tmp ); \
+           printk( "%s(%s:%u)::%s", __func__, __FILE__, __LINE__, tmp ); \
         }
 #else
 #define TOSHIBA_RBTX4927_IRQ_DPRINTK(flag, str...)
diff --git a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c b/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
index e466e5e..2203c77 100644
--- a/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
+++ b/arch/mips/tx4927/toshiba_rbtx4927/toshiba_rbtx4927_setup.c
@@ -93,7 +93,7 @@ static const u32 toshiba_rbtx4927_setup_debug_flag =
         { \
            char tmp[100]; \
            sprintf( tmp, str ); \
-           printk( "%s(%s:%u)::%s", __FUNCTION__, __FILE__, __LINE__, tmp ); \
+           printk( "%s(%s:%u)::%s", __func__, __FILE__, __LINE__, tmp ); \
         }
 #else
 #define TOSHIBA_RBTX4927_SETUP_DPRINTK(flag, str...)
-- 
1.5.4.3.500.g83a2c



