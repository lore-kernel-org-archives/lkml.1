Return-Path: <linux-kernel-owner+w=401wt.eu-S1758397AbZCSHnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758397AbZCSHnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZCSHnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:43:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:47663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbZCSHnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:43:09 -0400
Date: Thu, 19 Mar 2009 07:42:23 GMT
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090319103743N.fujita.tomonori@lab.ntt.co.jp>
References: <20090319103743N.fujita.tomonori@lab.ntt.co.jp>
Subject: [tip:core/iommu] dma-debug: warn of unmapping an invalid dma address
Message-ID: <tip-35d40952dba7b0689a16bd1463fb7698f8dbe639@git.kernel.org>
Git-Commit-ID: 35d40952dba7b0689a16bd1463fb7698f8dbe639
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 07:42:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35d40952dba7b0689a16bd1463fb7698f8dbe639
Gitweb:     http://git.kernel.org/tip/35d40952dba7b0689a16bd1463fb7698f8dbe639
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Thu, 19 Mar 2009 10:39:31 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 08:39:48 +0100

dma-debug: warn of unmapping an invalid dma address

Impact: extend DMA-debug checks

Calling dma_unmap families against an invalid dma address should be a
bug.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
LKML-Reference: <20090319103743N.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/dma-debug.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 9a350b4..f9e6d38 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -531,8 +531,11 @@ static void check_unmap(struct dma_debug_entry *ref)
 	struct hash_bucket *bucket;
 	unsigned long flags;
 
-	if (dma_mapping_error(ref->dev, ref->dev_addr))
+	if (dma_mapping_error(ref->dev, ref->dev_addr)) {
+		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
+			   "to free an invalid DMA memory address\n");
 		return;
+	}
 
 	bucket = get_hash_bucket(ref, &flags);
 	entry = hash_bucket_find(bucket, ref);
