Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbZFQNgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbZFQNgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZFQNg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:36:29 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:6676
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752459AbZFQNg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:36:28 -0400
Message-ID: <4A38F15C.5050204@panasas.com>
Date: Wed, 17 Jun 2009 16:36:28 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Garzik <jeff@garzik.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>,
       open-osd mailing-list <osd-dev@open-osd.org>
Subject: [PATCH][SQUASHME] osdblk is dependent on SCSI_OSD_ULD
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>	<4A37CC79.5000907@oracle.com>	<4A38E55E.7050006@panasas.com> <20090617231250.4aefe5e8.sfr@canb.auug.org.au>
In-Reply-To: <20090617231250.4aefe5e8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 13:36:31.0999 (UTC) FILETIME=[A02548F0:01C9EF50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will be squashing the below patch into the osdblk patch and will
rebase the "linux-next" branch. (No one is dependent on this branch
so there is no reason not too)

---
Stephen Rothwell wrote:
When
CONFIG_BLK_DEV_OSD=y
CONFIG_SCSI_OSD_INITIATOR=y
\# CONFIG_SCSI_OSD_ULD is not set

build fails with:
drivers/built-in.o: In function `class_osdblk_remove':
osdblk.c:(.text+0x55376): undefined reference to `osduld_put_device'
drivers/built-in.o: In function `class_osdblk_add':
osdblk.c:(.text+0x5564d): undefined reference to `osduld_path_lookup'
osdblk.c:(.text+0x5584d): undefined reference to `osduld_put_device'

Fix by setting the proper dependency for this driver

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/block/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 2f55a4b..1d886e0 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -300,7 +300,7 @@ config BLK_DEV_NBD
 
 config BLK_DEV_OSD
 	tristate "OSD object-as-blkdev support"
-	depends on SCSI_OSD_INITIATOR
+	depends on SCSI_OSD_ULD
 	---help---
 	  Saying Y or M here will allow the exporting of a single SCSI
 	  OSD (object-based storage) object as a Linux block device.
-- 
1.6.2.1
