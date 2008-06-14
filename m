Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYFNTL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYFNTL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 15:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYFNTLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 15:11:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:52293 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYFNTLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 15:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=pTh8KcRJ6lEt9xYSgP0whx2VgFiyZE0tW2TrUKuBKff/5hGd+6vBVZp5sw1S0WsDd3
         HVgXNOIoaAl0cSDK3odtpu94MYJZ6jW3t9H5acB+QkaADyk8GXxG27fhun3Q9+48r7JH
         e0yM724Z0RRuwPA+cGz+tYwf3aGG4qRoeDnA0=
Date: Sat, 14 Jun 2008 21:11:39 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: coding style fixes to
 x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
Message-ID: <20080614211139.730e76ac@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:
total: 22 errors, 8 warnings, 440 lines checked

After:
total: 0 errors, 8 warnings, 442 lines checked

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/cpufreq-nforce2.o.*
3d4330a5d188fe904446e5948a618b48  /tmp/cpufreq-nforce2.o.after
1477e6b0dcd6f59b1fb6b4490042eca6  /tmp/cpufreq-nforce2.o.before
^^^ I guess this is because I fixed a few "do not initialise statics to 0 or NULL"

paolo@paolo-desktop:~/linux.trees.git$ size /tmp/cpufreq-nforce2.o.*
   text    data     bss     dec     hex filename
   1923      72      16    2011     7db /tmp/cpufreq-nforce2.o.after
   1923      72      16    2011     7db /tmp/cpufreq-nforce2.o.before


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c |   44 +++++++++++++------------
 1 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index f03e915..965ea52 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -26,9 +26,10 @@
 #define NFORCE2_SAFE_DISTANCE 50
 
 /* Delay in ms between FSB changes */
-//#define NFORCE2_DELAY 10
+/* #define NFORCE2_DELAY 10 */
 
-/* nforce2_chipset:
+/*
+ * nforce2_chipset:
  * FSB is changed using the chipset
  */
 static struct pci_dev *nforce2_chipset_dev;
@@ -36,13 +37,13 @@ static struct pci_dev *nforce2_chipset_dev;
 /* fid:
  * multiplier * 10
  */
-static int fid = 0;
+static int fid;
 
 /* min_fsb, max_fsb:
  * minimum and maximum FSB (= FSB at boot time)
  */
-static int min_fsb = 0;
-static int max_fsb = 0;
+static int min_fsb;
+static int max_fsb;
 
 MODULE_AUTHOR("Sebastian Witt <se.witt@gmx.net>");
 MODULE_DESCRIPTION("nForce2 FSB changing cpufreq driver");
@@ -53,7 +54,7 @@ module_param(min_fsb, int, 0444);
 
 MODULE_PARM_DESC(fid, "CPU multiplier to use (11.5 = 115)");
 MODULE_PARM_DESC(min_fsb,
-                 "Minimum FSB to use, if not defined: current FSB - 50");
+		"Minimum FSB to use, if not defined: current FSB - 50");
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "cpufreq-nforce2", msg)
 
@@ -139,7 +140,7 @@ static unsigned int nforce2_fsb_read(int bootfsb)
 
 	/* Get chipset boot FSB from subdevice 5 (FSB at boot-time) */
 	nforce2_sub5 = pci_get_subsys(PCI_VENDOR_ID_NVIDIA,
-						0x01EF,PCI_ANY_ID,PCI_ANY_ID,NULL);
+						0x01EF, PCI_ANY_ID, PCI_ANY_ID, NULL);
 	if (!nforce2_sub5)
 		return 0;
 
@@ -147,13 +148,13 @@ static unsigned int nforce2_fsb_read(int bootfsb)
 	fsb /= 1000000;
 
 	/* Check if PLL register is already set */
-	pci_read_config_byte(nforce2_chipset_dev,NFORCE2_PLLENABLE, (u8 *)&temp);
+	pci_read_config_byte(nforce2_chipset_dev, NFORCE2_PLLENABLE, (u8 *)&temp);
 
-	if(bootfsb || !temp)
+	if (bootfsb || !temp)
 		return fsb;
-		
+
 	/* Use PLL register FSB value */
-	pci_read_config_dword(nforce2_chipset_dev,NFORCE2_PLLREG, &temp);
+	pci_read_config_dword(nforce2_chipset_dev, NFORCE2_PLLREG, &temp);
 	fsb = nforce2_calc_fsb(temp);
 
 	return fsb;
@@ -184,7 +185,7 @@ static int nforce2_set_fsb(unsigned int fsb)
 	}
 
 	/* First write? Then set actual value */
-	pci_read_config_byte(nforce2_chipset_dev,NFORCE2_PLLENABLE, (u8 *)&temp);
+	pci_read_config_byte(nforce2_chipset_dev, NFORCE2_PLLENABLE, (u8 *)&temp);
 	if (!temp) {
 		pll = nforce2_calc_pll(tfsb);
 
@@ -210,7 +211,8 @@ static int nforce2_set_fsb(unsigned int fsb)
 			tfsb--;
 
 		/* Calculate the PLL reg. value */
-		if ((pll = nforce2_calc_pll(tfsb)) == -1)
+		pll = nforce2_calc_pll(tfsb);
+		if (pll == -1)
 			return -EINVAL;
 
 		nforce2_write_pll(pll);
@@ -249,7 +251,7 @@ static unsigned int nforce2_get(unsigned int cpu)
 static int nforce2_target(struct cpufreq_policy *policy,
 			  unsigned int target_freq, unsigned int relation)
 {
-//        unsigned long         flags;
+/*        unsigned long         flags; */
 	struct cpufreq_freqs freqs;
 	unsigned int target_fsb;
 
@@ -271,17 +273,17 @@ static int nforce2_target(struct cpufreq_policy *policy,
 	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 
 	/* Disable IRQs */
-	//local_irq_save(flags);
+	/* local_irq_save(flags); */
 
 	if (nforce2_set_fsb(target_fsb) < 0)
 		printk(KERN_ERR "cpufreq: Changing FSB to %d failed\n",
-                       target_fsb);
+			target_fsb);
 	else
 		dprintk("Changed FSB successfully to %d\n",
-                       target_fsb);
+			target_fsb);
 
 	/* Enable IRQs */
-	//local_irq_restore(flags);
+	/* local_irq_restore(flags); */
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
@@ -302,8 +304,8 @@ static int nforce2_verify(struct cpufreq_policy *policy)
 		policy->max = (fsb_pol_max + 1) * fid * 100;
 
 	cpufreq_verify_within_limits(policy,
-                                     policy->cpuinfo.min_freq,
-                                     policy->cpuinfo.max_freq);
+				     policy->cpuinfo.min_freq,
+				     policy->cpuinfo.max_freq);
 	return 0;
 }
 
@@ -347,7 +349,7 @@ static int nforce2_cpu_init(struct cpufreq_policy *policy)
 	/* Set maximum FSB to FSB at boot time */
 	max_fsb = nforce2_fsb_read(1);
 
-	if(!max_fsb)
+	if (!max_fsb)
 		return -EIO;
 
 	if (!min_fsb)
-- 
1.5.6.rc1.21.g03300

