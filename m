Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbZEGW1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbZEGW1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbZEGW1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:09 -0400
Received: from mga06.intel.com ([134.134.136.21]:36123 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752223AbZEGW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470409"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 01/14] x86, boot: align the .bss section in the decompressor
Date: Thu,  7 May 2009 15:26:49 -0700
Message-Id: <1241735222-6640-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Aligning the .bss section makes it trivially faster, and makes using
larger transfers for the clear slightly easier.

[ Impact: trivial performance enhancement, future patch prep ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/vmlinux.lds.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 0d26c92..27c168d 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -42,6 +42,7 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
+	. = ALIGN(32);
 	.bss : {
 		_bss = . ;
 		*(.bss)
-- 
1.6.0.6

