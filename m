Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbZGMTlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbZGMTlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZGMTlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:41:45 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:54345 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZGMTlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:41:45 -0400
From: John Stoffel <john@stoffel.org>
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stoffel <john@stoffel.org>
Subject: [PATCH] Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG.
Date: Mon, 13 Jul 2009 15:41:39 -0400
Message-Id: <1247514099-25031-1-git-send-email-john@stoffel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make Block Layer SG support v4 the default, since recent udev versions 
depend on this to access serial numbers and other low level info properly.


Signed-off-by: John Stoffel <john@stoffel.org>
---
 block/Kconfig |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index e7d1278..55bbefc 100644
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
-- 
1.6.3.3

