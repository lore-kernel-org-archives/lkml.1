Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbXKBXKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbXKBXKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 19:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbXKBXKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 19:10:47 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:20163 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbXKBXKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 19:10:45 -0400
X-Belgacom-Dynamic: yes
Date: Sat, 3 Nov 2007 00:10:41 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.24 Watchdog Device Drivers patches - part 3
Message-ID: <20071102231041.GA4260@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/alim1535_wdt.c   |    4 -
 drivers/watchdog/davinci_wdt.c    |    6 --
 drivers/watchdog/i6300esb.c       |    4 -
 drivers/watchdog/iTCO_wdt.c       |  114 ++++++++++++++++++++++----------------
 drivers/watchdog/ib700wdt.c       |    4 -
 drivers/watchdog/machzwd.c        |    7 --
 drivers/watchdog/mpc83xx_wdt.c    |    5 -
 drivers/watchdog/pc87413_wdt.c    |    4 -
 drivers/watchdog/pnx4008_wdt.c    |    6 --
 drivers/watchdog/sbc8360.c        |    3 -
 drivers/watchdog/sc1200wdt.c      |    3 -
 drivers/watchdog/sc520_wdt.c      |    4 -
 drivers/watchdog/smsc37b787_wdt.c |    4 -
 drivers/watchdog/w83627hf_wdt.c   |    4 -
 drivers/watchdog/w83697hf_wdt.c   |    4 -
 drivers/watchdog/w83877f_wdt.c    |    4 -
 drivers/watchdog/w83977f_wdt.c    |    4 -
 drivers/watchdog/wafer5823wdt.c   |    4 -
 drivers/watchdog/wdt.c            |    3 -
 drivers/watchdog/wdt977.c         |    4 -
 drivers/watchdog/wdt_pci.c        |    6 +-
 21 files changed, 92 insertions(+), 109 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Aug 31 08:23:10 2007 +0000

    [WATCHDOG] iTCO_wdt.c ICH8 pci-device-id's
    
    Add the pci-device-id's for the ICH8M and the ICH8M-E chipsets.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Aug 31 08:15:34 2007 +0000

    [WATCHDOG] iTCO_wdt.c init & exit fixes
    
    Mark init and exit procedures as __devinit & _-devexit.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Aug 19 20:17:58 2007 +0000

    [WATCHDOG] iTCO_wdt.c pci_device_id table clean-up
    
    Make the pci_device_id table more readable.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alexey Dobriyan <adobriyan@sw.ru>
Date:   Thu Nov 1 16:27:08 2007 -0700

    [WATCHDOG] spin_lock_init() fixes
    
    Some watchdog drivers initialize global spinlocks in module's init function
    which is tolerable, but some do it in PCI probe function.  So, switch to
    static initialization to fix theoretical bugs and, more importantly, stop
    giving people bad examples.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Tue Oct 23 03:08:27 2007 +0200

    [WATCHDOG] Unlock in iTCO_wdt_start when reboot is disabled
    
    Unlock in iTCO_wdt_start when reboot is disabled
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Date:   Tue Oct 23 13:40:54 2007 -0700

    [WATCHDOG] Add necessary braces to if (...) \n #if... cases
    
    Signed-off-by: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Florian Fainelli <florian.fainelli@telecomint.eu>
Date:   Wed Oct 17 15:42:22 2007 +0200

    [WATCHDOG] trivial fix two returns in void functions
    
    This patch fixes two returns in the TI Davinci and
    PNX4008 in void functions.
    
    Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index c404fc6..b481cc0 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -31,7 +31,7 @@ static unsigned long ali_is_open;
 static char ali_expect_release;
 static struct pci_dev *ali_pci;
 static u32 ali_timeout_bits;	/* stores the computed timeout */
-static spinlock_t ali_lock;	/* Guards the hardware */
+static DEFINE_SPINLOCK(ali_lock);	/* Guards the hardware */
 
 /* module parameters */
 static int timeout = WATCHDOG_TIMEOUT;
