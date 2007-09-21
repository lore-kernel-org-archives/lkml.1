Return-Path: <linux-kernel-owner+w=401wt.eu-S1765433AbXIUU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765433AbXIUU5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763484AbXIUUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:35 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34764 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762767AbXIUUpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:22 -0400
Date: Fri, 21 Sep 2007 21:45:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] LBS: fix uninitialized swapper_space
In-Reply-To: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709212144210.13529@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Swapping crashed immediately: must initialize new fields of swapper_space.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc6-lbs/mm/swap_state.c	2007-07-26 19:49:58.000000000 +0100
+++ linux/mm/swap_state.c	2007-09-13 20:00:45.000000000 +0100
@@ -42,6 +42,10 @@ struct address_space swapper_space = {
 	.a_ops		= &swap_aops,
 	.i_mmap_nonlinear = LIST_HEAD_INIT(swapper_space.i_mmap_nonlinear),
 	.backing_dev_info = &swap_backing_dev_info,
+#ifdef CONFIG_LARGE_BLOCKSIZE
+	.shift		= PAGE_SHIFT,
+	.offset_mask	= PAGE_SIZE - 1,
+#endif
 };
 
 #define INC_CACHE_INFO(x)	do { swap_cache_info.x++; } while (0)
