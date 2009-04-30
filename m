Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbZEAAYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbZEAAYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762533AbZEAAFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:05:20 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62259 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762814AbZEAAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:05:18 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, linux-sh@vger.kernel.org
Subject: [PATCH 6/7] sh: use new macro for .data.read_mostly section.
Date: Thu, 30 Apr 2009 19:58:02 -0400
Message-Id: <1241135883-9766-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135883-9766-6-git-send-email-tabbott@mit.edu>
References: <1241135883-9766-1-git-send-email-tabbott@mit.edu>
 <1241135883-9766-2-git-send-email-tabbott@mit.edu>
 <1241135883-9766-3-git-send-email-tabbott@mit.edu>
 <1241135883-9766-4-git-send-email-tabbott@mit.edu>
 <1241135883-9766-5-git-send-email-tabbott@mit.edu>
 <1241135883-9766-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/vmlinux_32.lds.S |    5 +----
 arch/sh/kernel/vmlinux_64.lds.S |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index 7a0f3c4..de80e50 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -61,13 +61,10 @@ SECTIONS
 
 	.data : {			/* Data */
 		INIT_TASK_DATA(THREAD_SIZE)
-
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.read_mostly)
-
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
+		READ_MOSTLY_DATA(L1_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index 5cd3e78..72e856b 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -70,13 +70,10 @@ SECTIONS
 
 	.data : C_PHYS(.data) {			/* Data */
 		INIT_TASK_DATA(THREAD_SIZE)
-
-		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.read_mostly)
-
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
+		READ_MOSTLY_DATA(L1_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
-- 
1.6.2.1

