Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYGHXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYGHXSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYGHXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:45 -0400
Received: from gw.goop.org ([64.81.55.164]:51200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994AbYGHXOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 13 of 55] xen: make ELF notes work for 32 and 64 bit
X-Mercurial-Node: ead4e5c9daf9a2aedcefa669be45ef735d4ddef7
Message-Id: <ead4e5c9daf9a2aedcef.1215554795@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/xen-head.S |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -5,7 +5,10 @@
 
 #include <linux/elfnote.h>
 #include <linux/init.h>
+
 #include <asm/boot.h>
+#include <asm/asm.h>
+
 #include <xen/interface/elfnote.h>
 #include <asm/xen/interface.h>
 
@@ -21,21 +24,21 @@
 .pushsection .text
 	.align PAGE_SIZE_asm
 ENTRY(hypercall_page)
-	.skip 0x1000
+	.skip PAGE_SIZE_asm
 .popsection
 
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
 	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_VERSION,  .asciz "2.6")
 	ELFNOTE(Xen, XEN_ELFNOTE_XEN_VERSION,    .asciz "xen-3.0")
-	ELFNOTE(Xen, XEN_ELFNOTE_VIRT_BASE,      .long  __PAGE_OFFSET)
-	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          .long  startup_xen)
-	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, .long  hypercall_page)
+	ELFNOTE(Xen, XEN_ELFNOTE_VIRT_BASE,      _ASM_PTR __PAGE_OFFSET)
+	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
+	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
 	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
 	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
 		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
 	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
-	ELFNOTE(Xen, XEN_ELFNOTE_HV_START_LOW,   .long __HYPERVISOR_VIRT_START)
+	ELFNOTE(Xen, XEN_ELFNOTE_HV_START_LOW,   _ASM_PTR __HYPERVISOR_VIRT_START)
 
 #endif /*CONFIG_XEN */


