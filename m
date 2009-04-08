Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbZDHP2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbZDHP2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933647AbZDHP01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:26:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:52414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422AbZDHP0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:26:23 -0400
Date: Wed, 8 Apr 2009 15:24:43 GMT
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       galak@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       tglx@linutronix.de, beckyb@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
Subject: [tip:core/iommu] swiotlb: fix compile warning
Message-ID: <tip-67131ad0514d7105b55003a0506209cf1bba3f00@git.kernel.org>
Git-Commit-ID: 67131ad0514d7105b55003a0506209cf1bba3f00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 15:24:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67131ad0514d7105b55003a0506209cf1bba3f00
Gitweb:     http://git.kernel.org/tip/67131ad0514d7105b55003a0506209cf1bba3f00
Author:     Becky Bruce <beckyb@kernel.crashing.org>
AuthorDate: Wed, 8 Apr 2009 09:09:16 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 16:18:35 +0200

swiotlb: fix compile warning

Squash a build warning seen on 32-bit powerpc caused by
calling min() with 2 different types. Use min_t() instead.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Cc: jeremy@goop.org
Cc: ian.campbell@citrix.com
LKML-Reference: <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/swiotlb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 170cf56..4fd6a76 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 		unsigned long flags;
 
 		while (size) {
-			sz = min(PAGE_SIZE - offset, size);
+			sz = min_t(size_t, PAGE_SIZE - offset, size);
 
 			local_irq_save(flags);
 			buffer = kmap_atomic(pfn_to_page(pfn),
