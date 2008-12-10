Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbYLJS2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbYLJS2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYLJS1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:27:36 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33206 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756051AbYLJS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:27:35 -0500
Subject: [PATCH 07/15] kmemleak: Add memleak_alloc callback from
	alloc_large_system_hash
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 10 Dec 2008 18:27:33 +0000
Message-ID: <20081210182732.30323.39834.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:27:33.0278 (UTC) FILETIME=[F7CE43E0:01C95AF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The alloc_large_system_hash function is called from various places in
the kernel and it contains pointers to other allocated structures. It
therefore needs to be traced by kmemleak.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/page_alloc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8ac014..27efeb0 100644
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
 
+	memleak_alloc(table, size, 1, GFP_ATOMIC);
+
 	return table;
 }
 

