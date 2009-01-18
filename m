Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZARDmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZARDmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 22:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbZARDmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 22:42:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50075 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbZARDmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 22:42:13 -0500
Date: Sun, 18 Jan 2009 04:39:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] get_mm_hiwater_xxx: trivial, s/define/inline/
Message-ID: <20090118033953.GA23666@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry! forgot to save this patch)

Andrew pointed out get_mm_hiwater_xxx() evaluate "mm" argument thrice/twice,
make them inline.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/include/linux/sched.h~CLEANUP	2008-12-03 18:17:18.000000000 +0100
+++ K-28/include/linux/sched.h	2008-12-20 16:01:31.000000000 +0100
@@ -388,8 +388,15 @@ extern void arch_unmap_area_topdown(stru
 		(mm)->hiwater_vm = (mm)->total_vm;	\
 } while (0)
 
-#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
-#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
+static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
+{
+	return max(mm->hiwater_rss, get_mm_rss(mm));
+}
+
+static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
+{
+	return max(mm->hiwater_vm, mm->total_vm);
+}
 
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);

