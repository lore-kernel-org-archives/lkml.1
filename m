Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZCENlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZCENlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZCENiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:38:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:49970 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbZCENiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:38:22 -0500
Date: Thu, 5 Mar 2009 13:37:52 GMT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236257708-27269-10-git-send-email-penberg@cs.helsinki.fi>
References: <1236257708-27269-10-git-send-email-penberg@cs.helsinki.fi>
Subject: [tip:x86/mm] x86: ifdef 32-bit and 64-bit setup in init_memory_mapping()
Message-ID: <tip-01ced9ec14ad1b4f8a533c2f2b5a4fe4c92c1099@git.kernel.org>
Git-Commit-ID: 01ced9ec14ad1b4f8a533c2f2b5a4fe4c92c1099
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 13:37:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01ced9ec14ad1b4f8a533c2f2b5a4fe4c92c1099
Gitweb:     http://git.kernel.org/tip/01ced9ec14ad1b4f8a533c2f2b5a4fe4c92c1099
Author:     "Pekka Enberg" <penberg@cs.helsinki.fi>
AuthorDate: Thu, 5 Mar 2009 14:55:01 +0200
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 14:17:15 +0100

x86: ifdef 32-bit and 64-bit setup in init_memory_mapping()

Impact: cleanup

To reduce the diff between the 32-bit and 64-bit versions of
init_memory_mapping(), ifdef configuration specific setup code
in the function.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236257708-27269-10-git-send-email-penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |    6 ++++++
 arch/x86/mm/init_64.c |    8 ++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0a3707f..3f91bdc 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1054,10 +1054,16 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 						   mr[i].page_size_mask);
 #endif
 
+#ifdef CONFIG_X86_32
 	early_ioremap_page_table_range_init();
 
 	load_cr3(swapper_pg_dir);
+#endif
 
+#ifdef CONFIG_X86_64
+	if (!after_bootmem)
+		mmu_cr4_features = read_cr4();
+#endif
 	__flush_tlb_all();
 
 	if (!after_bootmem && table_end > table_start)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e4fadea..5ecb23a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -832,8 +832,16 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 						   mr[i].page_size_mask);
 #endif
 
+#ifdef CONFIG_X86_32
+	early_ioremap_page_table_range_init();
+
+	load_cr3(swapper_pg_dir);
+#endif
+
+#ifdef CONFIG_X86_64
 	if (!after_bootmem)
 		mmu_cr4_features = read_cr4();
+#endif
 	__flush_tlb_all();
 
 	if (!after_bootmem && table_end > table_start)
