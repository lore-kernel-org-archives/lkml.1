Return-Path: <linux-kernel-owner+w=401wt.eu-S1765569AbXGaRmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765569AbXGaRmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbXGaRmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:42:12 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4986 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbXGaRmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:42:10 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 25] drivers/usb/misc/ftdi-elan.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:42:09 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       tony.olech@elandigitalsystems.com,
       linux-usb-devel@lists.sourceforge.net
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311942.10127.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/usb/misc/ftdi-elan.c | 121253 -> 121196 (-57 bytes)
 drivers/usb/misc/ftdi-elan.o | 209425 -> 209265 (-160 bytes)

 drivers/usb/misc/ftdi-elan.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/usb/misc/ftdi-elan.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/usb/misc/ftdi-elan.c	2007-07-31 14:47:59.000000000 +0200
@@ -2777,12 +2777,14 @@ static int ftdi_elan_probe(struct usb_in
         size_t buffer_size;
         int i;
         int retval = -ENOMEM;
-        struct usb_ftdi *ftdi = kmalloc(sizeof(struct usb_ftdi), GFP_KERNEL);
-        if (ftdi == NULL) {
+        struct usb_ftdi *ftdi;
+
+	ftdi = kzalloc(sizeof(struct usb_ftdi), GFP_KERNEL);
+	if (!ftdi) {
                 printk(KERN_ERR "Out of memory\n");
                 return -ENOMEM;
         }
-        memset(ftdi, 0x00, sizeof(struct usb_ftdi));
+
         mutex_lock(&ftdi_module_lock);
         list_add_tail(&ftdi->ftdi_list, &ftdi_static_list);
         ftdi->sequence_num = ++ftdi_instances;
