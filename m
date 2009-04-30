Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZD3ITs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZD3ITs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbZD3ITL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:19:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:50195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZD3ITJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:19:09 -0400
Date: Thu, 30 Apr 2009 08:18:42 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240923650.1982.22.camel@penberg-laptop>
References: <1240923650.1982.22.camel@penberg-laptop>
Subject: [tip:x86/mm] x86: move per-cpu mmu_gathers to mm/init.c
Message-ID: <tip-9518e0e4350a5ea8ca200ce320b28d6284a7b0ce@git.kernel.org>
Git-Commit-ID: 9518e0e4350a5ea8ca200ce320b28d6284a7b0ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 08:18:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9518e0e4350a5ea8ca200ce320b28d6284a7b0ce
Gitweb:     http://git.kernel.org/tip/9518e0e4350a5ea8ca200ce320b28d6284a7b0ce
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Tue, 28 Apr 2009 16:00:50 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 10:12:37 +0200

x86: move per-cpu mmu_gathers to mm/init.c

[ Impact: cleanup ]

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <1240923650.1982.22.camel@penberg-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init.c    |    3 +++
 arch/x86/mm/init_32.c |    1 -
 arch/x86/mm/init_64.c |    2 --
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fedde53..4d67c33 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -9,6 +9,9 @@
 #include <asm/sections.h>
 #include <asm/system.h>
 #include <asm/tlbflush.h>
+#include <asm/tlb.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
 unsigned long __initdata e820_table_start;
 unsigned long __meminitdata e820_table_end;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index a640a7f..fef1d90 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -52,7 +52,6 @@
 #include <asm/page_types.h>
 #include <asm/init.h>
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 unsigned long highstart_pfn, highend_pfn;
 
 static noinline int do_test_wp_bit(void);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1016ea0..6a1a573 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -52,8 +52,6 @@
 
 static unsigned long dma_reserve __initdata;
 
-DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
-
 static int __init parse_direct_gbpages_off(char *arg)
 {
 	direct_gbpages = 0;
