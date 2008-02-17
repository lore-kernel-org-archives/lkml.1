Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYBQC66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYBQC66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYBQC5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:57:49 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36246 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYBQC5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:57:45 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/17] Unionfs: document behavior when the lower topology changes
Date: Sat, 16 Feb 2008 21:57:12 -0500
Message-Id: <1203217048256-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
References: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 Documentation/filesystems/unionfs/concepts.txt |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/unionfs/concepts.txt b/Documentation/filesystems/unionfs/concepts.txt
index bed69bd..8d9a1c5 100644
--- a/Documentation/filesystems/unionfs/concepts.txt
+++ b/Documentation/filesystems/unionfs/concepts.txt
@@ -210,4 +210,17 @@ there's a lot of concurrent activity on both the upper and lower objects,
 for the same file(s).  Lastly, this delayed time attribute detection is
 similar to how NFS clients operate (e.g., acregmin).
 
+Finally, there is no way currently in Linux to prevent lower directories
+from being moved around (i.e., topology changes); there's no way to prevent
+modifications to directory sub-trees of whole file systems which are mounted
+read-write.  It is therefore possible for in-flight operations in unionfs to
+take place, while a lower directory is being moved around.  Therefore, if
+you try to, say, create a new file in a directory through unionfs, while the
+directory is being moved around directly, then the new file may get created
+in the new location where that directory was moved to.  This is a somewhat
+similar behaviour in NFS: an NFS client could be creating a new file while
+th NFS server is moving th directory around; the file will get successfully
+created in the new location.  (The one exception in unionfs is that if the
+branch is marked read-only by unionfs, then a copyup will take place.)
+
 For more information, see <http://unionfs.filesystems.org/>.
-- 
1.5.2.2

