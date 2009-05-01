Return-Path: <linux-kernel-owner+w=401wt.eu-S933869AbZEAAdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869AbZEAAdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933124AbZEAAV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:21:57 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64584 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933155AbZEAAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:21:56 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/5] ia64: use new macro for .data.read_mostly section.
Date: Thu, 30 Apr 2009 20:04:06 -0400
Message-Id: <1241136247-10623-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136247-10623-4-git-send-email-tabbott@mit.edu>
References: <1241136247-10623-1-git-send-email-tabbott@mit.edu>
 <1241136247-10623-2-git-send-email-tabbott@mit.edu>
 <1241136247-10623-3-git-send-email-tabbott@mit.edu>
 <1241136247-10623-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with .data.cacheline_aligned, I eliminated the separate output
section and set the alignment to SMP_CACHE_BYTES.  An ack from Tony
would be appreciated.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/vmlinux.lds.S |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 9c4cc29..e99faad 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -230,9 +230,6 @@ SECTIONS
   				 * kernel data
 				 */
 
-  .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET)
-        { *(.data.read_mostly) }
-
   /* Per-cpu data: */
   . = ALIGN(PERCPU_PAGE_SIZE);
   PERCPU_VADDR(PERCPU_ADDR, :percpu)
@@ -251,6 +248,7 @@ SECTIONS
 #endif
 		INIT_TASK_DATA(PAGE_SIZE)
 		CACHELINE_ALIGNED_DATA(SMP_CACHE_BYTES)
+		READ_MOSTLY_DATA(SMP_CACHE_BYTES)
 		DATA_DATA
 		*(.data1)
 		*(.gnu.linkonce.d*)
-- 
1.6.2.1

