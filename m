Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbZDHEYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbZDHEYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 00:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZDHEYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 00:24:36 -0400
Received: from mail.renesas.com ([202.234.163.13]:58469 "EHLO
	mail03.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750716AbZDHEYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 00:24:36 -0400
X-AuditID: ac140386-0000000a00001aa8-1d-49dc26d65246
Date: Wed, 08 Apr 2009 13:23:49 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: [PATCH] vma: Fix typo vma->pg_off to vma->vm_pgoff
To: LKML <linux-kernel@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <49DC26D5.5010007@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I mistake in address of LKML.
I resend this.

---
Become compile error by 6260a4b0521a41189b2c2a8119096c1e21dbdf2c,
because changed variable name is wrong.

.....
fs/proc/task_nommu.c:138: error: 'struct vm_area_struct' has no member named 'pg_off'
distcc[21484] ERROR: compile fs/proc/task_nommu.c on sprygo/32 failed
make[3]: *** [fs/proc/task_nommu.o] Error 1
make[2]: *** [fs/proc] Error 2
make[1]: *** [fs] Error 2
make: *** [sub-make] Error 2
.....

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/task_nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 12c2037..64a72e2 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -135,7 +135,7 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 		struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 		dev = inode->i_sb->s_dev;
 		ino = inode->i_ino;
-		pgoff = (loff_t)vma->pg_off << PAGE_SHIFT;
+		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	}

 	seq_printf(m,
-- 1.6.2.2

