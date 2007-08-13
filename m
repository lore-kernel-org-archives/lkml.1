Return-Path: <linux-kernel-owner+w=401wt.eu-S965636AbXHMD3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbXHMD3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935552AbXHMD2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:28:47 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:53694 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935477AbXHMD2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:28:46 -0400
Date: Sun, 12 Aug 2007 23:23:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] Immediate Values - i386 Optimization - fix warnings
Message-ID: <20070813032338.GA21363@Krystal>
References: <20070812150702.769065566@polymtl.ca> <20070812150815.600419531@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070812150815.600419531@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:22:29 up 14 days,  3:41,  1 user,  load average: 0.91, 0.37, 0.47
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Immediate Values - i386 optimization - fix warnings

2 warnings creps in caused by my recent work with text lock edit.

arch/i386/kernel/immediate.c: In function 'arch_immediate_update':
arch/i386/kernel/immediate.c:228: warning: passing argument 1 of '__constant_memcpy' makes pointer from integer without a cast
arch/i386/kernel/immediate.c:228: warning: passing argument 1 of '__memcpy' makes pointer from integer without a cast
arch/i386/kernel/immediate.c:185: warning: unused variable 'bypass_immediate'

This trivial patch fixes this issue.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/kernel/immediate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/i386/kernel/immediate.c
===================================================================
--- linux-2.6-lttng.orig/arch/i386/kernel/immediate.c	2007-08-12 23:19:19.000000000 -0400
+++ linux-2.6-lttng/arch/i386/kernel/immediate.c	2007-08-12 23:19:56.000000000 -0400
@@ -182,7 +182,6 @@ __kprobes int arch_immediate_update(cons
 	int ret;
 	size_t insn_size = _immediate_get_insn_size(immediate->size);
 	long insn = immediate->immediate - insn_size;
-	long bypass_immediate;
 
 #ifdef CONFIG_KPROBES
 	/*
@@ -225,7 +224,7 @@ __kprobes int arch_immediate_update(cons
 	after_immediate = immediate->immediate + immediate->size;
 
 	kernel_text_mark_rw((unsigned long)bypass_eip, NR_NOPS);
-	memcpy(bypass_eip, (void*)insn, insn_size + immediate->size);
+	memcpy((void*)bypass_eip, (void*)insn, insn_size + immediate->size);
 	/*
 	 * Fill the rest with nops.
 	 */
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
