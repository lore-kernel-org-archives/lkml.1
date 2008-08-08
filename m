Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbYHHV6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbYHHV6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760410AbYHHVyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbYHHVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F4bj0AxU6xQj/G0F+1MyPa6DMxtlGlXzDV87SXmbTXvgM6ZPCi4kSCQbHS0ECcXKO3
         vWT6D9B4lZ1niJKpP7M7YCMXtbcgMr+isu7WY+MvmX08Kns7+qEnzWBH6HY49DuuPM3S
         mo2Gqy7Byjis1ptJ09SCKDEJmoE2EFXcZvsFI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 11/42] drivers/net to use nr_irqs
Date: Fri,  8 Aug 2008 14:52:17 -0700
Message-Id: <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/net/3c59x.c                   |    4 ++--
 drivers/net/hamradio/baycom_ser_fdx.c |    4 ++--
 drivers/net/hamradio/scc.c            |    6 +++---
 drivers/net/wan/sbni.c                |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 8db4e6b..7449a1c 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -90,7 +90,7 @@ static int vortex_debug = 1;
 #include <linux/eisa.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
-#include <asm/irq.h>			/* For NR_IRQS only. */
+#include <asm/irq.h>			/* For nr_irqs only. */
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
@@ -1221,7 +1221,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 	if (print_info)
 		printk(", IRQ %d\n", dev->irq);
 	/* Tell them about an invalid IRQ. */
-	if (dev->irq <= 0 || dev->irq >= NR_IRQS)
+	if (dev->irq <= 0 || dev->irq >= nr_irqs)
 		printk(KERN_WARNING " *** Warning: IRQ %d is unlikely to work! ***\n",
 			   dev->irq);
 
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index 17ac697..b6a816e 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -416,10 +416,10 @@ static int ser12_open(struct net_device *dev)
 	if (!dev || !bc)
 		return -ENXIO;
 	if (!dev->base_addr || dev->base_addr > 0xffff-SER12_EXTENT ||
-	    dev->irq < 2 || dev->irq > NR_IRQS) {
+	    dev->irq < 2 || dev->irq > nr_irqs) {
 		printk(KERN_INFO "baycom_ser_fdx: invalid portnumber (max %u) "
 				"or irq (2 <= irq <= %d)\n",
-				0xffff-SER12_EXTENT, NR_IRQS);
+				0xffff-SER12_EXTENT, nr_irqs);
 		return -ENXIO;
 	}
 	if (bc->baud < 300 || bc->baud > 4800) {
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 45ae9d1..c17e39b 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -1465,7 +1465,7 @@ static void z8530_init(void)
 	printk(KERN_INFO "Init Z8530 driver: %u channels, IRQ", Nchips*2);
 	
 	flag=" ";
-	for (k = 0; k < NR_IRQS; k++)
+	for (k = 0; k < nr_irqs; k++)
 		if (Ivec[k].used) 
 		{
 			printk("%s%d", flag, k);
@@ -1728,7 +1728,7 @@ static int scc_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 			if (hwcfg.irq == 2) hwcfg.irq = 9;
 
-			if (hwcfg.irq < 0 || hwcfg.irq >= NR_IRQS)
+			if (hwcfg.irq < 0 || hwcfg.irq >= nr_irqs)
 				return -EINVAL;
 				
 			if (!Ivec[hwcfg.irq].used && hwcfg.irq)
@@ -2148,7 +2148,7 @@ static void __exit scc_cleanup_driver(void)
 		}
 		
 	/* To unload the port must be closed so no real IRQ pending */
-	for (k=0; k < NR_IRQS ; k++)
+	for (k = 0; k < nr_irqs ; k++)
 		if (Ivec[k].used) free_irq(k, NULL);
 		
 	local_irq_enable();
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index e59255a..8bd13b8 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -318,7 +318,7 @@ sbni_pci_probe( struct net_device  *dev )
 				continue;
 		}
 
-		if( pci_irq_line <= 0  ||  pci_irq_line >= NR_IRQS )
+		if (pci_irq_line <= 0 || pci_irq_line >= nr_irqs)
 			printk( KERN_WARNING "  WARNING: The PCI BIOS assigned "
 				"this PCI card to IRQ %d, which is unlikely "
 				"to work!.\n"
-- 
1.5.4.5

