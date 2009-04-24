Return-Path: <linux-kernel-owner+w=401wt.eu-S1760455AbZDXQoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455AbZDXQoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbZDXQmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:39 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41649 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760098AbZDXQmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:38 -0400
Subject: [PATCH 09/14] x86: Provide _sdata in the vmlinux_*.lds.S files
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Fri, 24 Apr 2009 17:41:48 +0100
Message-ID: <20090424164148.4476.77086.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:33.0189 (UTC) FILETIME=[AA6D3950:01C9C4FB]
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
index 62ad500..27cfbab 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -63,6 +63,7 @@ SECTIONS
 
   /* writeable */
   . = ALIGN(PAGE_SIZE);
+  _sdata = .;			/* Start of data section */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
 	CONSTRUCTORS
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index c874250..ea33316 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -57,6 +57,7 @@ SECTIONS
   RODATA
 
   . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
+  _sdata = .;			/* Start of data section */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA

