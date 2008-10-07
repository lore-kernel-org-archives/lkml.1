Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbYJGAwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbYJGAwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbYJGAoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:60628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097AbYJGAoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:15 -0400
Date: Mon, 6 Oct 2008 17:38:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>
Subject: [patch 32/71] x86-64: fix overlap of modules and fixmap areas
Message-ID: <20081007003847.GG3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-64-fix-overlap-of-modules-and-fixmap-areas.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jan Beulich <jbeulich@novell.com>

commit 66d4bdf22b8652cda215e2653c8bbec7a767ed57 upstream

Plus add a build time check so this doesn't go unnoticed again.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/head64.c     |    1 +
 include/asm-x86/pgtable_64.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -135,6 +135,7 @@ void __init x86_64_start_kernel(char * r
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
 				(__START_KERNEL & PGDIR_MASK)));
+	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
 
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -146,7 +146,7 @@ static inline void native_pgd_clear(pgd_
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
-#define MODULES_END      _AC(0xfffffffffff00000, UL)
+#define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
 #ifndef __ASSEMBLY__

-- 
