Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbXD0TDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbXD0TDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbXD0S7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:59:17 -0400
Received: from ns1.suse.de ([195.135.220.2]:50861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757083AbXD0S7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:59:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/46] dev_dbg: check dev_dbg() arguments
Date: Fri, 27 Apr 2007 11:54:00 -0700
Message-Id: <1177700214849-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777002102105-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
 <11777001682584-git-send-email-gregkh@suse.de>
 <1177700172258-git-send-email-gregkh@suse.de>
 <11777001773804-git-send-email-gregkh@suse.de>
 <11777001803098-git-send-email-gregkh@suse.de>
 <11777001852549-git-send-email-gregkh@suse.de>
 <11777001891914-git-send-email-gregkh@suse.de>
 <11777001931075-git-send-email-gregkh@suse.de>
 <11777001971761-git-send-email-gregkh@suse.de>
 <11777002022552-git-send-email-gregkh@suse.de>
 <11777002064008-git-send-email-gregkh@suse.de>
 <11777002102105-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Duplicate what Zach Brown did for pr_debug in commit
8b2a1fd1b394c60eaa2587716102dd5e9b4e5990

[akpm@linux-foundation.org: fix a couple of things which broke]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hub.c      |    4 +---
 drivers/usb/host/ohci-hcd.c |    6 ------
 include/linux/device.h      |    6 +++++-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b89a98e..7a60285 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -119,8 +119,7 @@ MODULE_PARM_DESC(use_both_schemes,
 		"first one fails");
 
 
-#ifdef	DEBUG
-static inline char *portspeed (int portstatus)
+static inline char *portspeed(int portstatus)
 {
 	if (portstatus & (1 << USB_PORT_FEAT_HIGHSPEED))
     		return "480 Mb/s";
@@ -129,7 +128,6 @@ static inline char *portspeed (int portstatus)
 	else
 		return "12 Mb/s";
 }
-#endif
 
 /* Note that hdev or one of its children must be locked! */
 static inline struct usb_hub *hdev_to_hub(struct usb_device *hdev)
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index f0d29ed..e8bbe8b 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -486,9 +486,6 @@ static int ohci_run (struct ohci_hcd *ohci)
 	 * or if bus glue did the same (e.g. for PCI add-in cards with
 	 * PCI PM support).
 	 */
-	ohci_dbg (ohci, "resetting from state '%s', control = 0x%x\n",
-			hcfs2string (ohci->hc_control & OHCI_CTRL_HCFS),
-			ohci_readl (ohci, &ohci->regs->control));
 	if ((ohci->hc_control & OHCI_CTRL_RWC) != 0
 			&& !device_may_wakeup(hcd->self.controller))
 		device_init_wakeup(hcd->self.controller, 1);
@@ -744,9 +741,6 @@ static void ohci_stop (struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 
-	ohci_dbg (ohci, "stop %s controller (state 0x%02x)\n",
-		hcfs2string (ohci->hc_control & OHCI_CTRL_HCFS),
-		hcd->state);
 	ohci_dump (ohci, 1);
 
 	flush_scheduled_work();
diff --git a/include/linux/device.h b/include/linux/device.h
index 8511d14..a0cd2ce 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -571,7 +571,11 @@ extern const char *dev_driver_string(struct device *dev);
 #define dev_dbg(dev, format, arg...)		\
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
-#define dev_dbg(dev, format, arg...) do { (void)(dev); } while (0)
+static inline int __attribute__ ((format (printf, 2, 3)))
+dev_dbg(struct device * dev, const char * fmt, ...)
+{
+	return 0;
+}
 #endif
 
 #define dev_err(dev, format, arg...)		\
-- 
1.5.1.2

