Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab0CJFgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:36:53 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:41097 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0CJFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:36:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gb9VlvqshH6S1X38VPcJMbI+Bx5/Mj+lH+wByenhuNNMvv9TZHEy6vufkWTcgEuEhs
         74rrPHHU0avq1JKMDh8mGScVbTz4mK8oDOAcPxhJDn8zUYHeAUloxnZLWHmV4hihhVCd
         5xA4hd6S0VG+3JsyF1JRNlMYPYd0fdDK21oC0=
From: rich.folsom@gmail.com
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fix brace coding style issue in adl_pci9111.c This is a patch to the adl_pci9111.c to fix up a brace warnging found by the checkpatch.pl tool Signed-off-by:  Rich Folsom <rich.folsom@gmail.com>
Date: Tue,  9 Mar 2010 23:36:45 -0600
Message-Id: <1268199405-23231-1-git-send-email-rich.folsom@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rich Folsom <rich@rich-laptop.(none)>

---
 drivers/staging/comedi/drivers/adl_pci9111.c |   30 +++++++++----------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index da172a5..d8acdbe 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -585,19 +585,17 @@ pci9111_ai_do_cmd_test(struct comedi_device *dev,
 	    (cmd->scan_begin_src != TRIG_EXT))
 		error++;
 
-	if ((cmd->convert_src != TRIG_TIMER) && (cmd->convert_src != TRIG_EXT)) {
+	if ((cmd->convert_src != TRIG_TIMER) && (cmd->convert_src != TRIG_EXT))
 		error++;
-	}
 	if ((cmd->convert_src == TRIG_TIMER) &&
 	    !((cmd->scan_begin_src == TRIG_TIMER) ||
-	      (cmd->scan_begin_src == TRIG_FOLLOW))) {
+	      (cmd->scan_begin_src == TRIG_FOLLOW)))
 		error++;
-	}
 	if ((cmd->convert_src == TRIG_EXT) &&
 	    !((cmd->scan_begin_src == TRIG_EXT) ||
-	      (cmd->scan_begin_src == TRIG_FOLLOW))) {
+	      (cmd->scan_begin_src == TRIG_FOLLOW)))
 		error++;
-	}
+
 
 	if (cmd->scan_end_src != TRIG_COUNT)
 		error++;
@@ -1067,9 +1065,8 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 
 	pci9111_ai_channel_set(CR_CHAN((&insn->chanspec)[0]));
 
-	if ((pci9111_ai_range_get()) != CR_RANGE((&insn->chanspec)[0])) {
+	if ((pci9111_ai_range_get()) != CR_RANGE((&insn->chanspec)[0]))
 		pci9111_ai_range_set(CR_RANGE((&insn->chanspec)[0]));
-	}
 
 	pci9111_fifo_reset();
 
@@ -1090,11 +1087,10 @@ static int pci9111_ai_insn_read(struct comedi_device *dev,
 
 conversion_done:
 
-		if (resolution == PCI9111_HR_AI_RESOLUTION) {
+		if (resolution == PCI9111_HR_AI_RESOLUTION)
 			data[i] = pci9111_hr_ai_get_data();
-		} else {
+		else
 			data[i] = pci9111_ai_get_data();
-		}
 	}
 
 #ifdef AI_INSN_DEBUG
@@ -1131,9 +1127,8 @@ static int pci9111_ao_insn_read(struct comedi_device *dev,
 {
 	int i;
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = dev_private->ao_readback & PCI9111_AO_RESOLUTION_MASK;
-	}
 
 	return i;
 }
@@ -1222,9 +1217,8 @@ static int pci9111_attach(struct comedi_device *dev,
 	int error, i;
 	const struct pci9111_board *board;
 
-	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0) {
+	if (alloc_private(dev, sizeof(struct pci9111_private_data)) < 0)
 		return -ENOMEM;
-	}
 	/*  Probe the device to determine what device in the series it is. */
 
 	printk("comedi%d: " PCI9111_DRIVER_NAME " driver\n", dev->minor);
@@ -1394,14 +1388,12 @@ static int pci9111_detach(struct comedi_device *dev)
 	}
 	/*  Release previously allocated irq */
 
-	if (dev->irq != 0) {
+	if (dev->irq != 0)
 		free_irq(dev->irq, dev);
-	}
 
 	if (dev_private != 0 && dev_private->pci_device != 0) {
-		if (dev->iobase) {
+		if (dev->iobase)
 			comedi_pci_disable(dev_private->pci_device);
-		}
 		pci_dev_put(dev_private->pci_device);
 	}
 
-- 
1.6.3.3

