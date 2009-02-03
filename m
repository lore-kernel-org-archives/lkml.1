Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZBCN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZBCN4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBCN4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:56:03 -0500
Received: from mail.suse.de ([195.135.220.2]:45212 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbZBCN4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:56:01 -0500
Date: Tue, 3 Feb 2009 14:55:59 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 1/2] slqb: fix small zero size alloc bug
Message-ID: <20090203135559.GA8723@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a problem where SLQB did not correctly return ZERO_SIZE_PTR for a
zero sized allocation.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 include/linux/slqb_def.h |    2 +-
 mm/slqb.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/slqb_def.h
===================================================================
--- linux-2.6.orig/include/linux/slqb_def.h
+++ linux-2.6/include/linux/slqb_def.h
@@ -237,7 +237,7 @@ static __always_inline struct kmem_cache
 
 	index = kmalloc_index(size);
 	if (unlikely(index == 0))
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	if (likely(!(flags & SLQB_DMA)))
 		return &kmalloc_caches[index];
