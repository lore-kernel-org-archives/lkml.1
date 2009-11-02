Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbZKBW3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbZKBW3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbZKBW3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:29:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292AbZKBW3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:29:05 -0500
Date: Tue, 3 Nov 2009 00:26:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com
Subject: [PATCHv6 2/3] mm: export use_mm/unuse_mm to modules
Message-ID: <20091102222624.GC15184@redhat.com>
References: <cover.1257193660.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1257193660.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost net module wants to do copy to/from user from a kernel thread,
which needs use_mm. Export it to modules.

Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/mmu_context.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index ded9081..0777654 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -5,6 +5,7 @@
 
 #include <linux/mm.h>
 #include <linux/mmu_context.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 
 #include <asm/mmu_context.h>
@@ -37,6 +38,7 @@ void use_mm(struct mm_struct *mm)
 	if (active_mm != mm)
 		mmdrop(active_mm);
 }
+EXPORT_SYMBOL_GPL(use_mm);
 
 /*
  * unuse_mm
@@ -56,3 +58,4 @@ void unuse_mm(struct mm_struct *mm)
 	enter_lazy_tlb(mm, tsk);
 	task_unlock(tsk);
 }
+EXPORT_SYMBOL_GPL(unuse_mm);
-- 
1.6.5.rc2

