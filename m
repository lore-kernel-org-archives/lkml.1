Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbZFJJkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbZFJJkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758136AbZFJJiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40291 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbZFJJiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/24] GFS2: Update docs
Date: Wed, 10 Jun 2009 09:30:50 +0100
Message-Id: <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update a few things which were out of date, and fix a typo.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/Documentation/filesystems/gfs2-glocks.txt b/Documentation/filesystems/gfs2-glocks.txt
index 4dae9a3..0494f78 100644
--- a/Documentation/filesystems/gfs2-glocks.txt
+++ b/Documentation/filesystems/gfs2-glocks.txt
@@ -60,7 +60,7 @@ go_lock          | Called for the first local holder of a lock
 go_unlock        | Called on the final local unlock of a lock
 go_dump          | Called to print content of object for debugfs file, or on
                  | error to dump glock to the log.
-go_type;         | The type of the glock, LM_TYPE_.....
+go_type          | The type of the glock, LM_TYPE_.....
 go_min_hold_time | The minimum hold time
 
 The minimum hold time for each lock is the time after a remote lock
diff --git a/Documentation/filesystems/gfs2.txt b/Documentation/filesystems/gfs2.txt
index 593004b..5e3ab8f 100644
--- a/Documentation/filesystems/gfs2.txt
+++ b/Documentation/filesystems/gfs2.txt
@@ -11,18 +11,15 @@ their I/O so file system consistency is maintained.  One of the nifty
 features of GFS is perfect consistency -- changes made to the file system
 on one machine show up immediately on all other machines in the cluster.
 
-GFS uses interchangable inter-node locking mechanisms.  Different lock
-modules can plug into GFS and each file system selects the appropriate
-lock module at mount time.  Lock modules include:
+GFS uses interchangable inter-node locking mechanisms, the currently
+supported mechanisms are:
 
   lock_nolock -- allows gfs to be used as a local file system
 
   lock_dlm -- uses a distributed lock manager (dlm) for inter-node locking
   The dlm is found at linux/fs/dlm/
 
-In addition to interfacing with an external locking manager, a gfs lock
-module is responsible for interacting with external cluster management
-systems.  Lock_dlm depends on user space cluster management systems found
+Lock_dlm depends on user space cluster management systems found
 at the URL above.
 
 To use gfs as a local file system, no external clustering systems are
@@ -31,13 +28,19 @@ needed, simply:
   $ mkfs -t gfs2 -p lock_nolock -j 1 /dev/block_device
   $ mount -t gfs2 /dev/block_device /dir
 
-GFS2 is not on-disk compatible with previous versions of GFS.
+If you are using Fedora, you need to install the gfs2-utils package
+and, for lock_dlm, you will also need to install the cman package
+and write a cluster.conf as per the documentation.
+
+GFS2 is not on-disk compatible with previous versions of GFS, but it
+is pretty close.
 
 The following man pages can be found at the URL above:
-  gfs2_fsck	to repair a filesystem
+  fsck.gfs2	to repair a filesystem
   gfs2_grow	to expand a filesystem online
   gfs2_jadd	to add journals to a filesystem online
   gfs2_tool	to manipulate, examine and tune a filesystem
   gfs2_quota	to examine and change quota values in a filesystem
+  gfs2_convert	to convert a gfs filesystem to gfs2 in-place
   mount.gfs2	to help mount(8) mount a filesystem
   mkfs.gfs2	to make a filesystem
-- 
1.6.0.6

