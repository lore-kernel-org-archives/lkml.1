Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYKFMU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYKFMU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYKFMUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:20:16 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37625 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYKFMUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:20:15 -0500
Date: Thu, 6 Nov 2008 12:05:40 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: align DirectMap in /proc/meminfo
Message-ID: <Pine.LNX.4.64.0811061201090.30226@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the split-LRU patches added Inactive(anon) and Inactive(file) lines
to /proc/meminfo, all counts were moved two columns rightwards to fit in.
Now move x86's DirectMap lines two columns rightwards to line up.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Being a timid soul, I do wonder if realigning two columns rightwards was
a reckless breakage of the kernel-userspace API!  but assume that was
thrashed out at the time, and I've heard of no complaints.

 arch/x86/mm/pageattr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- 2.6.28-rc3/arch/x86/mm/pageattr.c	2008-10-24 09:27:48.000000000 +0100
+++ linux/arch/x86/mm/pageattr.c	2008-11-03 15:00:17.000000000 +0000
@@ -67,18 +67,18 @@ static void split_page_count(int level)
 
 void arch_report_meminfo(struct seq_file *m)
 {
-	seq_printf(m, "DirectMap4k:  %8lu kB\n",
+	seq_printf(m, "DirectMap4k:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_4K] << 2);
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-	seq_printf(m, "DirectMap2M:  %8lu kB\n",
+	seq_printf(m, "DirectMap2M:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 11);
 #else
-	seq_printf(m, "DirectMap4M:  %8lu kB\n",
+	seq_printf(m, "DirectMap4M:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_2M] << 12);
 #endif
 #ifdef CONFIG_X86_64
 	if (direct_gbpages)
-		seq_printf(m, "DirectMap1G:  %8lu kB\n",
+		seq_printf(m, "DirectMap1G:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_1G] << 20);
 #endif
 }
