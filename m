Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZCFPux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZCFPux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZCFPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:50:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:38167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbZCFPum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:50:42 -0500
Subject: [PATCH -tip] x86: fix undefined linking reference of nx_enabled
 for 64 bit
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 21:19:42 +0530
Message-Id: <1236354582.25265.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: fix undefined linking reference of nx_enabled for 64 bit

  LD      .tmp_vmlinux1
arch/x86/mm/built-in.o: In function `init_memory_mapping':
(.ref.text+0x73): undefined reference to `nx_enabled'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/mm/init.c    |    2 ++
 arch/x86/mm/init_32.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index acdfba8..9799a1c 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -49,6 +49,8 @@ static int __init noexec_setup(char *str)
 early_param("noexec", noexec_setup);
 #endif
 
+int nx_enabled;
+
 #ifdef CONFIG_X86_PAE
 static void __init set_nx(void)
 {
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 26a135f..a8458b9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -587,8 +587,6 @@ void zap_low_mappings(void)
 	flush_tlb_all();
 }
 
-int nx_enabled;
-
 pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
 EXPORT_SYMBOL_GPL(__supported_pte_mask);
 
-- 
1.6.0.6



