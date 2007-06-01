Return-Path: <linux-kernel-owner+w=401wt.eu-S1761056AbXFARAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761056AbXFARAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbXFARAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:00:13 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758323AbXFARAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:00:11 -0400
Date: Fri, 1 Jun 2007 10:00:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1: IA64 make allnoconfig broken
Message-Id: <20070601100004.1e72654d.akpm@linux-foundation.org>
In-Reply-To: <20070601164204.GA25049@skynet.ie>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<20070601164204.GA25049@skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 17:42:04 +0100 mel@skynet.ie (Mel Gorman) wrote:

> mm/memory.c: In function `do_wp_page':
> mm/memory.c:1700: error: parse error before "__changed"
> mm/memory.c:1700: error: parse error before ')' token
> mm/memory.c:1704: error: parse error before "ret"

this?

--- a/include/asm-ia64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c-fix
+++ a/include/asm-ia64/pgtable.h
@@ -546,7 +546,7 @@ extern void lazy_mmu_prot_update (pte_t 
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
 ({										\
 	int __changed = !pte_same(*(__ptep), __entry);				\
-	if (__changed) {							\
+	if (__changed)							\
 		ptep_establish(__vma, __addr, __ptep, __entry)			\
 	__changed;								\
 })

