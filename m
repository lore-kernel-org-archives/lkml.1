Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbZI1WJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbZI1WJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZI1WJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:09:52 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:39790 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZI1WJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oTw26xTfBharIQEX94eeXiTY6qIu81rsnzN25OSYy6tJ5g0sG4u7f5A9xPvaHs6U+v
         snD7DhwWKhG2ej7hJO7/yjgo5bIdvW3gU55H4Fg9y/PMPF44EDvKum78/auy7L2fMoCQ
         7S8Vf/4lNbDYOyfXH247SnTDX1rJfdqAMm8Ow=
Message-ID: <4AC1343D.3040606@gmail.com>
Date: Mon, 28 Sep 2009 15:10:05 -0700
From: Bruce Jones <brucej97223@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: gregkh@suse.de
CC: wfp5@virginia.edu, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Updated: [PATCH] staging: comedi: CodingStyle cleanup for drivers/acl7225b.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated based on feedback from Joe, thanks Joe!

	-- brucej

---------------

Cleanup the printk's in this driver to use KERN_foo log
levels.
---
 drivers/staging/comedi/drivers/acl7225b.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index c3652ef..8086903 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -94,10 +94,10 @@ static int acl7225b_attach(struct comedi_device *dev,
 
 	iobase = it->options[0];
 	iorange = this_board->io_range;
-	printk("comedi%d: acl7225b: board=%s 0x%04x ", dev->minor,
+	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
 	       this_board->name, iobase);
 	if (!request_region(iobase, iorange, "acl7225b")) {
-		printk("I/O port conflict\n");
+		printk(KERN_CONT "I/O port conflict\n");
 		return -EIO;
 	}
 	dev->board_name = this_board->name;
@@ -137,14 +137,12 @@ static int acl7225b_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->private = (void *)ACL7225_DI_LO;
 
-	printk("\n");
-
 	return 0;
 }
 
 static int acl7225b_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: acl7225b: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: acl7225b: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, this_board->io_range);
-- 
1.6.5.rc2
