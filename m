Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZLDNY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZLDNY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZLDNY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:24:27 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:10907 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080AbZLDNYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:24:25 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIubGEtR9cKp/2dsb2JhbADWcQqEKQSBZ4Ez
Date: Fri, 4 Dec 2009 14:24:30 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben@simtec.co.uk>,
       Seth Heasley <seth.heasley@intel.com>
Subject: [WATCHDOG] v2.6.33-rc patches
Message-ID: <20091204132430.GD3772@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/iTCO_wdt.c    |   68 +++++++++++--------------------
 drivers/watchdog/s3c2410_wdt.c |   89 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 112 insertions(+), 45 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Nov 15 13:44:54 2009 +0000

    [WATCHDOG] iTCO_wdt.c - cleanup chipset documentation
    
    Cleanup the documentation about the supported chipsets.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Seth Heasley <seth.heasley@intel.com>
Date:   Wed Nov 11 02:24:01 2009 +0100

    [WATCHDOG] iTCO_wdt: Add support for Intel Ibex Peak
    
    Add the Intel Ibex Peak (PCH) Device IDs to iTCO_wdt.c.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben@simtec.co.uk>
Date:   Fri Oct 30 00:30:25 2009 +0000

    [WATCHDOG] CPUFREQ: S3C24XX Watchdog frequency scaling support.
    
    Add support for CPU frequency scaling to the S3C24XX Watchdog
    driver.
    
    Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
    Signed-off-by: Ben Dooks <ben@simtec.co.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 6a51edd..e44fbb3 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -1,5 +1,5 @@
 /*
- *	intel TCO Watchdog Driver (Used in i82801 and i63xxESB chipsets)
+ *	intel TCO Watchdog Driver
  *
  *	(c) Copyright 2006-2009 Wim Van Sebroeck <wim@iguana.be>.
  *
@@ -14,47 +14,22 @@
  *
  *	The TCO watchdog is implemented in the following I/O controller hubs:
  *	(See the intel documentation on http://developer.intel.com.)
- *	82801AA  (ICH)       : document number 290655-003, 290677-014,
- *	82801AB  (ICHO)      : document number 290655-003, 290677-014,
- *	82801BA  (ICH2)      : document number 290687-002, 298242-027,
- *	82801BAM (ICH2-M)    : document number 290687-002, 298242-027,
- *	82801CA  (ICH3-S)    : document number 290733-003, 290739-013,
- *	82801CAM (ICH3-M)    : document number 290716-001, 290718-007,
- *	82801DB  (ICH4)      : document number 290744-001, 290745-025,
- *	82801DBM (ICH4-M)    : document number 252337-001, 252663-008,
- *	82801E   (C-ICH)     : document number 273599-001, 273645-002,
- *	82801EB  (ICH5)      : document number 252516-001, 252517-028,
- *	82801ER  (ICH5R)     : document number 252516-001, 252517-028,
- *	6300ESB  (6300ESB)   : document number 300641-004, 300884-013,
- *	82801FB  (ICH6)      : document number 301473-002, 301474-026,
- *	82801FR  (ICH6R)     : document number 301473-002, 301474-026,
- *	82801FBM (ICH6-M)    : document number 301473-002, 301474-026,
- *	82801FW  (ICH6W)     : document number 301473-001, 301474-026,
- *	82801FRW (ICH6RW)    : document number 301473-001, 301474-026,
- *	631xESB  (631xESB)   : document number 313082-001, 313075-006,
- *	632xESB  (632xESB)   : document number 313082-001, 313075-006,
- *	82801GB  (ICH7)      : document number 307013-003, 307014-024,
- *	82801GR  (ICH7R)     : document number 307013-003, 307014-024,
- *	82801GDH (ICH7DH)    : document number 307013-003, 307014-024,
- *	82801GBM (ICH7-M)    : document number 307013-003, 307014-024,
- *	82801GHM (ICH7-M DH) : document number 307013-003, 307014-024,
- *	82801GU  (ICH7-U)    : document number 307013-003, 307014-024,
- *	82801HB  (ICH8)      : document number 313056-003, 313057-017,
- *	82801HR  (ICH8R)     : document number 313056-003, 313057-017,
- *	82801HBM (ICH8M)     : document number 313056-003, 313057-017,
- *	82801HH  (ICH8DH)    : document number 313056-003, 313057-017,
- *	82801HO  (ICH8DO)    : document number 313056-003, 313057-017,
- *	82801HEM (ICH8M-E)   : document number 313056-003, 313057-017,
- *	82801IB  (ICH9)      : document number 316972-004, 316973-012,
- *	82801IR  (ICH9R)     : document number 316972-004, 316973-012,
- *	82801IH  (ICH9DH)    : document number 316972-004, 316973-012,
- *	82801IO  (ICH9DO)    : document number 316972-004, 316973-012,
- *	82801IBM (ICH9M)     : document number 316972-004, 316973-012,
- *	82801IEM (ICH9M-E)   : document number 316972-004, 316973-012,
- *	82801JIB (ICH10)     : document number 319973-002, 319974-002,
- *	82801JIR (ICH10R)    : document number 319973-002, 319974-002,
- *	82801JD  (ICH10D)    : document number 319973-002, 319974-002,
- *	82801JDO (ICH10DO)   : document number 319973-002, 319974-002
+ *	document number 290655-003, 290677-014: 82801AA (ICH), 82801AB (ICHO)
+ *	document number 290687-002, 298242-027: 82801BA (ICH2)
+ *	document number 290733-003, 290739-013: 82801CA (ICH3-S)
+ *	document number 290716-001, 290718-007: 82801CAM (ICH3-M)
+ *	document number 290744-001, 290745-025: 82801DB (ICH4)
+ *	document number 252337-001, 252663-008: 82801DBM (ICH4-M)
+ *	document number 273599-001, 273645-002: 82801E (C-ICH)
+ *	document number 252516-001, 252517-028: 82801EB (ICH5), 82801ER (ICH5R)
+ *	document number 300641-004, 300884-013: 6300ESB
+ *	document number 301473-002, 301474-026: 82801F (ICH6)
+ *	document number 313082-001, 313075-006: 631xESB, 632xESB
+ *	document number 307013-003, 307014-024: 82801G (ICH7)
+ *	document number 313056-003, 313057-017: 82801H (ICH8)
+ *	document number 316972-004, 316973-012: 82801I (ICH9)
+ *	document number 319973-002, 319974-002: 82801J (ICH10)
+ *	document number 322169-001, 322170-001: 5 Series, 3400 Series (PCH)
  */
 
 /*
@@ -122,6 +97,9 @@ enum iTCO_chipsets {
 	TCO_ICH10R,	/* ICH10R */
 	TCO_ICH10D,	/* ICH10D */
 	TCO_ICH10DO,	/* ICH10DO */
