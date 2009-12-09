Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbZLIWm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbZLIWm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758486AbZLIWmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:42:17 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:44324 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286AbZLIWmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:42:13 -0500
Message-ID: <4B20277B.1030903@hp.com>
Date: Wed, 09 Dec 2009 17:40:59 -0500
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mst@redhat.com,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] export use_mm and unuse_mm for filesystem modules.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


required for btrfs directio worker threads.

Signed-off-by: jim owens <jowens@hp.com>
---
 mm/mmu_context.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index ded9081..daabf4d 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -3,6 +3,7 @@
  * See ../COPYING for licensing terms.
  */
 
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/mmu_context.h>
 #include <linux/sched.h>
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
1.5.6.3
