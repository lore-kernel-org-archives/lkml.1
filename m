Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZKCJyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZKCJyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbZKCJyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:54:18 -0500
Received: from smtp.ispras.ru ([83.149.198.201]:38286 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZKCJyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:54:17 -0500
From: Vadim Mutilin <mutilin@ispras.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Vadim Mutilin <mutilin@ispras.ru>
Subject: [PATCH] STAGING: comedi: cb_das16_cs: fixing coding style errors
Date: Tue,  3 Nov 2009 12:54:18 +0300
Message-Id: <1257242058-12047-1-git-send-email-mutilin@ispras.ru>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/cb_das16_cs.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 80c0df8..1af8650 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -100,7 +100,7 @@ static struct comedi_driver driver_das16cs = {
 	.detach = das16cs_detach,
 };
 
-static struct pcmcia_device *cur_dev = NULL;
+static struct pcmcia_device *cur_dev;
 
 static const struct comedi_lrange das16cs_ai_range = { 4, {
 							   RANGE(-10, 10),
@@ -169,9 +169,8 @@ static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
 	id = get_prodid(dev, link);
 
 	for (i = 0; i < n_boards; i++) {
-		if (das16cs_boards[i].device_id == id) {
+		if (das16cs_boards[i].device_id == id)
 			return das16cs_boards + i;
-		}
 	}
 
 	printk("unknown board!\n");
@@ -197,16 +196,14 @@ static int das16cs_attach(struct comedi_device *dev,
 	printk("I/O base=0x%04lx ", dev->iobase);
 
 	printk("fingerprint:\n");
-	for (i = 0; i < 48; i += 2) {
+	for (i = 0; i < 48; i += 2)
 		printk("%04x ", inw(dev->iobase + i));
-	}
 	printk("\n");
 
 	ret = request_irq(link->irq.AssignedIRQ, das16cs_interrupt,
 			  IRQF_SHARED, "cb_das16_cs", dev);
-	if (ret < 0) {
+	if (ret < 0)
 		return ret;
-	}
 	dev->irq = link->irq.AssignedIRQ;
 	printk("irq=%u ", dev->irq);
 
@@ -284,9 +281,8 @@ static int das16cs_detach(struct comedi_device *dev)
 {
 	printk("comedi%d: das16cs: remove\n", dev->minor);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
 
 	return 0;
 }
@@ -393,7 +389,8 @@ static int das16cs_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique
+	 * and mutually compatible */
 
 	/* note that mutual compatiblity is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
@@ -672,9 +669,10 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 #ifdef PCMCIA_DEBUG
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0644);
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
+#define DEBUG(n, args...) if (pc_debug > (n)) printk(KERN_DEBUG args)
 static char *version =
-    "cb_das16_cs.c pcmcia code (David Schleef), modified from dummy_cs.c 1.31 2001/08/24 12:13:13 (David Hinds)";
+	"cb_das16_cs.c pcmcia code (David Schleef),"\
+	" modified from dummy_cs.c 1.31 2001/08/24 12:13:13 (David Hinds)";
 #else
 #define DEBUG(n, args...)
 #endif
@@ -869,7 +867,8 @@ static void das16cs_pcmcia_config(struct pcmcia_device *link)
 				link->io.BasePort2 = io->win[1].base;
 				link->io.NumPorts2 = io->win[1].len;
 			}
-			/* This reserves IO space but doesn't actually enable it */
+			/* This reserves IO space
+			 * but doesn't actually enable it */
 			if (pcmcia_request_io(link, &link->io))
 				goto next_entry;
 		}
-- 
1.6.0.4

