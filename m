Return-Path: <linux-kernel-owner+w=401wt.eu-S932120AbZHMT7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbZHMT7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbZHMT7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:38 -0400
Received: from kroah.org ([198.145.64.141]:41708 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbZHMT7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:28 2009
Message-Id: <20090813195128.100947730@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       John Stoffel <john@stoffel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 24/74] Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stoffel <john@stoffel.org>

commit 14d9fa352592582e457cf75022202766baac1348 upstream.

Make Block Layer SG support v4 the default, since recent udev versions
depend on this to access serial numbers and other low level info properly.

This should be backported to older kernels as well, since most distros have
enabled this for a long time.

Signed-off-by: John Stoffel <john@stoffel.org>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/Kconfig |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/block/Kconfig
+++ b/block/Kconfig
@@ -45,9 +45,9 @@ config LBD
 	  If unsure, say N.
 
 config BLK_DEV_BSG
-	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	---help---
+	bool "Block layer SG support v4"
+	default y
+	help
 	  Saying Y here will enable generic SG (SCSI generic) v4 support
 	  for any block device.
 
@@ -57,7 +57,10 @@ config BLK_DEV_BSG
 	  protocols (e.g. Task Management Functions and SMP in Serial
 	  Attached SCSI).
 
-	  If unsure, say N.
+	  This option is required by recent UDEV versions to properly
+	  access device serial numbers, etc.
+
+	  If unsure, say Y.
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"


