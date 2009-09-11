Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZIKU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZIKU5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZIKU5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:57:30 -0400
Received: from fifo99.com ([67.223.236.141]:47516 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbZIKU53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:57:29 -0400
Subject: Re: [PATCH] [16/21] HWPOISON: The high level memory error handler
 in the VM v7
From: Daniel Walker <dwalker@fifo99.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: npiggin@suse.de, riel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090911193346.GE32562@basil.fritz.box>
References: <20090911848.933193846@firstfloor.org>
	 <20090911184845.38A6EB1758@basil.firstfloor.org>
	 <1252697149.28368.12.camel@desktop>
	 <20090911193346.GE32562@basil.fritz.box>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 13:58:04 -0700
Message-Id: <1252702684.28368.21.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 21:33 +0200, Andi Kleen wrote:
> > The rest of your patches are totally clean, except this one .. It has
> > some warning, but one error in the second ifdef block above ..
> 
> That's intentional, fixing it would require a bare , on a single line
> which would be far uglier what is there today. I refuse to make code
> ugly just to work around checkpatch.pl


Like the following is clean, and I don't see why it would work. Although
I only compile tested it.

--

Order the seq_printfs so they can more easily (and cleanly) be added
to and ifdef'ed.

Cc: npiggin@suse.de
Cc: riel@redhat.com
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 fs/proc/meminfo.c |   83 +++++++++++++++++++++++++---------------------------
 1 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 78faedc..8309f1a 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -65,41 +65,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		"Active(file):   %8lu kB\n"
 		"Inactive(file): %8lu kB\n"
 		"Unevictable:    %8lu kB\n"
-		"Mlocked:        %8lu kB\n"
-#ifdef CONFIG_HIGHMEM
-		"HighTotal:      %8lu kB\n"
-		"HighFree:       %8lu kB\n"
-		"LowTotal:       %8lu kB\n"
-		"LowFree:        %8lu kB\n"
-#endif
-#ifndef CONFIG_MMU
-		"MmapCopy:       %8lu kB\n"
-#endif
-		"SwapTotal:      %8lu kB\n"
-		"SwapFree:       %8lu kB\n"
-		"Dirty:          %8lu kB\n"
-		"Writeback:      %8lu kB\n"
-		"AnonPages:      %8lu kB\n"
-		"Mapped:         %8lu kB\n"
-		"Slab:           %8lu kB\n"
-		"SReclaimable:   %8lu kB\n"
-		"SUnreclaim:     %8lu kB\n"
-		"PageTables:     %8lu kB\n"
-#ifdef CONFIG_QUICKLIST
-		"Quicklists:     %8lu kB\n"
-#endif
-		"NFS_Unstable:   %8lu kB\n"
-		"Bounce:         %8lu kB\n"
-		"WritebackTmp:   %8lu kB\n"
-		"CommitLimit:    %8lu kB\n"
-		"Committed_AS:   %8lu kB\n"
-		"VmallocTotal:   %8lu kB\n"
-		"VmallocUsed:    %8lu kB\n"
-		"VmallocChunk:   %8lu kB\n"
-#ifdef CONFIG_MEMORY_FAILURE
-		"HardwareCorrupted: %8lu kB\n"
-#endif
-		,
+		"Mlocked:        %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
@@ -112,16 +78,35 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		K(pages[LRU_ACTIVE_FILE]),
 		K(pages[LRU_INACTIVE_FILE]),
 		K(pages[LRU_UNEVICTABLE]),
-		K(global_page_state(NR_MLOCK)),
+		K(global_page_state(NR_MLOCK)));
+
 #ifdef CONFIG_HIGHMEM
+	seq_printf(m,
+		"HighTotal:      %8lu kB\n"
+		"HighFree:       %8lu kB\n"
+		"LowTotal:       %8lu kB\n"
+		"LowFree:        %8lu kB\n",
 		K(i.totalhigh),
 		K(i.freehigh),
 		K(i.totalram-i.totalhigh),
-		K(i.freeram-i.freehigh),
+		K(i.freeram-i.freehigh));
 #endif
 #ifndef CONFIG_MMU
-		K((unsigned long) atomic_long_read(&mmap_pages_allocated)),
+	seq_printf(m,
+		"MmapCopy:       %8lu kB\n",
+		K((unsigned long) atomic_long_read(&mmap_pages_allocated)));
 #endif
+	seq_printf(m,
+		"SwapTotal:      %8lu kB\n"
+		"SwapFree:       %8lu kB\n"
+		"Dirty:          %8lu kB\n"
+		"Writeback:      %8lu kB\n"
+		"AnonPages:      %8lu kB\n"
+		"Mapped:         %8lu kB\n"
+		"Slab:           %8lu kB\n"
+		"SReclaimable:   %8lu kB\n"
+		"SUnreclaim:     %8lu kB\n"
+		"PageTables:     %8lu kB\n",
 		K(i.totalswap),
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
@@ -132,10 +117,21 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 				global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
-		K(global_page_state(NR_PAGETABLE)),
+		K(global_page_state(NR_PAGETABLE)));
 #ifdef CONFIG_QUICKLIST
-		K(quicklist_total_size()),
+	seq_printf(m,
+		"Quicklists:     %8lu kB\n"
+		K(quicklist_total_size()));
 #endif
+	seq_printf(m,
+		"NFS_Unstable:   %8lu kB\n"
+		"Bounce:         %8lu kB\n"
+		"WritebackTmp:   %8lu kB\n"
+		"CommitLimit:    %8lu kB\n"
+		"Committed_AS:   %8lu kB\n"
+		"VmallocTotal:   %8lu kB\n"
+		"VmallocUsed:    %8lu kB\n"
+		"VmallocChunk:   %8lu kB\n",
 		K(global_page_state(NR_UNSTABLE_NFS)),
 		K(global_page_state(NR_BOUNCE)),
 		K(global_page_state(NR_WRITEBACK_TEMP)),
@@ -143,11 +139,12 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
-		vmi.largest_chunk >> 10
+		vmi.largest_chunk >> 10);
 #ifdef CONFIG_MEMORY_FAILURE
-		,atomic_long_read(&mce_bad_pages) << (PAGE_SHIFT - 10)
+	seq_printf(m,
+		"HardwareCorrupted: %8lu kB\n",
+		atomic_long_read(&mce_bad_pages) << (PAGE_SHIFT - 10));
 #endif
-		);
 
 	hugetlb_report_meminfo(m);
 
-- 
1.5.6.3



