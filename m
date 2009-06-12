Return-Path: <linux-kernel-owner+w=401wt.eu-S1764669AbZFLN06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764669AbZFLN06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761709AbZFLNZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbZFLNZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:41 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH 3/8] x86: Remove .dynbss from the vDSO linker script
Date: Fri, 12 Jun 2009 15:25:37 +0200
Message-Id: <8de6230206ca20a4c205066fd213bbc951dbfac6.1244812577.git.ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1244812577.git.ptesarik@suse.cz>
References: <cover.1244812577.git.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can see, the .dynbss section does not make any sense
and cannot even appear in a shared library.

Remove it.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/x86/vdso/vdso-layout.lds.S |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index af3fa61..0386c92 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -46,15 +46,12 @@ SECTIONS
 	} :text :dynamic
 
 	.rodata : {
-		*(.rodata*)
+		*(.rodata* .gnu.linkonce.r.*)
 	} :text
 	.data : {
-		*(.data*)
+		*(.data* .gnu.linkonce.d.*)
 		*(.got.plt) *(.got)
-		*(.gnu.linkonce.d.*)
-		*(.bss*)
-		*(.dynbss*)
-		*(.gnu.linkonce.b.*)
+		*(.bss* .gnu.linkonce.b.*)
 	}
 
 	.altinstructions : {
@@ -71,7 +68,7 @@ SECTIONS
 	. = ALIGN(0x100);
 
 	.text : {
-		*(.text*)
+		*(.text* .gnu.linkonce.t.*)
 	} :text	=0x90909090
 }
 
-- 
1.6.0.2

