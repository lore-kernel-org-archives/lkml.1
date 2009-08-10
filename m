Return-Path: <linux-kernel-owner+w=401wt.eu-S1751405AbZHJUDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbZHJUDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZHJUDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:03:46 -0400
Received: from THUNK.ORG ([69.25.196.29]:54015 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZHJUDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:03:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: [PATCH, RFC] ext3: Update Kconfig description of EXT3_DEFAULTS_TO_ORDERED
Date: Mon, 10 Aug 2009 16:03:43 -0400
Message-Id: <1249934623-15939-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old description for this configuration option was perhaps not
completely balanced in terms of describing the tradeoffs of using a
default of data=writeback vs. data=ordered.  Despite the fact that old
description very strongly recomended disabling this feature, all of
the major distributions have elected to preserve the existing 'legacy'
default, which is a strong hint that it perhaps wasn't telling the
whole story.

This revised description has been vetted by a number of ext3
developers as being better at informing the user about the tradeoffs
of enabling or disabling this configuration feature.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/Kconfig |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/ext3/Kconfig b/fs/ext3/Kconfig
index fb3c1a2..522b154 100644
--- a/fs/ext3/Kconfig
+++ b/fs/ext3/Kconfig
@@ -29,23 +29,25 @@ config EXT3_FS
 	  module will be called ext3.
 
 config EXT3_DEFAULTS_TO_ORDERED
-	bool "Default to 'data=ordered' in ext3 (legacy option)"
+	bool "Default to 'data=ordered' in ext3"
 	depends on EXT3_FS
 	help
-	  If a filesystem does not explicitly specify a data ordering
-	  mode, and the journal capability allowed it, ext3 used to
-	  historically default to 'data=ordered'.
-
-	  That was a rather unfortunate choice, because it leads to all
-	  kinds of latency problems, and the 'data=writeback' mode is more
-	  appropriate these days.
-
-	  You should probably always answer 'n' here, and if you really
-	  want to use 'data=ordered' mode, set it in the filesystem itself
-	  with 'tune2fs -o journal_data_ordered'.
-
-	  But if you really want to enable the legacy default, you can do
-	  so by answering 'y' to this question.
+	  The journal mode options for ext3 have different tradeoffs
+	  between when data is guaranteed to be on disk and
+	  performance.	The use of "data=writeback" can cause
+	  unwritten data to appear in files after an system crash or
+	  power failure, which can be a security issue.	 However,
+	  "data=ordered" mode can also result in major performance
+	  problems, including seconds-long delays before an fsync()
+	  call returns.	 For details, see:
+
+	  http://ext4.wiki.kernel.org/index.php/Ext3_data_mode_tradeoffs
+
+	  If you have been historically happy with ext3's performance,
+	  data=ordered mode will be a safe choice and you should
+	  answer 'y' here.  If you understand the reliability and data
+	  privacy issues of data=writeback and are willing to make
+	  that trade off, answer 'n'.
 
 config EXT3_FS_XATTR
 	bool "Ext3 extended attributes"
-- 
1.6.3.2.1.gb9f7d.dirty