+	TCO_PCH,	/* PCH Desktop Full Featured */
+	TCO_PCHM,	/* PCH Mobile Full Featured */
+	TCO_PCHMSFF,	/* PCH Mobile SFF Full Featured */
 };
 
 static struct {
@@ -162,6 +140,9 @@ static struct {
 	{"ICH10R", 2},
 	{"ICH10D", 2},
 	{"ICH10DO", 2},
+	{"PCH Desktop Full Featured", 2},
+	{"PCH Mobile Full Featured", 2},
+	{"PCH Mobile SFF Full Featured", 2},
 	{NULL, 0}
 };
 
@@ -230,6 +211,9 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x3a16,				TCO_ICH10R)},
 	{ ITCO_PCI_DEVICE(0x3a1a,				TCO_ICH10D)},
 	{ ITCO_PCI_DEVICE(0x3a14,				TCO_ICH10DO)},
+	{ ITCO_PCI_DEVICE(0x3b00,				TCO_PCH)},
+	{ ITCO_PCI_DEVICE(0x3b01,				TCO_PCHM)},
+	{ ITCO_PCI_DEVICE(0x3b0d,				TCO_PCHMSFF)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index b57ac6b..85b93e1 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -36,6 +36,7 @@
 #include <linux/clk.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/cpufreq.h>
 
 #include <mach/map.h>
 
@@ -142,9 +143,14 @@ static void s3c2410wdt_start(void)
 	spin_unlock(&wdt_lock);
 }
 
