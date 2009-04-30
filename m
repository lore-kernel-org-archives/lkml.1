Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZD3Xkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZD3Xkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZD3XkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:40:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58183 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbZD3XkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:40:17 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 6/6] arm: use PERCPU macro in linker script.
Date: Thu, 30 Apr 2009 19:40:08 -0400
Message-Id: <1241134808-7583-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241134808-7583-6-git-send-email-tabbott@mit.edu>
References: <1241134808-7583-1-git-send-email-tabbott@mit.edu>
 <1241134808-7583-2-git-send-email-tabbott@mit.edu>
 <1241134808-7583-3-git-send-email-tabbott@mit.edu>
 <1241134808-7583-4-git-send-email-tabbott@mit.edu>
 <1241134808-7583-5-git-send-email-tabbott@mit.edu>
 <1241134808-7583-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/vmlinux.lds.S |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index eede3be..5ff99b3 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -62,13 +62,6 @@ SECTIONS
 			usr/built-in.o(.init.ramfs)
 		__initramfs_end = .;
 #endif
-		. = ALIGN(4096);
-		__per_cpu_load = .;
-		__per_cpu_start = .;
-			*(.data.percpu.page_aligned)
-			*(.data.percpu)
-			*(.data.percpu.shared_aligned)
-		__per_cpu_end = .;
 #ifndef CONFIG_XIP_KERNEL
 		__init_begin = _stext;
 		INIT_DATA
@@ -77,6 +70,8 @@ SECTIONS
 #endif
 	}
 
+	PERCPU(4096)
+
 	/DISCARD/ : {			/* Exit code and data		*/
 		EXIT_TEXT
 		EXIT_DATA
-- 
1.6.2.1

