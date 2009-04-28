Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZD1RHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZD1RHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932912AbZD1RDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:03:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54877 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932932AbZD1RDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:03:24 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Chris Zankel <chris@zankel.net>
Subject: [PATCH v2 04/15] xtensa: Use macros for .bss.page_aligned section.
Date: Tue, 28 Apr 2009 13:00:51 -0400
Message-Id: <1240938062-3264-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240938062-3264-4-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
 <1240938062-3264-2-git-send-email-tabbott@mit.edu>
 <1240938062-3264-3-git-send-email-tabbott@mit.edu>
 <1240938062-3264-4-git-send-email-tabbott@mit.edu>
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