+static inline int s3c2410wdt_is_running(void)
+{
+	return readl(wdt_base + S3C2410_WTCON) & S3C2410_WTCON_ENABLE;
+}
+
 static int s3c2410wdt_set_heartbeat(int timeout)
 {
-	unsigned int freq = clk_get_rate(wdt_clock);
+	unsigned long freq = clk_get_rate(wdt_clock);
 	unsigned int count;
 	unsigned int divisor = 1;
 	unsigned long wtcon;
@@ -155,7 +161,7 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 	freq /= 128;
 	count = timeout * freq;
 
-	DBG("%s: count=%d, timeout=%d, freq=%d\n",
+	DBG("%s: count=%d, timeout=%d, freq=%lu\n",
 	    __func__, count, timeout, freq);
 
 	/* if the count is bigger than the watchdog register,
@@ -324,6 +330,73 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 	s3c2410wdt_keepalive();
 	return IRQ_HANDLED;
 }
+
+
+#ifdef CONFIG_CPU_FREQ
+
+static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
+					  unsigned long val, void *data)
+{
+	int ret;
+
+	if (!s3c2410wdt_is_running())
+		goto done;
+
+	if (val == CPUFREQ_PRECHANGE) {
+		/* To ensure that over the change we don't cause the
+		 * watchdog to trigger, we perform an keep-alive if
+		 * the watchdog is running.
+		 */
+
+		s3c2410wdt_keepalive();
+	} else if (val == CPUFREQ_POSTCHANGE) {
+		s3c2410wdt_stop();
+
+		ret = s3c2410wdt_set_heartbeat(tmr_margin);
+
+		if (ret >= 0)
+			s3c2410wdt_start();
+		else
+			goto err;
+	}
+
+done:
+	return 0;
+
+ err:
+	dev_err(wdt_dev, "cannot set new value for timeout %d\n", tmr_margin);
+	return ret;
+}
+
+static struct notifier_block s3c2410wdt_cpufreq_transition_nb = {
+	.notifier_call	= s3c2410wdt_cpufreq_transition,
+};
+
+static inline int s3c2410wdt_cpufreq_register(void)
+{
+	return cpufreq_register_notifier(&s3c2410wdt_cpufreq_transition_nb,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+static inline void s3c2410wdt_cpufreq_deregister(void)
+{
+	cpufreq_unregister_notifier(&s3c2410wdt_cpufreq_transition_nb,
+				    CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+#else
+static inline int s3c2410wdt_cpufreq_register(void)
+{
+	return 0;
+}
+
+static inline void s3c2410wdt_cpufreq_deregister(void)
+{
+}
+#endif
+
+
+
 /* device interface */
 
 static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
@@ -387,6 +460,11 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 	clk_enable(wdt_clock);
 
+	if (s3c2410wdt_cpufreq_register() < 0) {
+		printk(KERN_ERR PFX "failed to register cpufreq\n");
+		goto err_clk;
+	}
+
 	/* see if we can actually set the requested timer margin, and if
 	 * not, try the default value */
 
@@ -407,7 +485,7 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "cannot register miscdev on minor=%d (%d)\n",
 			WATCHDOG_MINOR, ret);
-		goto err_clk;
+		goto err_cpufreq;
 	}
 
 	if (tmr_atboot && started == 0) {
@@ -432,6 +510,9 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
+ err_cpufreq:
+	s3c2410wdt_cpufreq_deregister();
+
  err_clk:
 	clk_disable(wdt_clock);
 	clk_put(wdt_clock);
@@ -451,6 +532,8 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 
 static int __devexit s3c2410wdt_remove(struct platform_device *dev)
 {
+	s3c2410wdt_cpufreq_deregister();
+
 	release_resource(wdt_mem);
 	kfree(wdt_mem);
 	wdt_mem = NULL;
