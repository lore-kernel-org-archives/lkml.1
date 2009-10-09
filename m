Return-Path: <linux-kernel-owner+w=401wt.eu-S964856AbZJIX14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856AbZJIX14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934609AbZJIX13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:27:29 -0400
Received: from kroah.org ([198.145.64.141]:56341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934608AbZJIX10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:27:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:22:34 2009
Message-Id: <20091009232234.333042452@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:21:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [7/8] [WATCHDOG] hpwdt.c: Add new HP BMC controller.
From: gregkh@mini.kroah.org
References: <20091009232123.464253035@mini.kroah.org>
Content-Disposition: inline; filename=hpwdt.c-add-new-hp-bmc-controller.patch
In-Reply-To: <20091009232300.GA403@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Mingarelli <Thomas.Mingarelli@hp.com>

commit d8100c3abfd32986a8820ce4e614b0223a2d22a9 upstream.

Add the PCI-ID for the upcoming new BMC controller for HP hardware.

Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/hpwdt.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -47,6 +47,7 @@
 #define PCI_BIOS32_PARAGRAPH_LEN	16
 #define PCI_ROM_BASE1			0x000F0000
 #define ROM_SIZE			0x10000
+#define HPWDT_VERSION			"1.01"
 
 struct bios32_service_dir {
 	u32 signature;
@@ -130,12 +131,8 @@ static void *cru_rom_addr;
 static struct cmn_registers cmn_regs;
 
 static struct pci_device_id hpwdt_devices[] = {
-	{
-	 .vendor = PCI_VENDOR_ID_COMPAQ,
-	 .device = 0xB203,
-	 .subvendor = PCI_ANY_ID,
-	 .subdevice = PCI_ANY_ID,
-	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_COMPAQ, 0xB203) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_HP, 0x3306) },
 	{0},			/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
@@ -704,10 +701,11 @@ static int __devinit hpwdt_init_one(stru
 	}
 
 	printk(KERN_INFO
-		"hp Watchdog Timer Driver: 1.00"
+		"hp Watchdog Timer Driver: %s"
 		", timer margin: %d seconds (nowayout=%d)"
 		", allow kernel dump: %s (default = 0/OFF).\n",
-		soft_margin, nowayout, (allow_kdump == 0) ? "OFF" : "ON");
+		HPWDT_VERSION, soft_margin, nowayout,
+		(allow_kdump == 0) ? "OFF" : "ON");
 
 	return 0;
 
@@ -757,6 +755,7 @@ static int __init hpwdt_init(void)
 MODULE_AUTHOR("Tom Mingarelli");
 MODULE_DESCRIPTION("hp watchdog driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(HPWDT_VERSION);
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(soft_margin, int, 0);


