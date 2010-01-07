Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495Ab0AGBIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab0AGBIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245Ab0AGBIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:08:50 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:52195 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab0AGBIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:08:49 -0500
Date: Thu, 7 Jan 2010 09:57:14 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: akpm@linux-foundation.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH -mmotm] memcg: implement memory thresholds document fixes
Message-Id: <20100107095714.9edc4201.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each memcg-implement-memory-thresholds.patch and
memcg-add-interface-to-move-charge-at-task-migration.patch try to add a new
section to Documentation/cgroup/memory.txt, so the document has been a bit
mangled when these patches are merged at the same time.

This patch fixes it.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
---
This patch can be applied after memcg-implement-memory-thresholds-checkpatch-fixes.patch.

 Documentation/cgroups/memory.txt |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 226a955..aad7d05 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -458,7 +458,15 @@ Note: Those pages and swaps must be charged to the old cgroup.
 Note: More type of pages(e.g. file cache, shmem,) will be supported by other
       bits in future.
 
-8.3 Memory thresholds
+8.3 TODO
+
+- Add support for other types of pages(e.g. file cache, shmem, etc.).
+- Implement madvise(2) to let users decide the vma to be moved or not to be
+  moved.
+- All of moving charge operations are done under cgroup_mutex. It's not good
+  behavior to hold the mutex too long, so we may need some trick.
+
+9. Memory thresholds
 
 Memory controler implements memory thresholds using cgroups notification
 API (see cgroups.txt). It allows to register multiple memory and memsw
@@ -475,16 +483,7 @@ threshold in any direction.
 
 It's applicable for root and non-root cgroup.
 
-
-8.4 TODO
-
-- Add support for other types of pages(e.g. file cache, shmem, etc.).
-- Implement madvise(2) to let users decide the vma to be moved or not to be
-  moved.
-- All of moving charge operations are done under cgroup_mutex. It's not good
-  behavior to hold the mutex too long, so we may need some trick.
-
-9. TODO
+10. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
-- 
1.5.6.1

