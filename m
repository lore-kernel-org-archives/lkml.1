Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYK2KrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYK2KrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYK2KoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:44:24 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41415 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756271AbYK2KoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:44:23 -0500
Subject: [PATCH 10/15] arm: Provide _sdata and __bss_stop in the vmlinux.lds.S
	file
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+lkml@arm.linux.org.uk>
Date: Sat, 29 Nov 2008 10:44:02 +0000
Message-ID: <20081129104402.16726.24856.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:44:02.0657 (UTC) FILETIME=[64D70510:01C9520F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_sdata and __bss_stop are common symbols defined by many architectures
and made available to the kernel via asm-generic/sections.h. Kmemleak
uses these symbols when scanning the data sections.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
---
 arch/arm/kernel/vmlinux.lds.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 4898bdc..3cf1d44 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -120,6 +120,7 @@ SECTIONS
 
 	.data : AT(__data_loc) {
 		__data_start = .;	/* address in memory */
+		_sdata = .;
 
 		/*
 		 * first, the init task union, aligned
@@ -171,6 +172,7 @@ SECTIONS
 		__bss_start = .;	/* BSS				*/
 		*(.bss)
 		*(COMMON)
+		__bss_stop = .;
 		_end = .;
 	}
 					/* Stabs debugging sections.	*/

