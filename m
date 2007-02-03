Return-Path: <linux-kernel-owner+w=401wt.eu-S1946268AbXBCCi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946268AbXBCCi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946259AbXBCCil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:41 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52958 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946263AbXBCCiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:09 -0500
Message-Id: <20070203024224.681516000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:34 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Linus Torvalds <torvalds@woody.linux-foundation.org>,
       Franck Bui-Huu <fbuihuu@gmail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@osdl.org>
Subject: [patch 30/59] Revert "[PATCH] Fix up mmap_kmem"
Content-Disposition: inline; filename=revert-fix-up-mmap_kmem.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Linus Torvalds <torvalds@woody.linux-foundation.org>

This reverts commit 99a10a60ba9bedcf5d70ef81414d3e03816afa3f.

As per Hugh Dickins:

  "Nadia Derbey has reported that mmap of /dev/kmem no longer works with
   the kernel virtual address as offset, and Franck has confirmed that
   his patch came from a misunderstanding of what an offset means to
   /dev/kmem - whereas his patch description seems to say that he was
   correcting the offset on a few plaforms, there was no such problem to
   correct, and his patch was in fact changing its API on all platforms."

Suggested-by: Hugh Dickins <hugh@veritas.com>
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andi Kleen <ak@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/char/mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/drivers/char/mem.c
+++ linux-2.6.19.2/drivers/char/mem.c
@@ -293,8 +293,8 @@ static int mmap_kmem(struct file * file,
 {
 	unsigned long pfn;
 
-	/* Turn a pfn offset into an absolute pfn */
-	pfn = PFN_DOWN(virt_to_phys((void *)PAGE_OFFSET)) + vma->vm_pgoff;
+	/* Turn a kernel-virtual address into a physical page frame */
+	pfn = __pa((u64)vma->vm_pgoff << PAGE_SHIFT) >> PAGE_SHIFT;
 
 	/*
 	 * RED-PEN: on some architectures there is more mapped memory

--
