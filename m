Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0BNUcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 15:32:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:43504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0BNUcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 15:32:19 -0500
Message-ID: <4B785D85.3000408@kernel.org>
Date: Sun, 14 Feb 2010 12:31:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 16/35] x86: make 64 bit use early_res instead of bootmem
 before slab
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	<1265793639-15071-17-git-send-email-yinghai@kernel.org> <20100215010833.15f9e09a.sfr@canb.auug.org.au>
In-Reply-To: <20100215010833.15f9e09a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

Subject: [PATCH] x86: nobootmem fix compiling on power pc

Stephen Rothwell reported: on powerpc

x86: make 64 bit use early_res instead of bootmem before slab

cause

mm/page_alloc.c:3468: error: implicit declaration of function 'find_early_area'
mm/page_alloc.c:3483: error: implicit declaration of function 'reserve_early_without_check'

actually the function is only needed for no_bootmem

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3456,6 +3456,7 @@ int __init add_from_early_node_map(struc
 	return nr_range;
 }
 
+#ifdef CONFIG_NO_BOOTMEM
 void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit)
 {
@@ -3492,6 +3493,7 @@ void * __init __alloc_memory_core_early(
 
 	return NULL;
 }
+#endif
 
 
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
