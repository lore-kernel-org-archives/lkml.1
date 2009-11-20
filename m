Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZKTXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZKTXqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 18:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZKTXqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 18:46:17 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:59826 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZKTXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 18:46:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pgxyJPHEws6hvcNX8XGAgpAevQiS73DH5dsnaRybXrS6DccDXhVRIO45+4yZvYyWGt
         sGmhU+TImiQtdt4eO+w5RvVMa8QZrd0DoG3O7PvaO7bQcc5hJVWKDKEot8Dphed3I4ni
         iwMqd2mY/iwJRHlungg6+RwlEGBiNQexM3y6M=
From: Bruce Beare <bbeare1@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Bruce Beare <bbeare1@gmail.com>
Subject: [PATCH 3/3] cleanup: printk() warnings for including the facility level. cleanup: add a printk("\n") to terminate the print for the non-error case.
Date: Fri, 20 Nov 2009 15:46:11 -0800
Message-Id: <1258760771-24311-4-git-send-email-bbeare1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258760771-24311-3-git-send-email-bbeare1@gmail.com>
References: <1258760771-24311-1-git-send-email-bbeare1@gmail.com>
 <1258760771-24311-2-git-send-email-bbeare1@gmail.com>
 <1258760771-24311-3-git-send-email-bbeare1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bruce Beare <bbeare1@gmail.com>
---
 drivers/staging/comedi/drivers/pcmad.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 787aea2..75b61a2 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -134,11 +134,12 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned long iobase;
 
 	iobase = it->options[0];
-	printk("comedi%d: pcmad: 0x%04lx ", dev->minor, iobase);
+	printk(KERN_NOTICE "comedi%d: pcmad: 0x%04lx ", dev->minor, iobase);
 	if (!request_region(iobase, PCMAD_SIZE, "pcmad")) {
-		printk("I/O port conflict\n");
+		printk(KERN_CONT "I/O port conflict\n");
 		return -EIO;
 	}
+	printk(KERN_CONT "\n");
 	dev->iobase = iobase;
 
 	ret = alloc_subdevices(dev, 1);
@@ -165,7 +166,7 @@ static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int pcmad_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: pcmad: remove\n", dev->minor);
+	printk(KERN_NOTICE "comedi%d: pcmad: remove\n", dev->minor);
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-- 
1.6.2.5

