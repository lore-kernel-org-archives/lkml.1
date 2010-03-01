Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab0CARrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:47:09 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:44691 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0CARrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:47:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=qmUkRIVDC0AMlgrHPe+HFXbaKA8l3HIcJn79YJ6amhz/cjQy0WFAejHCnjTgPdJtqg
         g4aLp5yetDaHWZIG2dWawMOw4UClWHzTpNecU5WzhgNUKdoXlRHCrDv6CAhZA35DgUBD
         zVlksBnnMK/z3eox8qXr+2QIPrzrTobZufNkc=
Subject: [PATCH 701/701] Staging: comedi: Fix 80 characters limit and
 printk issues in skel.c
From: Ellwyn Cole <ellwync@googlemail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       Dirk Hohndel <hohndel@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 17:43:50 +0000
Message-ID: <1267465430.5415.5.camel@ellwyn-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f1ac349f0d531c7ba74abcefc9a1943bfe56536f Mon Sep 17 00:00:00 2001
From: Ellwyn Cole <ellwync@googlemail.com>
Date: Mon, 1 Mar 2010 16:44:01 +0000
Subject: [PATCH 701/701] Staging: comedi: Fix 80 characters limit and printk issues in skel.c

This is a patch to the skel.c file that fixes the 80 characters limit and
printk warnings found by the checkpatch.pl tool

Signed-off-by: Ellwyn Cole <ellwync@googlemail.com>
---
 drivers/staging/comedi/drivers/skel.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index aba57d9..490753b 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -131,7 +131,8 @@ MODULE_DEVICE_TABLE(pci, skel_pci_table);
 
 /* this structure is for data unique to this hardware driver.  If
    several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+   feel free to suggest moving the variable to the struct comedi_device struct.
+ */
 struct skel_private {
 
 	int data;
@@ -211,7 +212,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: skel: ", dev->minor);
+	pr_info("comedi%d: skel: ", dev->minor);
 
 /*
  * If you can probe the device to determine what device in a series
@@ -282,7 +283,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	printk("attached\n");
+	pr_info("attached\n");
 
 	return 0;
 }
@@ -297,7 +298,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 static int skel_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: skel: remove\n", dev->minor);
+	pr_info("comedi%d: skel: remove\n", dev->minor);
 
 	return 0;
 }
@@ -336,7 +337,7 @@ static int skel_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		if (i == TIMEOUT) {
 			/* printk() should be used instead of printk()
 			 * whenever the code can be called from real-time. */
-			printk("timeout\n");
+			pr_info("timeout\n");
 			return -ETIMEDOUT;
 		}
 
@@ -397,7 +398,8 @@ static int skel_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and mutually compatible
+     */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
@@ -529,7 +531,7 @@ static int skel_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	printk("skel_ao_winsn\n");
+	pr_info("skel_ao_winsn\n");
 	/* Writing a list of values to an AO channel is probably not
 	 * very useful, but that's how the interface is defined. */
 	for (i = 0; i < insn->n; i++) {
@@ -623,6 +625,7 @@ static int skel_dio_insn_config(struct comedi_device *dev,
  * as necessary.
  */
 COMEDI_INITCLEANUP(driver_skel);
-/* If you are writing a PCI driver you should use COMEDI_PCI_INITCLEANUP instead.
-*/
+/* If you are writing a PCI driver you should use COMEDI_PCI_INITCLEANUP
+ * instead.
+ */
 /* COMEDI_PCI_INITCLEANUP(driver_skel, skel_pci_table) */
-- 
1.6.3.3



