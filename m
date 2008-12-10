Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYLJRgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYLJRgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbYLJRgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:36:38 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:60891 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbYLJRgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:36:37 -0500
Subject: [PATCH] Do not pass the SLAB flags as GFP in slob kmem_cache_create
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matt Mackall <mpm@selenic.com>
Date: Wed, 10 Dec 2008 17:36:33 +0000
Message-ID: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 17:36:33.0469 (UTC) FILETIME=[D80476D0:01C95AED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks like the kmem_cache_create() function in the slob allocator
passes the SLAB flags as GFP flags to the slob_alloc() function. The
patch changes this call to pass GFP_KERNEL as the other allocators seem
to do.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matt Mackall <mpm@selenic.com>
---
 mm/slob.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index ff5a98d..dce9258 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -538,7 +538,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	struct kmem_cache *c;
 
 	c = slob_alloc(sizeof(struct kmem_cache),
-		flags, ARCH_KMALLOC_MINALIGN, -1);
+		GFP_KERNEL, ARCH_KMALLOC_MINALIGN, -1);
 
 	if (c) {
 		c->name = name;

