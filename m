Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbZBRMGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbZBRMGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZBRMFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:50731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbZBRMFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:36 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] vmalloc: call flush_cache_vunmap() from unmap_kernel_range()
Date: Wed, 18 Feb 2009 21:04:27 +0900
Message-Id: <1234958676-27618-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:04:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: proper vcache flush on unmap_kernel_range()

flush_cache_vunmap() should be called before pages are unmapped.  Add
a call to it in unmap_kernel_range().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/vmalloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 75f49d3..c37924a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1012,6 +1012,8 @@ void __init vmalloc_init(void)
 void unmap_kernel_range(unsigned long addr, unsigned long size)
 {
 	unsigned long end = addr + size;
+
+	flush_cache_vunmap(addr, end);
 	vunmap_page_range(addr, end);
 	flush_tlb_kernel_range(addr, end);
 }
-- 
1.6.0.2

