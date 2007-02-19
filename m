Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbXBSSdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbXBSSdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbXBSSct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:32:49 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37851 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbXBSSc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:32:27 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 5/7] change_protection for hugetlb
Date: Mon, 19 Feb 2007 10:32:16 -0800
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, agl@us.ibm.com
Message-Id: <20070219183216.27318.81665.stgit@localhost.localdomain>
In-Reply-To: <20070219183123.27318.27319.stgit@localhost.localdomain>
References: <20070219183123.27318.27319.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 fs/hugetlbfs/inode.c |    1 +
 mm/mprotect.c        |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 146a4b7..1016694 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -566,6 +566,7 @@ static struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.copy_vma		= copy_hugetlb_page_range,
 	.pin_pages		= follow_hugetlb_page,
 	.unmap_page_range	= unmap_hugepage_range,
+	.change_protection	= hugetlb_change_protection,
 };
 
 static struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 3b8f3c0..172e204 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -201,8 +201,9 @@ success:
 		dirty_accountable = 1;
 	}
 
-	if (is_vm_hugetlb_page(vma))
-		hugetlb_change_protection(vma, start, end, vma->vm_page_prot);
+	if (has_pt_op(vma, change_protection))
+		pt_op(vma, change_protection)(vma, start, end,
+			vma->vm_page_prot);
 	else
 		change_protection(vma, start, end, vma->vm_page_prot, dirty_accountable);
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
