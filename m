Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXCSUGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXCSUGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXCSUGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:06:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44075 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbXCSUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:05:59 -0400
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 5/7] change_protection for hugetlb
Date: Mon, 19 Mar 2007 13:05:55 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <20070319200555.17168.14817.stgit@localhost.localdomain>
In-Reply-To: <20070319200502.17168.17175.stgit@localhost.localdomain>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
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
index 198efa7..3de5d93 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -569,6 +569,7 @@ static const struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.copy_vma		= copy_hugetlb_page_range,
 	.pin_pages		= follow_hugetlb_page,
 	.unmap_page_range	= unmap_hugepage_range,
+	.change_protection	= hugetlb_change_protection,
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
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
