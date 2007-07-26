Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbXGZGWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbXGZGWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXGZGWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:22:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60609 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbXGZGWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:22:15 -0400
Date: Thu, 26 Jul 2007 08:23:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64: fix section mismatch warnings in tce
Message-ID: <20070726062330.GA1322@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following two section mismatch warnings:

WARNING: vmlinux.o(.text+0x1ce84): Section mismatch: reference to .init.text:free_bootmem (between 'free_tce_table' and 'build_tce_table')
WARNING: vmlinux.o(.text+0x1d04d): Section mismatch: reference to .init.text:__alloc_bootmem_low (between 'alloc_tce_table' and 'kretprobe_trampoline_holder')

In both cases the functions was used only from __init
context so mark them __init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
index 3aeae2f..acef53a 100644
--- a/arch/x86_64/kernel/tce.c
+++ b/arch/x86_64/kernel/tce.c
@@ -165,7 +165,7 @@ done:
 	return ret;
 }
 
-void* alloc_tce_table(void)
+void* __init alloc_tce_table(void)
 {
 	unsigned int size;
 
@@ -175,7 +175,7 @@ void* alloc_tce_table(void)
 	return __alloc_bootmem_low(size, size, 0);
 }
 
-void free_tce_table(void *tbl)
+void __init free_tce_table(void *tbl)
 {
 	unsigned int size;
 
