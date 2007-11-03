Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXKCBYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXKCBYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbXKCBX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:23:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35210 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbXKCBXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:23:16 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/8] Unionfs: update usage.txt documentation
Date: Fri,  2 Nov 2007 21:22:44 -0400
Message-Id: <11940529701438-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
References: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/usage.txt |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/unionfs/usage.txt b/Documentation/filesystems/unionfs/usage.txt
index d8c15de..a6b1aca 100644
--- a/Documentation/filesystems/unionfs/usage.txt
+++ b/Documentation/filesystems/unionfs/usage.txt
@@ -74,6 +74,23 @@ to read-write, and change /bar from read-write to read-only:
 
 # mount -t unionfs -o remount,mode=/foo=rw,mode=/bar=ro none MOUNTPOINT
 
+Note: in Unionfs 2.x, you cannot set the leftmost branch to readonly because
+then Unionfs won't have any writable place for copyups to take place.
+Moreover, the VFS can get confused when it tries to modify something in a
+file system mounted read-write, but isn't permitted to write to it.
+Instead, you should set the whole union as readonly, as described above.
+If, however, you must set the leftmost branch as readonly, perhaps so you
+can get a snapshot of it at a point in time, then you should insert a new
+writable top-level branch, and mark the one you want as readonly.  This can
+be accomplished as follows, assuming that /foo is your current leftmost
+branch:
+
+# mount -t tmpfs -o size=NNN /new
+# mount -t unionfs -o remount,add=/new,mode=/foo=ro none MOUNTPOINT
+<do what you want safely in /foo>
+# mount -t unionfs -o remount,del=/new,mode=/foo=rw none MOUNTPOINT
+<check if there's anything in /new you want to preserve>
+# umount /new
 
 CACHE CONSISTENCY
 =================
-- 
1.5.2.2

