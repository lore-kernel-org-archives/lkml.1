Return-Path: <linux-kernel-owner+w=401wt.eu-S1765817AbZEAARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765817AbZEAARS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763069AbZEAADV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61952 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757191AbZEAADT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:19 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Chris Zankel <chris@zankel.net>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/3] xtensa: Use macros for .bss.page_aligned section.
Date: Thu, 30 Apr 2009 20:00:25 -0400
Message-Id: <1241136027-10244-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136027-10244-1-git-send-email-tabbott@mit.edu>
References: <1241136027-10244-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/kernel/head.S        |    2 +-
 arch/xtensa/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/kernel/head.S b/arch/xtensa/kernel/head.S
index d9ddc1b..d215adc 100644
--- a/arch/xtensa/kernel/head.S
+++ b/arch/xtensa/kernel/head.S
@@ -235,7 +235,7 @@ should_never_return:
  * BSS section
  */
 	
-.section ".bss.page_aligned", "w"
+__PAGE_ALIGNED_BSS
 #ifdef CONFIG_MMU
 ENTRY(swapper_pg_dir)
 	.fill	PAGE_SIZE, 1, 0
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index 5accf51..f96f354 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -262,7 +262,7 @@ SECTIONS
 
   /* BSS section */
   _bss_start = .;
-  .bss : { *(.bss.page_aligned) *(.bss) }
+  .bss : { PAGE_ALIGNED_BSS *(.bss) }
   _bss_end = .;
 
   _end = .;
-- 
1.6.2.1

