Return-Path: <linux-kernel-owner+w=401wt.eu-S938318AbYCTAZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938318AbYCTAZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbYCSXgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:36:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763889AbYCSXf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:57 -0400
Message-Id: <20080318185720.231582319@szeredi.hu>
References: <20080318185626.300130296@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 18 Mar 2008 19:56:29 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 3/4] mm: document missing fields for /proc/meminfo
Content-Disposition: inline; filename=proc_meminfo_doc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

A few fields in /proc/meminfo were not documented.  Fix.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/proc.txt |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt	2008-03-18 19:27:43.000000000 +0100
+++ linux/Documentation/filesystems/proc.txt	2008-03-18 19:41:40.000000000 +0100
@@ -463,11 +463,17 @@ SwapTotal:           0 kB
 SwapFree:            0 kB
 Dirty:             968 kB
 Writeback:           0 kB
+AnonPages:      861800 kB
 Mapped:         280372 kB
-Slab:           684068 kB
+Slab:           284364 kB
+SReclaimable:   159856 kB
+SUnreclaim:     124508 kB
+PageTables:      24448 kB
+NFS_Unstable:        0 kB
+Bounce:              0 kB
+WritebackTmp:        0 kB
 CommitLimit:   7669796 kB
 Committed_AS:   100056 kB
-PageTables:      24448 kB
 VmallocTotal:   112216 kB
 VmallocUsed:       428 kB
 VmallocChunk:   111088 kB
@@ -503,8 +509,17 @@ VmallocChunk:   111088 kB
               on the disk
        Dirty: Memory which is waiting to get written back to the disk
    Writeback: Memory which is actively being written back to the disk
+   AnonPages: Non-file backed pages mapped into userspace page tables
       Mapped: files which have been mmaped, such as libraries
         Slab: in-kernel data structures cache
+SReclaimable: Part of Slab, that might be reclaimed, such as caches
+  SUnreclaim: Part of Slab, that cannot be reclaimed on memory pressure
+  PageTables: amount of memory dedicated to the lowest level of page
+              tables.
+NFS_Unstable: NFS pages sent to the server, but not yet committed to stable
+	      storage
+      Bounce: Memory used for block device "bounce buffers"
+WritebackTmp: Memory used by FUSE for temporary writeback buffers
  CommitLimit: Based on the overcommit ratio ('vm.overcommit_ratio'),
               this is the total amount of  memory currently available to
               be allocated on the system. This limit is only adhered to
@@ -531,8 +546,6 @@ Committed_AS: The amount of memory prese
               above) will not be permitted. This is useful if one needs
               to guarantee that processes will not fail due to lack of
               memory once that memory has been successfully allocated.
-  PageTables: amount of memory dedicated to the lowest level of page
-              tables.
 VmallocTotal: total size of vmalloc memory area
  VmallocUsed: amount of vmalloc area which is used
 VmallocChunk: largest contigious block of vmalloc area which is free

--
