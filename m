Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbXKPCvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbXKPCvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbXKPCv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:51:29 -0500
Received: from lazybastard.de ([212.112.238.170]:35607 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbXKPCv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:51:28 -0500
Date: Fri, 16 Nov 2007 03:46:28 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Document I_SYNC and I_DATASYNC
Message-ID: <20071116024627.GI13834@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After some archeology (see http://logfs.org/logfs/inode_state_bits) I
finally figured out what the three I_DIRTY bits do.  Maybe others would
prefer less effort to reach this insight.

Signed-off-by: Jörn Engel <joern@logfs.org>
---

 include/linux/fs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- git_I_DIRTY/include/linux/fs.h~I_DIRTY	2007-11-15 20:51:57.000000000 +0100
+++ git_I_DIRTY/include/linux/fs.h	2007-11-16 03:45:16.000000000 +0100
@@ -1276,8 +1276,10 @@ struct super_operations {
  *
  * Two bits are used for locking and completion notification, I_LOCK and I_SYNC.
  *
- * I_DIRTY_SYNC		Inode itself is dirty.
- * I_DIRTY_DATASYNC	Data-related inode changes pending
+ * I_DIRTY_SYNC		Inode is dirty, but doesn't have to be written on
+ *			fdatasync().  i_atime is the usual cause.
+ * I_DIRTY_DATASYNC	Inode is dirty and must be written on fdatasync(), f.e.
+ *			because i_size changed.
  * I_DIRTY_PAGES	Inode has dirty pages.  Inode itself may be clean.
  * I_NEW		get_new_inode() sets i_state to I_LOCK|I_NEW.  Both
  *			are cleared by unlock_new_inode(), called from iget().
@@ -1309,8 +1311,6 @@ struct super_operations {
  *			purpose reduces latency and prevents some filesystem-
  *			specific deadlocks.
  *
- * Q: Why does I_DIRTY_DATASYNC exist?  It appears as if it could be replaced
- *    by (I_DIRTY_SYNC|I_DIRTY_PAGES).
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  * Q: igrab() only checks on (I_FREEING|I_WILL_FREE).  Should it also check on
  *    I_CLEAR?  If not, why?
