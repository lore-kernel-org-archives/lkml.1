Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYK2Kpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYK2Kpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbYK2Kn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:43:56 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41381 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756181AbYK2Knz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:43:55 -0500
Subject: [PATCH 07/15] kmemleak: Add memleak_alloc callback from
	alloc_large_system_hash
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 10:43:45 +0000
Message-ID: <20081129104345.16726.67284.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:43:45.0970 (UTC) FILETIME=[5AE4C920:01C9520F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alloc_large_system_hash function is called from various places in
the kernel and it contains pointers to other allocated structures. It
therefore needs to be traced by kmemleak.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 mm/page_alloc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8ac014..90e7dbd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <linux/memleak.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -4570,6 +4571,8 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (_hash_mask)
 		*_hash_mask = (1 << log2qty) - 1;
 
+	memleak_alloc(table, size, 1);
+
 	return table;
 }
 

