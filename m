Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0BVDqk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 22:46:40 -0500
Received: from xenotime.net ([72.52.64.118]:59406 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754551Ab0BVDqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 22:46:38 -0500
Date: Sun, 21 Feb 2010 19:46:36 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-next@vger.kernel.org, akpm <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: [PATCH -next] scsi: RAID_ATTRS depends on SCSI
Message-Id: <20100221194636.ef885e5a.rdunlap@xenotime.net>
In-Reply-To: <4B7EC8AE.60200@oracle.com>
References: <20100219174711.5e7cc7be.sfr@canb.auug.org.au>
	<4B7EC8AE.60200@oracle.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

raid_class uses scsi interfaces, so it should depend on SCSI.
Otherwise build errors occur when RAID_ATTRS=y and SCSI=m:

ERROR: "raid_class_release" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
ERROR: "raid_class_attach" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-next-20100219.orig/drivers/scsi/Kconfig
+++ linux-next-20100219/drivers/scsi/Kconfig
@@ -1,12 +1,5 @@
 menu "SCSI device support"
 
-config RAID_ATTRS
-	tristate "RAID Transport Class"
-	default n
-	depends on BLOCK
-	---help---
-	  Provides RAID
-
 config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
@@ -34,6 +27,13 @@ config SCSI_DMA
 	bool
 	default n
 
+config RAID_ATTRS
+	tristate "RAID Transport Class"
+	default n
+	depends on BLOCK && SCSI
+	---help---
+	  Provides RAID
+
 config SCSI_TGT
 	tristate "SCSI target support"
 	depends on SCSI && EXPERIMENTAL
