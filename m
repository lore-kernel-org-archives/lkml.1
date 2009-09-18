Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZIRCZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZIRCZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZIRCZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:25:37 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:23990 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbZIRCZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:25:34 -0400
Message-ID: <4AB2EFD2.3080001@oracle.com>
Date: Thu, 17 Sep 2009 19:26:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Jianjun Kong <jianjun@zeuux.org>
Subject: [PATCH 2/3] mm: Fix problem of parameter in note
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt014.oracle.com [141.146.116.23]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AB2EF96.00E4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianjun Kong <jianjun@zeuux.org>
Subject: mm: Fix problem of parameter in note

'current' is a pointer, so the right form is  'down_write(&current->mm->mmap_sem)'.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2631-rc7.orig/mm/mmap.c
+++ lnx-2631-rc7/mm/mmap.c
@@ -905,7 +905,7 @@ void vm_stat_account(struct mm_struct *m
 #endif /* CONFIG_PROC_FS */
 
 /*
- * The caller must hold down_write(current->mm->mmap_sem).
+ * The caller must hold down_write(&current->mm->mmap_sem).
  */
 
 unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
