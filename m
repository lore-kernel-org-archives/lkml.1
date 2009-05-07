Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbZEGLVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbZEGLVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZEGLVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:21:36 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:42014 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbZEGLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:21:36 -0400
Subject: [PATCH] x86: Provide _sdata in the vmlinux_*.lds.S files
To: x86@kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Thu, 07 May 2009 12:06:49 +0100
Message-ID: <20090507110648.8484.38527.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.375.gd335
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2009 11:08:07.0816 (UTC) FILETIME=[19E70880:01C9CF04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_sdata is a common symbol defined by many architectures and made
available to the kernel via asm-generic/sections.h. Kmemleak uses this
symbol when scanning the data sections. The _edata symbol in
vmlinux_64.lds.S was also moved further down to include the
.data.read_mostly section.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 arch/x86/kernel/vmlinux_64.lds.S |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 62ad500..181bd49 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -64,6 +64,7 @@ SECTIONS
   /* writeable */
   . = ALIGN(PAGE_SIZE);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
+	_sdata = .;		/* Start of data section */
 	DATA_DATA
 	CONSTRUCTORS
 	} :data
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index c874250..4398a91 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -59,9 +59,9 @@ SECTIONS
   . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
+	_sdata = .;			/* Start of data section */
 	DATA_DATA
 	CONSTRUCTORS
-	_edata = .;			/* End of data section */
 	} :data
 
 
@@ -73,6 +73,7 @@ SECTIONS
   . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
   .data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
   	*(.data.read_mostly)
+	_edata = .;			/* End of data section */
   }
 
 #define VSYSCALL_ADDR (-10*1024*1024)

