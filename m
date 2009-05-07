Return-Path: <linux-kernel-owner+w=401wt.eu-S1763780AbZEGWcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780AbZEGWcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763171AbZEGW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:35559 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757096AbZEGW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470480"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/14] x86, boot: zero EFLAGS on 32 bits
Date: Thu,  7 May 2009 15:27:00 -0700
Message-Id: <1241735222-6640-13-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

The 64-bit code already clears EFLAGS as soon as it has a stack.  This
seems like a reasonable precaution, so do it on 32 bits as well.

[ Impact: extra paranoia ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/head_32.S |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 47636b3..48c2047 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -12,9 +12,9 @@
  * the page directory. [According to comments etc elsewhere on a compressed
  * kernel it will end up at 0x1000 + 1Mb I hope so as I assume this. - AC]
  *
- * Page 0 is deliberately kept safe, since System Management Mode code in 
+ * Page 0 is deliberately kept safe, since System Management Mode code in
  * laptops may need to access the BIOS data stored there.  This is also
- * useful for future device drivers that either access the BIOS via VM86 
+ * useful for future device drivers that either access the BIOS via VM86
  * mode.
  */
 
@@ -84,6 +84,12 @@ ENTRY(startup_32)
 	leal boot_stack_end(%ebx), %esp
 
 /*
+ * Zero EFLAGS
+ */
+	pushl $0
+	popfl
+
+/*
  * Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
-- 
1.6.0.6

