Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYAJWeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYAJWeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYAJWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:34:10 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:63656 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYAJWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:34:07 -0500
Date: Thu, 10 Jan 2008 14:31:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: v4l-dvb-maintainer@linuxtv.org
Cc: samr <sam@ravnborg.org>, akpm <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb/av7110: fix section mismatch
Message-Id: <20080110143147.26a1ce88.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix driver data name to match whitelist of acceptable names that contain
pointers init data so that section mismatch warning is placated.

WARNING: vmlinux.o(.data+0x141288): Section mismatch: reference to .init.text:av7110_attach (between 'av7110_extension' and 'ir_protocol')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/dvb/ttpci/av7110.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.24-rc7-git1.orig/drivers/media/dvb/ttpci/av7110.c
+++ linux-2.6.24-rc7-git1/drivers/media/dvb/ttpci/av7110.c
@@ -2800,12 +2800,12 @@ static void av7110_irq(struct saa7146_de
 }
 
 
-static struct saa7146_extension av7110_extension;
+static struct saa7146_extension av7110_extension_driver;
 
 #define MAKE_AV7110_INFO(x_var,x_name) \
 static struct saa7146_pci_extension_data x_var = { \
 	.ext_priv = x_name, \
-	.ext = &av7110_extension }
+	.ext = &av7110_extension_driver }
 
 MAKE_AV7110_INFO(tts_1_X_fsc,"Technotrend/Hauppauge WinTV DVB-S rev1.X or Fujitsu Siemens DVB-C");
 MAKE_AV7110_INFO(ttt_1_X,    "Technotrend/Hauppauge WinTV DVB-T rev1.X");
@@ -2843,7 +2843,7 @@ static struct pci_device_id pci_tbl[] = 
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
 
-static struct saa7146_extension av7110_extension = {
+static struct saa7146_extension av7110_extension_driver = {
 	.name		= "dvb",
 	.flags		= SAA7146_USE_I2C_IRQ,
 
@@ -2860,14 +2860,14 @@ static struct saa7146_extension av7110_e
 static int __init av7110_init(void)
 {
 	int retval;
-	retval = saa7146_register_extension(&av7110_extension);
+	retval = saa7146_register_extension(&av7110_extension_driver);
 	return retval;
 }
 
 
 static void __exit av7110_exit(void)
 {
-	saa7146_unregister_extension(&av7110_extension);
+	saa7146_unregister_extension(&av7110_extension_driver);
 }
 
 module_init(av7110_init);
