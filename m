Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZFTUFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZFTUFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZFTUFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:05:25 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:41306 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751769AbZFTUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:05:24 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jun 2009 16:05:23 EDT
Subject: 
From: Kay Sievers <kay.sievers@suse.de>
To: Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 21:45:24 +0200
Message-Id: <1245527124.30962.14.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The final piece of the driver core name limit. We are about to remove
BUS_ID_SIZE.

Some patches may still be in your queue. Just to make sure, we will
finish our task this time: David, David, James, Takashi, can you please
give an update, or take care of removing the last instances, or let me
know if you want a patch, or let us know, if we should just change it to
"20".

  $ find . -name "*.[ch]" | xargs grep '[^_]BUS_ID_SIZE'
  ./drivers/mtd/nand/txx9ndfmc.c:	char mtdname[BUS_ID_SIZE + 2];
  ./drivers/scsi/scsi_transport_fc.c:	char bsg_name[BUS_ID_SIZE]; /*20*/
  ./arch/sparc/kernel/vio.c:	if (strlen(bus_id_name) >= BUS_ID_SIZE - 4) {
  ./sound/soc/txx9/txx9aclc.c:	char devname[BUS_ID_SIZE + 2];

Thanks a lot,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver Core: remove BUS_ID_SIZE

The name size limit is gone from the driver-core, this is
the removal of the last left-over.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 include/linux/device.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,8 +25,6 @@
 #include <asm/atomic.h>
 #include <asm/device.h>
 
-#define BUS_ID_SIZE		20
-
 struct device;
 struct device_private;
 struct device_driver;

