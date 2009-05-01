Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbZEAAWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbZEAAWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762346AbZEAAEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:04:20 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62096 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765472AbZEAAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:04:17 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/5] ia64: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 20:04:04 -0400
Message-Id: <1241136247-10623-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136247-10623-2-git-send-email-tabbott@mit.edu>
References: <1241136247-10623-1-git-send-email-tabbott@mit.edu>
 <1241136247-10623-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/vmlinux.lds.S |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index fa3a558..cdcd655 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -237,9 +237,6 @@ SECTIONS
   .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET)
         { *(.data.read_mostly) }
 
-  .data.cacheline_aligned : AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET)
-        { *(.data.cacheline_aligned) }
-
   /* Per-cpu data: */
   . = ALIGN(PERCPU_PAGE_SIZE);
   PERCPU_VADDR(PERCPU_ADDR, :percpu)
@@ -256,6 +253,7 @@ SECTIONS
 		__cpu0_per_cpu = .;
   . = . + PERCPU_PAGE_SIZE;	/* cpu0 per-cpu space */
 #endif
+		CACHELINE_ALIGNED_DATA(SMP_CACHE_BYTES)
 		DATA_DATA
 		*(.data1)
 		*(.gnu.linkonce.d*)
-- 
1.6.2.1

