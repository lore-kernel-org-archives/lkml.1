Return-Path: <linux-kernel-owner+w=401wt.eu-S932930AbXLNPuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbXLNPuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762858AbXLNPtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:49:15 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55759 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762219AbXLNPtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:49:12 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Jim Kissel <jlk@osml.eu>
Subject: [PATCH 2/2] Unionfs: clarify usage.txt mount options
Date: Fri, 14 Dec 2007 10:48:01 -0500
Message-Id: <11976472822359-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11976472813872-git-send-email-ezk@cs.sunysb.edu>
References: <11976472813872-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Jim Kissel <jlk@osml.eu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/usage.txt |   38 +++++++++++++++++++--------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/Documentation/filesystems/unionfs/usage.txt b/Documentation/filesystems/unionfs/usage.txt
index a6b1aca..59c4f28 100644
--- a/Documentation/filesystems/unionfs/usage.txt
+++ b/Documentation/filesystems/unionfs/usage.txt
@@ -7,17 +7,32 @@ read-write branches, as well as insertion and deletion of branches anywhere
 in the fan-out.  To maintain Unix semantics, Unionfs handles elimination of
 duplicates, partial-error conditions, and more.
 
-# mount -t unionfs -o branch-option[,union-options[,...]] none MOUNTPOINT
+GENERAL SYNTAX
+==============
 
-The available branch-option for the mount command is:
+# mount -t unionfs -o <OPTIONS>,<BRANCH-OPTIONS> none MOUNTPOINT
+
+OPTIONS can be any legal combination one of:
+
+- ro		# mount file system read-only
+- rw		# mount file system read-write
+- remount	# remount the file system (see Branch Management below)
+- incgen	# increment generation no. (see Cache Consistency below)
+
+BRANCH-OPTIONS can be either (1) a list of branches given to the "dirs="
+option, or (2) a list of individual branch manipulation commands, described
+in the "Branch Management" section below.
+
+The syntax for the "dirs=" mount option is:
 
 	dirs=branch[=ro|=rw][:...]
 
-specifies a separated list of which directories compose the union.
-Directories that come earlier in the list have a higher precedence than
-those which come later. Additionally, read-only or read-write permissions of
-the branch can be specified by appending =ro or =rw (default) to each
-directory.
+The "dirs=" option takes a colon-delimited list of directories to compose
+the union, with an optional branch mode for each of those directories.
+Directories that come earlier (specified first, on the left) in the list
+have a higher precedence than those which come later.  Additionally,
+read-only or read-write permissions of the branch can be specified by
+appending =ro or =rw (default) to each directory.
 
 Syntax:
 
@@ -28,11 +43,12 @@ Example:
 	dirs=/writable_branch=rw:/read-only_branch=ro
 
 
-DYNAMIC BRANCH MANAGEMENT AND REMOUNTS
-======================================
+BRANCH MANAGEMENT
+=================
 
-You can remount a union and change its overall mode, or reconfigure the
-branches, as follows.
+Once you mount your union for the first time, using the "dirs=" option, you
+can then change the union's overall mode or reconfigure the branches, using
+the remount option, as follows.
 
 To downgrade a union from read-write to read-only:
 
-- 
1.5.2.2

