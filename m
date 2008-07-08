Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYGHXPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYGHXPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYGHXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:38 -0400
Received: from gw.goop.org ([64.81.55.164]:51190 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbYGHXOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 55] pvops-64: call paravirt_post_allocator_init() on
	setup_arch()
X-Mercurial-Node: 3661a055938db063649665ce38837dd8e0cd14ce
Message-Id: <3661a055938db0636496.1215554784@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/setup.c |    1 +
 arch/x86/mm/init_32.c   |    2 --
 arch/x86/xen/mmu.c      |    8 +++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -796,6 +796,7 @@
 	paravirt_pagetable_setup_start(swapper_pg_dir);
 	paging_init();
 	paravirt_pagetable_setup_done(swapper_pg_dir);
+	paravirt_post_allocator_init();
 
 #ifdef CONFIG_X86_64
 	map_vsyscall();
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -867,8 +867,6 @@
 	 */
 	sparse_init();
 	zone_sizes_init();
-
-	paravirt_post_allocator_init();
 }
 
 /*
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -656,9 +656,11 @@
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
-/* The init_mm pagetable is really pinned as soon as its created, but
-   that's before we have page structures to store the bits.  So do all
-   the book-keeping now. */
+/*
+ * The init_mm pagetable is really pinned as soon as its created, but
+ * that's before we have page structures to store the bits.  So do all
+ * the book-keeping now.
+ */
 static __init int mark_pinned(struct page *page, enum pt_level level)
 {
 	SetPagePinned(page);


