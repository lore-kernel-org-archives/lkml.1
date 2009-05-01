Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbZEAAWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbZEAAWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761606AbZEAAE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:04:26 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62139 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759148AbZEAAEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:04:24 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 5/5] ia64: convert to new generic read_mostly support.
Date: Thu, 30 Apr 2009 20:04:07 -0400
Message-Id: <1241136247-10623-6-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136247-10623-5-git-send-email-tabbott@mit.edu>
References: <1241136247-10623-1-git-send-email-tabbott@mit.edu>
 <1241136247-10623-2-git-send-email-tabbott@mit.edu>
 <1241136247-10623-3-git-send-email-tabbott@mit.edu>
 <1241136247-10623-4-git-send-email-tabbott@mit.edu>
 <1241136247-10623-5-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/Kconfig             |    3 +++
 arch/ia64/include/asm/cache.h |    2 --
 arch/ia64/xen/xensetup.S      |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 294a3b1..1e2cd63 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -91,6 +91,9 @@ config GENERIC_TIME_VSYSCALL
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
+config HAVE_READ_MOSTLY_DATA
+	def_bool y
+
 config DMI
 	bool
 	default y
diff --git a/arch/ia64/include/asm/cache.h b/arch/ia64/include/asm/cache.h
index e7482bd..8f72e1b 100644
--- a/arch/ia64/include/asm/cache.h
+++ b/arch/ia64/include/asm/cache.h
@@ -24,6 +24,4 @@
 # define SMP_CACHE_BYTES	(1 << 3)
 #endif
 
-#define __read_mostly __attribute__((__section__(".data.read_mostly")))
-
 #endif /* _ASM_IA64_CACHE_H */
diff --git a/arch/ia64/xen/xensetup.S b/arch/ia64/xen/xensetup.S
index 28fed1f..8781561 100644
--- a/arch/ia64/xen/xensetup.S
+++ b/arch/ia64/xen/xensetup.S
@@ -10,11 +10,12 @@
 #include <asm/system.h>
 #include <asm/paravirt.h>
 #include <asm/xen/privop.h>
+#include <linux/cache.h>
 #include <linux/elfnote.h>
 #include <linux/init.h>
 #include <xen/interface/elfnote.h>
 
-	.section .data.read_mostly
+	__READ_MOSTLY
 	.align 8
 	.global xen_domain_type
 xen_domain_type:
-- 
1.6.2.1

