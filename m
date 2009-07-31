Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZGaVBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZGaVBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZGaVBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:01:19 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54482 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062AbZGaVBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:01:16 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
Subject: [PATCH 2/3] ia64: Use standard macros for page-aligned data.
Date: Fri, 31 Jul 2009 16:57:52 -0400
Message-Id: <1249073873-30028-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249073873-30028-1-git-send-email-tabbott@ksplice.com>
References: <1249073873-30028-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/head.S        |    2 +-
 arch/ia64/kernel/vmlinux.lds.S |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index 8239ff6..ef27e79 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -167,7 +167,7 @@ RestRR:											\
 	mov _tmp2=((ia64_rid(IA64_REGION_ID_KERNEL, (num<<61)) << 8) | (pgsize << 2) | vhpt);; \
 	mov rr[_tmp1]=_tmp2
 
-	.section __special_page_section,"ax"
+	__PAGE_ALIGNED_DATA
 
 	.global empty_zero_page
 empty_zero_page:
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index fa3a558..b484b86 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -219,7 +219,9 @@ SECTIONS
 	{ *(.data.init_task) }
 
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET)
-        { *(__special_page_section)
+        {
+	PAGE_ALIGNED_DATA(PAGE_SIZE)
+	  . = ALIGN(PAGE_SIZE);
 	  __start_gate_section = .;
 	  *(.data.gate)
 	  __stop_gate_section = .;
-- 
1.6.3.3

