Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbZISWpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbZISWpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbZISWpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:45:24 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:63436 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbZISWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:45:22 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net
Subject: [PATCH 2/2] 9p: Update documentation to add fscache related bits
Date: Sat, 19 Sep 2009 16:44:43 -0600
Message-Id: <1253400283-2575-2-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253400283-2575-1-git-send-email-adkulkar@umail.iu.edu>
References: <1253400283-2575-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation to describe FS-Cache related
caching parameters. This patch also updates the pointers
to 9p-related papers and adds pointer to the Wiki.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
 Documentation/filesystems/9p.txt |   40 ++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/9p.txt b/Documentation/filesystems/9p.txt
index 6208f55..57e0b80 100644
--- a/Documentation/filesystems/9p.txt
+++ b/Documentation/filesystems/9p.txt
@@ -18,11 +18,11 @@ the 9p client is available in the form of a USENIX paper:
 
 Other applications are described in the following papers:
 	* XCPU & Clustering
-		http://www.xcpu.org/xcpu-talk.pdf
+		http://xcpu.org/papers/xcpu-talk.pdf
 	* KVMFS: control file system for KVM
-		http://www.xcpu.org/kvmfs.pdf
-	* CellFS: A New ProgrammingModel for the Cell BE
-		http://www.xcpu.org/cellfs-talk.pdf
+		http://xcpu.org/papers/kvmfs.pdf
+	* CellFS: A New Programming Model for the Cell BE
+		http://xcpu.org/papers/cellfs-talk.pdf
 	* PROSE I/O: Using 9p to enable Application Partitions
 		http://plan9.escet.urjc.es/iwp9/cready/PROSE_iwp9_2006.pdf
 
@@ -48,6 +48,7 @@ OPTIONS
                                 (see rfdno and wfdno)
 			virtio	- connect to the next virtio channel available
 				(from lguest or KVM with trans_virtio module)
+			rdma	- connect to a specified RDMA channel
 
   uname=name	user name to attempt mount as on the remote server.  The
   		server may override or ignore this value.  Certain user
@@ -59,16 +60,22 @@ OPTIONS
   cache=mode	specifies a caching policy.  By default, no caches are used.
 			loose = no attempts are made at consistency,
                                 intended for exclusive, read-only mounts
+			fscache = use FS-Cache for a persistent, read-only
+				cache backend.
 
   debug=n	specifies debug level.  The debug level is a bitmask.
-  			0x01 = display verbose error messages
-			0x02 = developer debug (DEBUG_CURRENT)
-			0x04 = display 9p trace
-			0x08 = display VFS trace
-			0x10 = display Marshalling debug
-			0x20 = display RPC debug
-			0x40 = display transport debug
-			0x80 = display allocation debug
+			0x01  = display verbose error messages
+			0x02  = developer debug (DEBUG_CURRENT)
+			0x04  = display 9p trace
+			0x08  = display VFS trace
+			0x10  = display Marshalling debug
+			0x20  = display RPC debug
+			0x40  = display transport debug
+			0x80  = display allocation debug
+			0x100 = display protocol message debug
+			0x200 = display Fid debug
+			0x400 = display packet debug
+			0x800 = display fscache tracing debug
 
   rfdno=n	the file descriptor for reading with trans=fd
 
@@ -100,6 +107,10 @@ OPTIONS
 			any   = v9fs does single attach and performs all
 				operations as one user
 
+  cachetag	cache tag to use the specified persistent cache.
+		cache tags for existing cache sessions can be listed at
+		/sys/fs/9p/caches. (applies only to cache=fscache)
+
 RESOURCES
 =========
 
@@ -118,7 +129,7 @@ and export.
 A Linux version of the 9p server is now maintained under the npfs project
 on sourceforge (http://sourceforge.net/projects/npfs).  The currently
 maintained version is the single-threaded version of the server (named spfs)
-available from the same CVS repository.
+available from the same SVN repository.
 
 There are user and developer mailing lists available through the v9fs project
 on sourceforge (http://sourceforge.net/projects/v9fs).
@@ -126,7 +137,8 @@ on sourceforge (http://sourceforge.net/projects/v9fs).
 A stand-alone version of the module (which should build for any 2.6 kernel)
 is available via (http://github.com/ericvh/9p-sac/tree/master)
 
-News and other information is maintained on SWiK (http://swik.net/v9fs).
+News and other information is maintained on SWiK (http://swik.net/v9fs)
+and the Wiki (http://sf.net/apps/mediawiki/v9fs/index.php).
 
 Bug reports may be issued through the kernel.org bugzilla 
 (http://bugzilla.kernel.org)
-- 
1.6.3.3

