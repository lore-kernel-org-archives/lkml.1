Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZG0Q0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZG0Q0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZG0Q0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:26:43 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:54017 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZG0Q0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:26:42 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       bhalevy@panasas.com, bharrosh@panasas.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: some small fixes in exofs documentation
Date: Mon, 27 Jul 2009 13:26:32 -0300
Message-Id: <1248711992-11183-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add exofs.txt to filesystems Documentation index and fix some typos,
identation and grammar.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/filesystems/00-INDEX  |    2 ++
 Documentation/filesystems/exofs.txt |   23 ++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
index f15621e..7001782 100644
--- a/Documentation/filesystems/00-INDEX
+++ b/Documentation/filesystems/00-INDEX
@@ -36,6 +36,8 @@ dnotify.txt
 	- info about directory notification in Linux.
 ecryptfs.txt
 	- docs on eCryptfs: stacked cryptographic filesystem for Linux.
+exofs.txt
+	- info, usage, mount options, design about EXOFS.
 ext2.txt
 	- info, mount options and specifications for the Ext2 filesystem.
 ext3.txt
diff --git a/Documentation/filesystems/exofs.txt b/Documentation/filesystems/exofs.txt
index 0ced74c..abd2a9b 100644
--- a/Documentation/filesystems/exofs.txt
+++ b/Documentation/filesystems/exofs.txt
@@ -60,13 +60,13 @@ USAGE
 
    mkfs.exofs --pid=65536 --format /dev/osd0
 
-   The --format is optional if not specified no OSD_FORMAT will be
-   preformed and a clean file system will be created in the specified pid,
+   The --format is optional. If not specified, no OSD_FORMAT will be
+   performed and a clean file system will be created in the specified pid,
    in the available space of the target. (Use --format=size_in_meg to limit
    the total LUN space available)
 
-   If pid already exist it will be deleted and a new one will be created in it's
-   place. Be careful.
+   If pid already exists, it will be deleted and a new one will be created in
+   its place. Be careful.
 
    An exofs lives inside a single OSD partition. You can create multiple exofs
    filesystems on the same device using multiple pids.
@@ -81,7 +81,7 @@ USAGE
 
 7. For reference (See do-exofs example script):
 	do-exofs start - an example of how to perform the above steps.
-	do-exofs stop -  an example of how to unmount the file system.
+	do-exofs stop - an example of how to unmount the file system.
 	do-exofs format - an example of how to format and mkfs a new exofs.
 
 8. Extra compilation flags (uncomment in fs/exofs/Kbuild):
@@ -104,8 +104,8 @@ Where:
     exofs specific options: Options are separated by commas (,)
 		pid=<integer> - The partition number to mount/create as
                                 container of the filesystem.
-                                This option is mandatory
-                to=<integer>  - Timeout in ticks for a single command
+                                This option is mandatory.
+                to=<integer>  - Timeout in ticks for a single command.
                                 default is (60 * HZ) [for debugging only]
 
 ===============================================================================
@@ -116,7 +116,7 @@ DESIGN
   with a special ID (defined in common.h).
   Information included in the file system control block is used to fill the
   in-memory superblock structure at mount time. This object is created before
-  the file system is used by mkexofs.c It contains information such as:
+  the file system is used by mkexofs.c. It contains information such as:
 	- The file system's magic number
 	- The next inode number to be allocated
 
@@ -134,8 +134,8 @@ DESIGN
   attributes. This applies to both regular files and other types (directories,
   device files, symlinks, etc.).
 
-* Credentials are generated per object (inode and superblock) when they is
-  created in memory (read off disk or created). The credential works for all
+* Credentials are generated per object (inode and superblock) when they are
+  created in memory (read from disk or created). The credential works for all
   operations and is used as long as the object remains in memory.
 
 * Async OSD operations are used whenever possible, but the target may execute
@@ -145,7 +145,8 @@ DESIGN
   from executing in reverse order:
 	- The following are handled with the OBJ_CREATED and OBJ_2BCREATED
 	  flags. OBJ_CREATED is set when we know the object exists on the OSD -
-	  in create's callback function, and when we successfully do a read_inode.
+	  in create's callback function, and when we successfully do a
+	  read_inode.
 	  OBJ_2BCREATED is set in the beginning of the create function, so we
 	  know that we should wait.
 		- create/delete: delete should wait until the object is created
-- 
1.6.3.3