@@ -398,8 +398,6 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
-	spin_lock_init(&ali_lock);
-
 	/* Check whether or not the hardware watchdog is there */
 	if (ali_find_watchdog() != 0) {
 		return -ENODEV;
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 19db530..a61cbd4 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -61,7 +61,7 @@
 
 static int heartbeat = DEFAULT_HEARTBEAT;
 
-static spinlock_t io_lock;
+static DEFINE_SPINLOCK(io_lock);
 static unsigned long wdt_status;
 #define WDT_IN_USE        0
 #define WDT_OK_TO_CLOSE   1
@@ -200,8 +200,6 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	int ret = 0, size;
 	struct resource *res;
 
-	spin_lock_init(&io_lock);
-
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
@@ -262,7 +260,7 @@ static int __init davinci_wdt_init(void)
 
 static void __exit davinci_wdt_exit(void)
 {
-	return platform_driver_unregister(&platform_wdt_driver);
+	platform_driver_unregister(&platform_wdt_driver);
 }
 
 module_init(davinci_wdt_init);
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index f236954..ca44fd9 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -77,7 +77,7 @@
 
 /* internal variables */
 static void __iomem *BASEADDR;
-static spinlock_t esb_lock; /* Guards the hardware */
+static DEFINE_SPINLOCK(esb_lock); /* Guards the hardware */
 static unsigned long timer_alive;
 static struct pci_dev *esb_pci;
 static unsigned short triggered; /* The status of the watchdog upon boot */
@@ -456,8 +456,6 @@ static int __init watchdog_init (void)
 {
         int ret;
 
-        spin_lock_init(&esb_lock);
-
         /* Check whether or not the hardware watchdog is there */
         if (!esb_getdevice () || esb_pci == NULL)
                 return -ENODEV;
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index cd5a565..a0e6809 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -35,10 +35,12 @@
  *	82801GDH (ICH7DH)    : document number 307013-002, 307014-009,
  *	82801GBM (ICH7-M)    : document number 307013-002, 307014-009,
  *	82801GHM (ICH7-M DH) : document number 307013-002, 307014-009,
- *	82801HB  (ICH8)      : document number 313056-002, 313057-004,
- *	82801HR  (ICH8R)     : document number 313056-002, 313057-004,
- *	82801HH  (ICH8DH)    : document number 313056-002, 313057-004,
- *	82801HO  (ICH8DO)    : document number 313056-002, 313057-004,
+ *	82801HB  (ICH8)      : document number 313056-003, 313057-009,
+ *	82801HR  (ICH8R)     : document number 313056-003, 313057-009,
+ *	82801HBM (ICH8M)     : document number 313056-003, 313057-009,
+ *	82801HH  (ICH8DH)    : document number 313056-003, 313057-009,
+ *	82801HO  (ICH8DO)    : document number 313056-003, 313057-009,
+ *	82801HEM (ICH8M-E)   : document number 313056-003, 313057-009,
  *	82801IB  (ICH9)      : document number 316972-001, 316973-001,
  *	82801IR  (ICH9R)     : document number 316972-001, 316973-001,
  *	82801IH  (ICH9DH)    : document number 316972-001, 316973-001,
@@ -95,8 +97,10 @@ enum iTCO_chipsets {
 	TCO_ICH7M,	/* ICH7-M */
 	TCO_ICH7MDH,	/* ICH7-M DH */
 	TCO_ICH8,	/* ICH8 & ICH8R */
+	TCO_ICH8ME,	/* ICH8M-E */
 	TCO_ICH8DH,	/* ICH8DH */
 	TCO_ICH8DO,	/* ICH8DO */
+	TCO_ICH8M,	/* ICH8M */
 	TCO_ICH9,	/* ICH9 */
 	TCO_ICH9R,	/* ICH9R */
 	TCO_ICH9DH,	/* ICH9DH */
@@ -125,8 +129,10 @@ static struct {
 	{"ICH7-M", 2},
 	{"ICH7-M DH", 2},
 	{"ICH8 or ICH8R", 2},
+	{"ICH8M-E", 2},
 	{"ICH8DH", 2},
 	{"ICH8DO", 2},
+	{"ICH8M", 2},
 	{"ICH9", 2},
 	{"ICH9R", 2},
 	{"ICH9DH", 2},
@@ -134,6 +140,15 @@ static struct {
 	{NULL,0}
 };
 
+#define ITCO_PCI_DEVICE(dev, data) 	\
+	.vendor = PCI_VENDOR_ID_INTEL,	\
+	.device = dev,			\
+	.subvendor = PCI_ANY_ID,	\
+	.subdevice = PCI_ANY_ID,	\
+	.class = 0,			\
+	.class_mask = 0,		\
+	.driver_data = data
+
 /*
  * This data only exists for exporting the supported PCI ids
  * via MODULE_DEVICE_TABLE.  We do not actually register a
@@ -141,45 +156,47 @@ static struct {
  * functions that probably will be registered by other drivers.
  */
 static struct pci_device_id iTCO_wdt_pci_tbl[] = {
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AA_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH     },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801AB_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH0    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH2    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801BA_10,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH2M   },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH3    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_12,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH3M   },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH4    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801DB_12,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH4M   },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801E_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_CICH    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801EB_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH5    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_6300ESB },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH6    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH6M   },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_2,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH6W   },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH7    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH7M   },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_31,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH7MDH },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH8    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_2,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH8DH  },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH8_3,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH8DO  },
-	{ PCI_VENDOR_ID_INTEL, 0x2918,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH9    },
-	{ PCI_VENDOR_ID_INTEL, 0x2916,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH9R    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_2,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_ICH9DH    },
-	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2671,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2672,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2673,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2674,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2675,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2676,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2677,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2678,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x2679,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x267a,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x267b,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x267c,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x267d,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x267e,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
-	{ PCI_VENDOR_ID_INTEL, 0x267f,	PCI_ANY_ID, PCI_ANY_ID, 0, 0, TCO_631XESB },
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH    )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB_1,		TCO_6300ESB)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M  )},
+	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9   )},
+	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2673,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2674,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2675,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2676,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2677,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2678,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x2679,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x267a,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x267b,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x267c,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x267d,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x267e,				TCO_631XESB)},
+	{ ITCO_PCI_DEVICE(0x267f,				TCO_631XESB)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE (pci, iTCO_wdt_pci_tbl);
@@ -300,6 +317,7 @@ static int iTCO_wdt_start(void)
 
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
+		spin_unlock(&iTCO_wdt_private.io_lock);
 		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot disabled by hardware\n");
 		return -EIO;
 	}
