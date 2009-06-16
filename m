Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbZFPM4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbZFPM4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbZFPMze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 1/9] x86: Adjust the coding style of vdso-layout.lds.S
Date: Tue, 16 Jun 2009 14:55:21 +0200
Message-Id: <1245156929-30395-2-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The style we try to introduce for .lds files in
arch/$ARCH/kernel/vmlinux.lds.S is much more C-like.

Use the same style in the vDSO linker script to get a consistent
style in linker scripts.

Credits to Sam Ravnborg for suggesting this change.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   76 +++++++++++++++++++++++++++------------
 1 files changed, 53 insertions(+), 23 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 634a2cf..917df03 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -8,34 +8,62 @@ SECTIONS
 {
 	. = VDSO_PRELINK + SIZEOF_HEADERS;
 
-	.hash		: { *(.hash) }			:text
-	.gnu.hash	: { *(.gnu.hash) }
-	.dynsym		: { *(.dynsym) }
-	.dynstr		: { *(.dynstr) }
-	.gnu.version	: { *(.gnu.version) }
-	.gnu.version_d	: { *(.gnu.version_d) }
-	.gnu.version_r	: { *(.gnu.version_r) }
+	.hash : {
+		*(.hash)
+	} :text
+	.gnu.hash : {
+		*(.gnu.hash)
+	}
+	.dynsym : {
+		*(.dynsym)
+	}
+	.dynstr : {
+		*(.dynstr)
+	}
+	.gnu.version : {
+		*(.gnu.version)
+	}
+	.gnu.version_d : {
+		*(.gnu.version_d)
+	}
+	.gnu.version_r : {
+		*(.gnu.version_r)
+	}
 
-	.note		: { *(.note.*) }		:text	:note
+	.note : {
+		*(.note.*)
+	} :text :note
 
-	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
-	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
+	.eh_frame_hdr : {
+		*(.eh_frame_hdr)
+	} :text :eh_frame_hdr
+	.eh_frame : {
+		KEEP (*(.eh_frame))
+	} :text
 
-	.dynamic	: { *(.dynamic) }		:text	:dynamic
+	.dynamic : {
+		*(.dynamic)
+	} :text :dynamic
 
-	.rodata		: { *(.rodata*) }		:text
-	.data		: {
-	      *(.data*)
-	      *(.sdata*)
-	      *(.got.plt) *(.got)
-	      *(.gnu.linkonce.d.*)
-	      *(.bss*)
-	      *(.dynbss*)
-	      *(.gnu.linkonce.b.*)
+	.rodata : {
+		*(.rodata*)
+	} :text
+	.data : {
+		*(.data*)
+		*(.sdata*)
+		*(.got.plt) *(.got)
+		*(.gnu.linkonce.d.*)
+		*(.bss*)
+		*(.dynbss*)
+		*(.gnu.linkonce.b.*)
 	}
 
-	.altinstructions	: { *(.altinstructions) }
-	.altinstr_replacement	: { *(.altinstr_replacement) }
+	.altinstructions : {
+		*(.altinstructions)
+	}
+	.altinstr_replacement : {
+		*(.altinstr_replacement)
+	}
 
 	/*
 	 * Align the actual code well away from the non-instruction data.
@@ -43,7 +71,9 @@ SECTIONS
 	 */
 	. = ALIGN(0x100);
 
-	.text		: { *(.text*) }			:text	=0x90909090
+	.text : {
+		*(.text*)
+	} :text	=0x90909090
 }
 
 /*
-- 
1.6.0.2

