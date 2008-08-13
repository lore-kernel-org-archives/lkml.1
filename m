Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYHMISG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYHMISG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYHMIRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:17:51 -0400
Received: from saeurebad.de ([85.214.36.134]:33264 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbYHMIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:17:50 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <linux-kernel@vger.kernel.org>, <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Propagate new nonpanic bootmem macros to CONFIG_HAVE_ARCH_BOOTMEM_NODE
References: <489721D1.76E4.0078.0@novell.com>
Date: Wed, 13 Aug 2008 10:17:24 +0200
In-Reply-To: <489721D1.76E4.0078.0@novell.com> (Jan Beulich's message of "Mon,
	04 Aug 2008 14:35:45 +0100")
Message-ID: <87skt99vmz.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
