Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab0BYUks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:40:48 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56579 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab0BYUkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:40:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FsDGNksFMvLflijGPqQY+zDHZc4l1DXhmuydUnLY3Y4+FUVvmqeBcWRc/w+2rQ2YuB
         cx3lStfx0uH0xCa/C3BN1PhFt7x7YEXG8L0ERO06gFTqatFfG3ywOdxESi+5GwJF5AmZ
         R+onFuyHdefVzOMPQGDWANy/GrNx2QawxxtnU=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, sgayda2@uiuc.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: comedi: poc: Adding some KERN_ facility level
Date: Thu, 25 Feb 2010 17:40:28 -0300
Message-Id: <1267130428-14175-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some coding style issues like include KERN_ facility levels
in some printk() and one trailing whitespace error.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/comedi/drivers/poc.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index 207d5ee..e15fbd7 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -122,22 +122,21 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	unsigned int iosize;
 
 	iobase = it->options[0];
-	printk("comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
+	printk(KERN_INFO "comedi%d: poc: using %s iobase 0x%lx\n", dev->minor,
 	       this_board->name, iobase);
 
 	dev->board_name = this_board->name;
 
 	if (iobase == 0) {
-		printk("io base address required\n");
+		printk(KERN_ERR "io base address required\n");
 		return -EINVAL;
 	}
 
 	iosize = this_board->iosize;
 	/* check if io addresses are available */
 	if (!request_region(iobase, iosize, "dac02")) {
-		printk
-		    ("I/O port conflict: failed to allocate ports 0x%lx to "
-					"0x%lx\n", iobase, iobase + iosize - 1);
+		printk(KERN_ERR "I/O port conflict: failed to allocate ports "
+			"0x%lx to 0x%lx\n", iobase, iobase + iosize - 1);
 		return -EIO;
 	}
 	dev->iobase = iobase;
@@ -158,7 +157,7 @@ static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_bits = this_board->insnbits;
 	if (s->type == COMEDI_SUBD_AO || s->type == COMEDI_SUBD_DO)
 		s->subdev_flags = SDF_WRITABLE;
-	
+
 	return 0;
 }
 
-- 
1.5.6.3

