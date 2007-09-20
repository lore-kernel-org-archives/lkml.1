Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXITHFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXITHFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbXITHFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:65209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbXITHFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=rw8RyXxs/OryqQ7XO9kd5qEuAf4zASU4BxLBF7o2+QbR/IkPfmSk8L8BrgvXw/2HLqtJqVOwTE1HSFTT0nUWXXbumjRJ2sMZ0Ic+CxslX5XNVYV8pDu3ogfVdQ75cNQPW/yx3W53JNPtLPdHZbDuysKNVsYk0D6Y6tT8/rbuvwg=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 02/15] sysfs: fix comments of sysfs_add/remove_one()
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:09 +0900
Message-Id: <1190271909482-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_add/remove_one() now link and unlink the target dirent into and
from the children list.  Update comments accordingly.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index da4bb66..e85206c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -410,10 +410,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  *	@sd: sysfs_dirent to be added
  *
  *	Get @acxt->parent_sd and set sd->s_parent to it and increment
- *	nlink of parent inode if @sd is a directory.  @sd is NOT
- *	linked into the children list of the parent.  The caller
- *	should invoke sysfs_link_sibling() after this function
- *	completes if @sd needs to be on the children list.
+ *	nlink of parent inode if @sd is a directory and link into the
+ *	children list of the parent.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -449,9 +447,7 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  *	@sd: sysfs_dirent to be added
  *
  *	Mark @sd removed and drop nlink of parent inode if @sd is a
- *	directory.  @sd is NOT unlinked from the children list of the
- *	parent.  The caller is repsonsible for removing @sd from the
- *	children list before calling this function.
+ *	directory.  @sd is unlinked from the children list.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
-- 
1.5.0.3


