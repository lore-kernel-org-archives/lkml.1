Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYHMI3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYHMI3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYHMI31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:29:27 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:11431 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYHMI30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:29:26 -0400
Message-Id: <48A2B7BA.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 13 Aug 2008 09:30:18 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, <dhowells@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Propagate new nonpanic bootmem macros to
	CONFIG_HAVE_ARCH_BOOTMEM_NODE
References: <489721D1.76E4.0078.0@novell.com><489721D1.76E4.0078.0@novell.com> (Jan
 Beulich's message of "Mon, 04 Aug 2008 14:35:45 +0100")
 <87skt99vmz.fsf@skyscraper.fehenstaub.lan>
In-Reply-To: <87skt99vmz.fsf@skyscraper.fehenstaub.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not noticing this:
Acked-by: Jan Beulich <jbeulich@novell.com>

>>> Johannes Weiner <hannes@saeurebad.de> 13.08.08 10:17 >>>
Commit 74768ed833344b "page allocator: use no-panic variant of
alloc_bootmem() in alloc_large_system_hash()" introduced two new
_nopanic macros which are undefined for CONFIG_HAVE_ARCH_BOOTMEM_NODE.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---

These macros are a mess... :(

diff --git a/include/asm-x86/mmzone_32.h b/include/asm-x86/mmzone_32.h
index b2298a2..5862e64 100644
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
@@ -97,10 +97,16 @@ static inline int pfn_valid(int pfn)
 	reserve_bootmem_node(NODE_DATA(0), (addr), (size), (flags))
 #define alloc_bootmem(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_nopanic(x) \
+	__alloc_bootmem_node_nopanic(NODE_DATA(0), (x), SMP_CACHE_BYTES, \
+				__pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, 0)
 #define alloc_bootmem_pages(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_pages_nopanic(x) \
+	__alloc_bootmem_node_nopanic(NODE_DATA(0), (x), PAGE_SIZE, \
+				__pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x)					\

