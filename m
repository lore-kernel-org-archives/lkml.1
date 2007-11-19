Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXKSWHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXKSWHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbXKSWGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:06:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbXKSWGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:06:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 09/18] x86 vDSO: absolute relocs
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Zippy-Says: WHY are we missing KOJAK?
Message-Id: <20071119220551.3470226F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:05:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This updates the exceptions for absolute relocs for the new symbol name
convention used for symbols extracted from the vDSO images.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/boot/compressed/relocs.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index 7a0d00b..d01ea42 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -27,11 +27,6 @@ static unsigned long *relocs;
  * absolute relocations present w.r.t these symbols.
  */
 static const char* safe_abs_relocs[] = {
-		"__kernel_vsyscall",
-		"__kernel_rt_sigreturn",
-		"__kernel_sigreturn",
-		"SYSENTER_RETURN",
-		"VDSO_NOTE_MASK",
 		"xen_irq_disable_direct_reloc",
 		"xen_save_fl_direct_reloc",
 };
@@ -45,6 +40,8 @@ static int is_safe_abs_reloc(const char* sym_name)
 			/* Match found */
 			return 1;
 	}
+	if (strncmp(sym_name, "VDSO", 4) == 0)
+		return 1;
 	if (strncmp(sym_name, "__crc_", 6) == 0)
 		return 1;
 	return 0;
