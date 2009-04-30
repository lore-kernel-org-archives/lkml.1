Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZD3Xqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZD3Xqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759616AbZD3Xpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:45:44 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59138 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759746AbZD3Xpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:45:43 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/6] arm: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 19:40:05 -0400
Message-Id: <1241134808-7583-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134808-7583-3-git-send-email-tabbott@mit.edu>
References: <1241134808-7583-1-git-send-email-tabbott@mit.edu>
 <1241134808-7583-2-git-send-email-tabbott@mit.edu>
 <1241134808-7583-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the nice consequence of replacing the alignment of 4096 with
an alignment of PAGE_SIZE (=4096).

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/vmlinux.lds.S |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 15520be..3e2f644 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  */
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 #include <asm/thread_info.h>
 #include <asm/memory.h>
 	
@@ -154,11 +155,7 @@ SECTIONS
 		__init_end = .;
 #endif
 
-		. = ALIGN(4096);
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(4096);
-		__nosave_end = .;
+		NOSAVE_DATA
 
 		/*
 		 * then the cacheline aligned data
-- 
1.6.2.1

