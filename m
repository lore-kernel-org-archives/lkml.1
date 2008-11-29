Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYK2Kqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYK2Kqj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbYK2KoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:44:07 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41399 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbYK2KoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:44:05 -0500
Subject: [PATCH 09/15] x86: Provide _sdata in the vmlinux_*.lds.S files
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 10:43:56 +0000
Message-ID: <20081129104356.16726.28828.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:43:57.0079 (UTC) FILETIME=[6183E270:01C9520F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_sdata is a common symbol defined by many architectures and made
available to the kernel via asm-generic/sections.h. Kmemleak uses this
symbol when scanning the data sections.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 arch/x86/kernel/vmlinux_64.lds.S |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index a9b8560..b5d2b49 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -62,6 +62,7 @@ SECTIONS
 
   /* writeable */
   . = ALIGN(PAGE_SIZE);
+  _sdata = .;			/* Start of data section */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
 	CONSTRUCTORS
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 46e0544..8ad376c 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -52,6 +52,7 @@ SECTIONS
   RODATA
 
   . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
+  _sdata = .;			/* Start of data section */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA

