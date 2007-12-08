Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbXLHLDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbXLHLDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 06:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXLHLD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 06:03:29 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:61266 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXLHLD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 06:03:28 -0500
Date: Sat, 8 Dec 2007 12:02:48 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071208110455.20540.86240.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] mm/mmap: Remove sparse-warning (NULL as 0).
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing:
  CHECK   mm/mmap.c
mm/mmap.c:1623:29: warning: Using plain integer as NULL pointer
mm/mmap.c:1623:29: warning: Using plain integer as NULL pointer
mm/mmap.c:1944:29: warning: Using plain integer as NULL pointer

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Added by: 8869477a49c3e99def1fcdadd6bbc407fea14b45 (Linus' tree)
Compile-tested on i386 with all[yes|mod|no]config.


diff --git a/mm/mmap.c b/mm/mmap.c
index 15678aa..bfa389f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1620,7 +1620,7 @@ static inline int expand_downwards(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	address &= PAGE_MASK;
-	error = security_file_mmap(0, 0, 0, 0, address, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, address, 1);
 	if (error)
 		return error;
 
@@ -1941,7 +1941,7 @@ unsigned long do_brk(unsigned long addr, unsigned long len)
 	if (is_hugepage_only_range(mm, addr, len))
 		return -EINVAL;
 
-	error = security_file_mmap(0, 0, 0, 0, addr, 1);
+	error = security_file_mmap(NULL, 0, 0, 0, addr, 1);
 	if (error)
 		return error;
 