@@ -590,7 +608,7 @@ static struct miscdevice iTCO_wdt_miscdev = {
  *	Init & exit routines
  */
 
-static int iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device_id *ent, struct platform_device *dev)
+static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device_id *ent, struct platform_device *dev)
 {
 	int ret;
 	u32 base_address;
@@ -694,7 +712,7 @@ out:
 	return ret;
 }
 
-static void iTCO_wdt_cleanup(void)
+static void __devexit iTCO_wdt_cleanup(void)
 {
 	/* Stop the timer before we leave */
 	if (!nowayout)
@@ -709,7 +727,7 @@ static void iTCO_wdt_cleanup(void)
 	iTCO_wdt_private.ACPIBASE = 0;
 }
 
-static int iTCO_wdt_probe(struct platform_device *dev)
+static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 {
 	int found = 0;
 	struct pci_dev *pdev = NULL;
@@ -735,7 +753,7 @@ static int iTCO_wdt_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int iTCO_wdt_remove(struct platform_device *dev)
+static int __devexit iTCO_wdt_remove(struct platform_device *dev)
 {
 	if (iTCO_wdt_private.ACPIBASE)
 		iTCO_wdt_cleanup();
@@ -753,7 +771,7 @@ static void iTCO_wdt_shutdown(struct platform_device *dev)
 
 static struct platform_driver iTCO_wdt_driver = {
 	.probe          = iTCO_wdt_probe,
-	.remove         = iTCO_wdt_remove,
+	.remove         = __devexit_p(iTCO_wdt_remove),
 	.shutdown       = iTCO_wdt_shutdown,
 	.suspend        = iTCO_wdt_suspend,
 	.resume         = iTCO_wdt_resume,
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index c3a60f5..4b89f40 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -48,7 +48,7 @@
 
 static struct platform_device *ibwdt_platform_device;
 static unsigned long ibwdt_is_open;
-static spinlock_t ibwdt_lock;
+static DEFINE_SPINLOCK(ibwdt_lock);
 static char expect_close;
 
 /* Module information */
@@ -308,8 +308,6 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 {
 	int res;
 
-	spin_lock_init(&ibwdt_lock);
-
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
 		printk (KERN_ERR PFX "STOP method I/O %X is not available.\n", WDT_STOP);
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 6d35bb1..e6e07b4 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -123,8 +123,8 @@ static void zf_ping(unsigned long data);
 static int zf_action = GEN_RESET;
 static unsigned long zf_is_open;
 static char zf_expect_close;
-static spinlock_t zf_lock;
-static spinlock_t zf_port_lock;
+static DEFINE_SPINLOCK(zf_lock);
+static DEFINE_SPINLOCK(zf_port_lock);
 static DEFINE_TIMER(zf_timer, zf_ping, 0, 0);
 static unsigned long next_heartbeat = 0;
 
@@ -438,9 +438,6 @@ static int __init zf_init(void)
 
 	zf_show_action(action);
 
-	spin_lock_init(&zf_lock);
-	spin_lock_init(&zf_port_lock);
-
 	if(!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")){
 		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
 							ZF_IOBASE);
diff --git a/drivers/watchdog/mpc83xx_wdt.c b/drivers/watchdog/mpc83xx_wdt.c
index a0bf95f..6369f56 100644
--- a/drivers/watchdog/mpc83xx_wdt.c
+++ b/drivers/watchdog/mpc83xx_wdt.c
@@ -56,7 +56,7 @@ static int prescale = 1;
 static unsigned int timeout_sec;
 
 static unsigned long wdt_is_open;
-static spinlock_t wdt_spinlock;
+static DEFINE_SPINLOCK(wdt_spinlock);
 
 static void mpc83xx_wdt_keepalive(void)
 {
@@ -185,9 +185,6 @@ static int __devinit mpc83xx_wdt_probe(struct platform_device *dev)
 	printk(KERN_INFO "WDT driver for MPC83xx initialized. "
 		"mode:%s timeout=%d (%d seconds)\n",
 		reset ? "reset":"interrupt", timeout, timeout_sec);
-
-	spin_lock_init(&wdt_spinlock);
-
 	return 0;
 
 err_unmap:
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 3d3deae..15e4f88 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -61,7 +61,7 @@ static unsigned long timer_enabled = 0;  /* is the timer enabled? */
 
 static char expect_close;                /* is the close expected? */
 
-static spinlock_t io_lock;               /* to guard the watchdog from io races */
+static DEFINE_SPINLOCK(io_lock);/* to guard the watchdog from io races */
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 
@@ -561,8 +561,6 @@ static int __init pc87413_init(void)
 {
 	int ret;
 
-	spin_lock_init(&io_lock);
-
 	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n", WDT_INDEX_IO_PORT);
 
 	/* request_region(io, 2, "pc87413"); */
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 22f8873..b04aa09 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -80,7 +80,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = DEFAULT_HEARTBEAT;
 
-static spinlock_t io_lock;
+static DEFINE_SPINLOCK(io_lock);
 static unsigned long wdt_status;
 #define WDT_IN_USE        0
 #define WDT_OK_TO_CLOSE   1
@@ -254,8 +254,6 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 	int ret = 0, size;
 	struct resource *res;
 
-	spin_lock_init(&io_lock);
-
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
@@ -335,7 +333,7 @@ static int __init pnx4008_wdt_init(void)
 
 static void __exit pnx4008_wdt_exit(void)
 {
-	return platform_driver_unregister(&platform_wdt_driver);
+	platform_driver_unregister(&platform_wdt_driver);
 }
 
 module_init(pnx4008_wdt_init);
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 285d852..2ee2677 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -54,7 +54,7 @@
 #include <asm/system.h>
 
 static unsigned long sbc8360_is_open;
-static spinlock_t sbc8360_lock;
+static DEFINE_SPINLOCK(sbc8360_lock);
 static char expect_close;
 
 #define PFX "sbc8360: "
@@ -359,7 +359,6 @@ static int __init sbc8360_init(void)
 		goto out_noreboot;
 	}
 
-	spin_lock_init(&sbc8360_lock);
 	res = misc_register(&sbc8360_miscdev);
 	if (res) {
 		printk(KERN_ERR PFX "failed to register misc device\n");
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 9670d47..32ccd7c 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -74,7 +74,7 @@ static int io = -1;
 static int io_len = 2;		/* for non plug and play */
 static struct semaphore open_sem;
 static char expect_close;
-static spinlock_t sc1200wdt_lock;	/* io port access serialisation */
+static DEFINE_SPINLOCK(sc1200wdt_lock);	/* io port access serialisation */
 
 #if defined CONFIG_PNP
 static int isapnp = 1;
@@ -375,7 +375,6 @@ static int __init sc1200wdt_init(void)
 
 	printk("%s\n", banner);
 
-	spin_lock_init(&sc1200wdt_lock);
 	sema_init(&open_sem, 1);
 
 #if defined CONFIG_PNP
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index e8594c6..2847324 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -125,7 +125,7 @@ static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
-static spinlock_t wdt_spinlock;
+static DEFINE_SPINLOCK(wdt_spinlock);
 
 /*
  *	Whack the dog
@@ -383,8 +383,6 @@ static int __init sc520_wdt_init(void)
 {
 	int rc = -EBUSY;
 
-	spin_lock_init(&wdt_spinlock);
-
 	/* Check that the timeout value is within it's range ; if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index d3cb0a7..5d2b5ba 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -83,7 +83,7 @@ static unsigned long timer_enabled = 0;   /* is the timer enabled? */
 
 static char expect_close;       /* is the close expected? */
 
-static spinlock_t io_lock;	/* to guard the watchdog from io races */
+static DEFINE_SPINLOCK(io_lock);/* to guard the watchdog from io races */
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 
@@ -540,8 +540,6 @@ static int __init wb_smsc_wdt_init(void)
 {
 	int ret;
 
-	spin_lock_init(&io_lock);
-
 	printk("SMsC 37B787 watchdog component driver " VERSION " initialising...\n");
 
 	if (!request_region(IOPORT, IOPORT_SIZE, "SMsC 37B787 watchdog")) {
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index df33b3b..3864928 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -48,7 +48,7 @@
 
 static unsigned long wdt_is_open;
 static char expect_close;
-static spinlock_t io_lock;
+static DEFINE_SPINLOCK(io_lock);
 
 /* You must set this - there is no sane way to probe for this board. */
 static int wdt_io = 0x2E;
@@ -328,8 +328,6 @@ wdt_init(void)
 {
 	int ret;
 
-	spin_lock_init(&io_lock);
-
 	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.\n");
 
 	if (wdt_set_heartbeat(timeout)) {
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 51826c2..c622a0e 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -47,7 +47,7 @@
 
 static unsigned long wdt_is_open;
 static char expect_close;
-static spinlock_t io_lock;
+static DEFINE_SPINLOCK(io_lock);
 
 /* You must set this - there is no sane way to probe for this board. */
 static int wdt_io = 0x2e;
@@ -376,8 +376,6 @@ wdt_init(void)
 {
 	int ret, i, found = 0;
 
-	spin_lock_init(&io_lock);
-
 	printk (KERN_INFO PFX "WDT driver for W83697HF/HG initializing\n");
 
 	if (wdt_io == 0) {
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 3c88fe1..bcc9d48 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -94,7 +94,7 @@ static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
 static unsigned long next_heartbeat;
 static unsigned long wdt_is_open;
 static char wdt_expect_close;
-static spinlock_t wdt_spinlock;
+static DEFINE_SPINLOCK(wdt_spinlock);
 
 /*
  *	Whack the dog
@@ -350,8 +350,6 @@ static int __init w83877f_wdt_init(void)
 {
 	int rc = -EBUSY;
 
-	spin_lock_init(&wdt_spinlock);
-
 	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
 	{
 		timeout = WATCHDOG_TIMEOUT;
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 1579684..b475529 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -50,7 +50,7 @@ static	int timeoutW;			/* timeout in watchdog counter units */
 static	unsigned long timer_alive;
 static	int testmode;
 static	char expect_close;
-static	spinlock_t spinlock;
+static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,"Watchdog timeout in seconds (15..7635), default=" __MODULE_STRING(DEFAULT_TIMEOUT) ")");
@@ -476,8 +476,6 @@ static int __init w83977f_wdt_init(void)
 
         printk(KERN_INFO PFX DRIVER_VERSION);
 
-	spin_lock_init(&spinlock);
-
 	/*
 	 * Check that the timeout value is within it's range ; 
 	 * if not reset to the default
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 950905d..9e36809 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -45,7 +45,7 @@
 
 static unsigned long wafwdt_is_open;
 static char expect_close;
-static spinlock_t wafwdt_lock;
+static DEFINE_SPINLOCK(wafwdt_lock);
 
 /*
  *	You must set these - there is no sane way to probe for this board.
@@ -252,8 +252,6 @@ static int __init wafwdt_init(void)
 
 	printk(KERN_INFO "WDT driver for Wafer 5823 single board computer initialising.\n");
 
-	spin_lock_init(&wafwdt_lock);
-
 	if (timeout < 1 || timeout > 255) {
 		timeout = WD_TIMO;
 		printk (KERN_INFO PFX "timeout value must be 1<=x<=255, using %d\n",
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 0a3de6a..53d0bb4 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -253,7 +253,7 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 			printk(KERN_CRIT "Possible fan fault.\n");
 	}
 #endif /* CONFIG_WDT_501 */
-	if (!(status & WDC_SR_WCCR))
+	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
 		printk(KERN_CRIT "Would Reboot.\n");
@@ -264,6 +264,7 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 #else
 		printk(KERN_CRIT "Reset in 5ms.\n");
 #endif
+	}
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 7d300ff..9b7f6b6 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -59,7 +59,7 @@ static	int timeoutM;				/* timeout in minutes */
 static	unsigned long timer_alive;
 static	int testmode;
 static	char expect_close;
-static	spinlock_t spinlock;
+static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,"Watchdog timeout in seconds (60..15300), default=" __MODULE_STRING(DEFAULT_TIMEOUT) ")");
@@ -448,8 +448,6 @@ static int __init wd977_init(void)
 
 	printk(KERN_INFO PFX DRIVER_VERSION);
 
-	spin_lock_init(&spinlock);
-
 	/* Check that the timeout value is within it's range ; if not reset to the default */
 	if (wdt977_set_timeout(timeout))
 	{
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 6baf4ae..1355608 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -74,7 +74,7 @@
 static int dev_count;
 
 static struct semaphore open_sem;
-static spinlock_t wdtpci_lock;
+static DEFINE_SPINLOCK(wdtpci_lock);
 static char expect_close;
 
 static int io;
@@ -298,7 +298,7 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 			printk(KERN_CRIT PFX "Possible fan fault.\n");
 	}
 #endif /* CONFIG_WDT_501_PCI */
-	if (!(status&WDC_SR_WCCR))
+	if (!(status&WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
 		printk(KERN_CRIT PFX "Would Reboot.\n");
@@ -309,6 +309,7 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 #else
 		printk(KERN_CRIT PFX "Reset in 5ms.\n");
 #endif
+	}
 	return IRQ_HANDLED;
 }
 
@@ -606,7 +607,6 @@ static int __devinit wdtpci_init_one (struct pci_dev *dev,
 	}
 
 	sema_init(&open_sem, 1);
-	spin_lock_init(&wdtpci_lock);
 
 	irq = dev->irq;
 	io = pci_resource_start (dev, 2);
