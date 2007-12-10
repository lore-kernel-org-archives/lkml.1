Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXLJC6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXLJC6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbXLJCpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:45:04 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49735 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbXLJCnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:02 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 06/42] Unionfs: documentation about renaming operations
Date: Sun,  9 Dec 2007 21:41:39 -0500
Message-Id: <11972545383828-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/rename.txt |   31 ++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/unionfs/rename.txt

diff --git a/Documentation/filesystems/unionfs/rename.txt b/Documentation/filesystems/unionfs/rename.txt
new file mode 100644
index 0000000..e20bb82
--- /dev/null
+++ b/Documentation/filesystems/unionfs/rename.txt
@@ -0,0 +1,31 @@
+Rename is a complex beast. The following table shows which rename(2) operations
+should succeed and which should fail.
+
+o: success
+E: error (either unionfs or vfs)
+X: EXDEV
+
+none = file does not exist
+file = file is a file
+dir  = file is a empty directory
+child= file is a non-empty directory
+wh   = file is a directory containing only whiteouts; this makes it logically
+		empty
+
+                      none    file    dir     child   wh
+file                  o       o       E       E       E
+dir                   o       E       o       E       o
+child                 X       E       X       E       X
+wh                    o       E       o       E       o
+
+
+Renaming directories:
+=====================
+
+Whenever a empty (either physically or logically) directory is being renamed,
+the following sequence of events should take place:
+
+1) Remove whiteouts from both source and destination directory
+2) Rename source to destination
+3) Make destination opaque to prevent anything under it from showing up
+
-- 
1.5.2.2

