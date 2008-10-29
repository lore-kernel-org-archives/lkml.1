Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYJ2R01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYJ2R01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 13:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYJ2R0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 13:26:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55913 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYJ2R0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 13:26:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: hjk@linutronix.de, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UIO: only call pgprot_noncached if defined
Date: Wed, 29 Oct 2008 13:26:17 -0400
Message-Id: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all arches support pgprot_noncached (like the Blackfin port).  Other
drivers seem to handle this by checking to see if it is defined, so let's
do that in the UIO driver as well.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/uio/uio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index f9b4647..c43dbea 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -529,7 +529,9 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 
 	vma->vm_flags |= VM_IO | VM_RESERVED;
 
+#ifdef pgprot_noncached
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+#endif
 
 	return remap_pfn_range(vma,
 			       vma->vm_start,
-- 
1.6.0.2

