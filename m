Return-Path: <linux-kernel-owner+w=401wt.eu-S1030769AbXDLV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030769AbXDLV1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030775AbXDLV1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:27:46 -0400
Received: from palrel11.hp.com ([156.153.255.246]:43404 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030769AbXDLV1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:27:45 -0400
Date: Thu, 12 Apr 2007 16:27:41 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: akpm@linux-foundation.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       steve.cameron@hp.com
Subject: [PATCH 1/1] cciss: kconfig patch to make cciss dependent on scsi for SG_IO ioctl
Message-ID: <20070412212741.GA10654@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PATCH 1/1

This kconfig patch makes cciss dependent on scsi for the new SG_IO ioctl we just
added. If cciss is built into the kernel it makes sures that scsi is also statically
linked. If scsi is a module then cciss will also be built as a module. Please consider
this for inclusion.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>
------------------------------------------------------------------------------------------

 block/cciss.c         |    0 
 drivers/block/Kconfig |    2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss_sg_io_kconfig drivers/block/cciss.c
diff -puN drivers/block/Kconfig~cciss_sg_io_kconfig drivers/block/Kconfig
--- linux-2.6.21-rc6/drivers/block/Kconfig~cciss_sg_io_kconfig	2007-04-12 08:16:45.000000000 -0500
+++ linux-2.6.21-rc6-scameron/drivers/block/Kconfig	2007-04-12 08:20:41.000000000 -0500
@@ -152,6 +152,7 @@ config BLK_CPQ_DA
 config BLK_CPQ_CISS_DA
 	tristate "Compaq Smart Array 5xxx support"
 	depends on PCI
+	depends on SCSI
 	help
 	  This is the driver for Compaq Smart Array 5xxx controllers.
 	  Everyone using these boards should say Y here.
@@ -162,7 +163,6 @@ config BLK_CPQ_CISS_DA
 config CISS_SCSI_TAPE
 	bool "SCSI tape drive support for Smart Array 5xxx"
 	depends on BLK_CPQ_CISS_DA && PROC_FS
-	depends on SCSI=y || SCSI=BLK_CPQ_CISS_DA
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medium
 	  changers (tape robots) to be accessed via a Compaq 5xxx array 
_
