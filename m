Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZJBUTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZJBUTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbZJBUTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:19:36 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58019 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757713AbZJBUTe (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Fri, 2 Oct 2009 16:19:34 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 1/4] mm: export use_mm() and unuse_mm() to modules
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com
Date: Fri, 02 Oct 2009 16:19:22 -0400
Message-ID: <20091002201922.4014.6918.stgit@dev.haskins.net>
In-Reply-To: <20091002201159.4014.33268.stgit@dev.haskins.net>
References: <20091002201159.4014.33268.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to use these functions from withing KVM, which may be built as
a module.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 mm/mmu_context.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index ded9081..f31ba20 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/mmu_context.h>
 #include <linux/sched.h>
+#include <linux/module.h>
 
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

