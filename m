Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYFAF5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYFAF5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 01:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbYFAF5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 01:57:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:9278 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYFAF5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 01:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Bf5Ves/VbB05gRsEmvhmZoQYn6waarPctnaAQe1SQlJCk6BflNEXZc8aRfOmjLOEbWB4N/R1b5T869GH5RPCq7CgEt2IZp6LmjEiRH03LoSGbZsLfTqoW4ytpQza1JoU7RaM9N5wTxTwoH7LWwYem744NBBaTHWkgnQM4miJXe8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: set node_remap_size[0] in fallback path
Date: Sat, 31 May 2008 22:53:47 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805312251.52297.yhlu.kernel@gmail.com> <200805312252.47727.yhlu.kernel@gmail.com>
In-Reply-To: <200805312252.47727.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805312253.47939.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


otherwise alloc_remap will not get node_mem_map from kva area, and
alloc_node_mem_map has to alloc_bootmem_node get mem_map.
it will use two copies low address...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

--- a/arch/x86/mm/discontig_32.c	2008-05-31 21:46:14.000000000 -0700
+++ b/arch/x86/mm/discontig_32.c	2008-05-31 21:49:02.000000000 -0700
@@ -124,6 +124,7 @@ int __init get_memcfg_numa_flat(void)
 	node_start_pfn[0] = 0;
 	node_end_pfn[0] = max_pfn;
 	memory_present(0, 0, max_pfn);
+	node_remap_size[0] = node_memmap_size_bytes(0, 0, max_pfn);
 
         /* Indicate there is one node available. */
 	nodes_clear(node_online_map);
