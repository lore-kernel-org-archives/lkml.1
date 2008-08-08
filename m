Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYHHWcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYHHWcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbYHHWcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:32:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:63045 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYHHWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JNYmljl9qcQyNUdTCHdzale/nNRn2i2mjGI/Xfquq7MrbdhqoPTIuz/QAjOXQ77Rcw
         JAzFzhqyS+JEpDUw2dh8BPxvowH+/+1JswHs1yGrPiH5gXdJGgzaSLHnNN9rSNhbbl7M
         jAtSccvhLG6GadJ5kWNvhzWE0P1uTTiOEvrUk=
Date: Sat, 9 Aug 2008 02:32:28 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: akpm@linux-foundation.org, thomas.petazzoni@free-electrons.com,
       linux-kernel@vger.kernel.org, swhiteho@redhat.com,
       cluster-devel@redhat.com
Subject: [PATCH -mm] fs.h: fix build error with !CONFIG_FILE_LOCKING
Message-ID: <20080808223228.GC5093@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure it is a right way to fix it, please review.
Commit 4a70917f881a38ae688c98be9396f0a38f559094
(configure-out-file-locking-features) changed behaviour.

From: Alexander Beregalov <a.beregalov@gmail.com>

fs.h: fix build error with !CONFIG_FILE_LOCKING

fs/gfs2/ops_file.c:585: error: implicit declaration of function 'generic_setlease'
fs/gfs2/ops_file.c:637: error: implicit declaration of function '__mandatory_lock'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 include/linux/fs.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index e9a7a7d..42d9ff9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1051,6 +1051,8 @@ extern struct seq_operations locks_seq_operations;
 #define flock_lock_file_wait(a, b) (-ENOLCK)
 #define __break_lease(a, b) (0)
 #define lease_get_mtime(a, b)
+#define generic_setlease(a, b, c) (0)
+#define vfs_setlease(a, b, c) (0)
 #define lock_may_read(a, b, c) (1)
 #define lock_may_write(a, b, c) (1)
 #endif /* !CONFIG_FILE_LOCKING */
@@ -1647,6 +1649,7 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 #else /* !CONFIG_FILE_LOCKING */
 #define locks_mandatory_locked(a) (0)
 #define locks_mandatory_area(a, b, c, d, e) (0)
+#define __mandatory_lock(a) (0)
 #define mandatory_lock(a) (0)
 #define locks_verify_locked(a) (0)
 #define locks_verify_truncate(a, b, c) (0)
