Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYJ0A1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYJ0A1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 20:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYJ0A1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 20:27:41 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:53219 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYJ0A1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 20:27:40 -0400
Date: Mon, 27 Oct 2008 08:27:32 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: linux-mm <linux-mm@kvack.org>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH/RESEND] mm: Fix problem of parameter in note
Message-ID: <20081027002732.GA6363@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'current' is a pointer, so the right form is  'down_write(&current->mm->mmap_sem)'.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 mm/mmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 74f4d15..3183990 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -904,7 +904,7 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
 #endif /* CONFIG_PROC_FS */
 
 /*
- * The caller must hold down_write(current->mm->mmap_sem).
+ * The caller must hold down_write(&current->mm->mmap_sem).
  */
 
 unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
-- 
1.5.6.3

