Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZJRRX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZJRRX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 13:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZJRRX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 13:23:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46699 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627AbZJRRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 13:23:58 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v4 3/7] m68knommu: Use INIT_TASK_DATA and CACHELINE_ALIGNED_DATA.
Date: Sun, 18 Oct 2009 13:23:51 -0400
Message-Id: <1255886635-17371-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
References: <alpine.DEB.1.10.0910142041520.6638@dr-wily.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/m68knommu/kernel/vmlinux.lds.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
index edc20bd..153569b 100644
--- a/arch/m68knommu/kernel/vmlinux.lds.S
+++ b/arch/m68knommu/kernel/vmlinux.lds.S
@@ -9,6 +9,7 @@
 
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
+#include <asm/thread_info.h>
 
 #if defined(CONFIG_RAMKERNEL)
 #define	RAM_START	CONFIG_KERNELBASE
@@ -148,10 +149,8 @@ SECTIONS {
 		. = ALIGN(4);
 		_sdata = . ;
 		DATA_DATA
-		. = ALIGN(32);
-		*(.data.cacheline_aligned)
-		. = ALIGN(8192) ;
-		*(.data.init_task)
+		CACHELINE_ALIGNED_DATA(32)
+		INIT_TASK_DATA(THREAD_SIZE)
 		_edata = . ;
 	} > DATA
 
-- 
1.6.4.3

