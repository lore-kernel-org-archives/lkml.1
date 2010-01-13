Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034Ab0AMXe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0AMXe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292Ab0AMXe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:34:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54670 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558Ab0AMXe1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:34:27 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jan 2010 23:34:18 +0000
Message-ID: <1263425658.3852.116.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 01/11] tty: declare MODULE_FIRMWARE in various drivers
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
index 2913d05..6b9a954 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -3196,3 +3196,5 @@ static struct pci_device_id ip2main_pci_tbl[] __devinitdata = {
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
1.6.5.7



