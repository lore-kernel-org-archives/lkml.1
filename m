Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbXK1S6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbXK1S6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:58:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbXK1S5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:57:55 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59765 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbXK1S5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:57:54 -0500
Date: Wed, 28 Nov 2007 18:57:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] prep_zero_page: remove bogus BUG_ON
Message-ID: <Pine.LNX.4.64.0711281855230.25292@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.11 gave __GFP_ZERO's prep_zero_page a bogus "highmem may have to wait"
assertion.  Presumably added under the misconception that clear_highpage
uses nonatomic kmap; but then and now it uses kmap_atomic, so no problem.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
No need for this one in -stable: nobody hit it but me in making other changes.

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- 2.6.24-rc3-git/mm/page_alloc.c	2007-11-17 18:45:00.000000000 +0000
+++ linux/mm/page_alloc.c	2007-11-28 17:01:20.000000000 +0000
@@ -305,7 +305,6 @@ static inline void prep_zero_page(struct
 {
 	int i;
 
-	VM_BUG_ON((gfp_flags & (__GFP_WAIT | __GFP_HIGHMEM)) == __GFP_HIGHMEM);
 	/*
 	 * clear_highpage() will use KM_USER0, so it's a bug to use __GFP_ZERO
 	 * and __GFP_HIGHMEM from hard or soft interrupt context.
