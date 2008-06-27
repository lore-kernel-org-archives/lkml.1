Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYF0LGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYF0LGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYF0LGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:06:45 -0400
Received: from saeurebad.de ([85.214.36.134]:38335 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbYF0LGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:06:44 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mmotm] Remove ->nopfn check from use_zero_page
CC: linux-kernel@vger.kernel.org
Date: Fri, 27 Jun 2008 13:06:11 +0200
Message-ID: <878wwryw64.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The get_user_pages fix from Linus came to -mm through -next as it seems,
but -mm has Nick's nopfn removal patches already and so use_zero_page
checks for a non-existant vm_op.

This patch is needed to at least compile.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

diff --git a/mm/memory.c b/mm/memory.c
index 08cd653..5d7e705 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1082,11 +1082,10 @@ static inline int use_zero_page(struct vm_area_struct *vma)
 	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
 		return 0;
 	/*
-	 * And if we have a fault or a nopfn routine, it's not an
-	 * anonymous region.
+	 * And if we have a fault routine, it's not an anonymous
+	 * region.
 	 */
-	return !vma->vm_ops ||
-		(!vma->vm_ops->fault && !vma->vm_ops->nopfn);
+	return !vma->vm_ops || !vma->vm_ops->fault;
 }
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
