Return-Path: <linux-kernel-owner+w=401wt.eu-S1765000AbZDHSdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765000AbZDHSdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbZDHScy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:32:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46858 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZDHScx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:32:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
To: jeremy@goop.org, mingo@elte.hu, akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       nickpiggin@yahoo.com.au, tglx@linutronix.de, dhowells@redhat.com,
       ysato@users.sourceforge.jp
Date: Wed, 08 Apr 2009 19:30:11 +0100
Message-ID: <20090408183011.24150.43310.stgit@warthog.procyon.org.uk>
In-Reply-To: <21081.1239214221@redhat.com>
References: <21081.1239214221@redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-frv/pgtable.h could just #include <asm-generic/pgtable.h> in NOMMU mode
rather than #defining macros for lazy MMU and CPU stuff.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/pgtable.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index e16fdb1..3323301 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -71,10 +71,8 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define swapper_pg_dir		((pgd_t *) NULL)
 
 #define pgtable_cache_init()		do {} while (0)
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
+
+#include <asm-generic/pgtable.h>
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/

