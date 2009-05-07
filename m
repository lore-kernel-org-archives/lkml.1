Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbZEGWae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbZEGWae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763222AbZEGW1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:16 -0400
Received: from mga06.intel.com ([134.134.136.21]:36123 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754917AbZEGW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470457"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 08/14] x86, boot: use BP_scratch in arch/x86/boot/compressed/head_*.S
Date: Thu,  7 May 2009 15:26:56 -0700
Message-Id: <1241735222-6640-9-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Use the BP_scratch symbol from asm-offsets.h instead of hard-coding
the location.

[ Impact: cleanup ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/head_32.S |    2 +-
 arch/x86/boot/compressed/head_64.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 2d7cd0f..511b0be 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -53,7 +53,7 @@ ENTRY(startup_32)
  * data at 0x1e4 (defined as a scratch field) are used as the stack
  * for this calculation. Only 4 bytes are needed.
  */
-	leal (0x1e4+4)(%esi), %esp
+	leal (BP_scratch+4)(%esi), %esp
 	call 1f
 1:	popl %ebp
 	subl $1b, %ebp
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 201af02..191b0d3 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -50,7 +50,7 @@ ENTRY(startup_32)
  * data at 0x1e4 (defined as a scratch field) are used as the stack
  * for this calculation. Only 4 bytes are needed.
  */
-	leal	(0x1e4+4)(%esi), %esp
+	leal	(BP_scratch+4)(%esi), %esp
 	call	1f
 1:	popl	%ebp
 	subl	$1b, %ebp
-- 
1.6.0.6

