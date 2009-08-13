Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZHMTrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZHMTrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZHMTrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:46 -0400
Received: from kroah.org ([198.145.64.141]:36706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbZHMTro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:36 2009
Message-Id: <20090813194336.150760760@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       John Stoffel <john@stoffel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 05/28] Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -67,9 +67,9 @@ config LSF
 	  If unsure, say Y.
 
 config BLK_DEV_BSG
-	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	---help---
+	bool "Block layer SG support v4"
+	default y
+	help
 	  Saying Y here will enable generic SG (SCSI generic) v4 support
 	  for any block device.
 
@@ -79,7 +79,10 @@ config BLK_DEV_BSG
 	  protocols (e.g. Task Management Functions and SMP in Serial
 	  Attached SCSI).
 
-	  If unsure, say N.
+	  This option is required by recent UDEV versions to properly
+	  access device serial numbers, etc.
+
+	  If unsure, say Y.
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"


