Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0CBXtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:49:55 -0500
Received: from kroah.org ([198.145.64.141]:51609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab0CBXg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/36] tty: declare MODULE_FIRMWARE in various drivers
Date: Tue,  2 Mar 2010 15:36:25 -0800
Message-Id: <1267573003-782-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c          |    1 +
 drivers/char/ip2/ip2main.c       |    2 ++
 drivers/char/isicom.c            |    5 +++++
 drivers/char/moxa.c              |    3 +++
 drivers/serial/icom.c            |    4 +++-
 drivers/usb/serial/keyspan_pda.c |    7 +++++++
 6 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index e026f24..b861c08 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4195,3 +4195,4 @@ module_exit(cy_cleanup_module);
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CY_VERSION);
 MODULE_ALIAS_CHARDEV_MAJOR(CYCLADES_MAJOR);
+MODULE_FIRMWARE("cyzfirm.bin");
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index c2c915a..911e1da 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -3209,3 +3209,5 @@ static struct pci_device_id ip2main_pci_tbl[] __devinitdata = {
 };
 
 MODULE_DEVICE_TABLE(pci, ip2main_pci_tbl);
+
+MODULE_FIRMWARE("intelliport2.bin");
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 77d5a29..be2e8f9 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1720,3 +1720,8 @@ module_exit(isicom_exit);
 MODULE_AUTHOR("MultiTech");
 MODULE_DESCRIPTION("Driver for the ISI series of cards by MultiTech");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("isi608.bin");
+MODULE_FIRMWARE("isi608em.bin");
+MODULE_FIRMWARE("isi616em.bin");
+MODULE_FIRMWARE("isi4608.bin");
+MODULE_FIRMWARE("isi4616.bin");
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 49a1fc2..166495d 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -172,6 +172,9 @@ static unsigned int numports[MAX_BOARDS];
 MODULE_AUTHOR("William Chen");
 MODULE_DESCRIPTION("MOXA Intellio Family Multiport Board Device Driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("c218tunx.cod");
+MODULE_FIRMWARE("cp204unx.cod");
+MODULE_FIRMWARE("c320tunx.cod");
 
 module_param_array(type, uint, NULL, 0);
 MODULE_PARM_DESC(type, "card type: C218=2, C320=4");
diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 0028b6f..6e715b7 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -1654,4 +1654,6 @@ MODULE_DESCRIPTION("IBM iSeries Serial IOA driver");
 MODULE_SUPPORTED_DEVICE
     ("IBM iSeries 2745, 2771, 2772, 2742, 2793 and 2805 Communications adapters");
 MODULE_LICENSE("GPL");
-
+MODULE_FIRMWARE("icom_call_setup.bin");
+MODULE_FIRMWARE("icom_res_dce.bin");
+MODULE_FIRMWARE("icom_asc.bin");
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 1296a09..84f08e9 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -789,6 +789,13 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 	return 1;
 }
 
+#ifdef KEYSPAN
+MODULE_FIRMWARE("keyspan_pda/keyspan_pda.fw");
+#endif
+#ifdef XIRCOM
+MODULE_FIRMWARE("keyspan_pda/xircom_pgs.fw");
+#endif
+
 static int keyspan_pda_startup(struct usb_serial *serial)
 {
 
-- 
1.7.0.1

