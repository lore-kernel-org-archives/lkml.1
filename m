Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYG0NoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYG0NoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 09:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYG0NoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 09:44:03 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:60495 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYG0NoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:44:01 -0400
Date: Sun, 27 Jul 2008 14:43:38 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Adrian Bunk <bunk@kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] exec: include pagemap.h again to fix build
In-Reply-To: <Pine.LNX.4.64.0807271437330.32444@blonde.site>
Message-ID: <Pine.LNX.4.64.0807271441010.32444@blonde.site>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
 <20080726173832.GE9301@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0807261852050.582@blonde.site>
 <20080726125025.465d524b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0807262104060.13201@blonde.site> <20080726132610.6c583346.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0807262132460.15972@blonde.site> <20080726204218.GG9301@cs181140183.pp.htv.fi>
 <Pine.LNX.4.64.0807262155160.17736@blonde.site> <20080727130410.GI9301@cs181140183.pp.htv.fi>
 <Pine.LNX.4.64.0807271437330.32444@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation errors on avr32 and without CONFIG_SWAP, introduced by
ba92a43dbaee339cf5915ef766d3d3ffbaaf103c exec: remove some includes

In file included from include/asm/tlb.h:24,
                 from fs/exec.c:55:
include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
include/asm-generic/tlb.h: In function 'tlb_remove_page':
include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
make[1]: *** [fs/exec.o] Error 1

This straightforward part-revert is nobody's favourite patch to address
the underlying tlb.h needs swap.h needs pagemap.h (but sparc won't like
that) mess; but appropriate to fix the build now before any overhaul.

Reported-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Reported-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Tested-by: Adrian Bunk <bunk@kernel.org>
---

 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

--- 2.6.26-git/fs/exec.c	2008-07-26 12:33:28.000000000 +0100
+++ linux/fs/exec.c	2008-07-26 18:50:38.000000000 +0100
@@ -32,6 +32,7 @@
 #include <linux/swap.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
 #include <linux/key.h>
