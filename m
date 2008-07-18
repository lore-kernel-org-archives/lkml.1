Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYGROa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYGROa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYGROaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:30:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50931 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYGROaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:30:15 -0400
Date: Fri, 18 Jul 2008 17:29:58 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: mingo@elte.hu, cl@linux-foundation.org
Subject: [PATCH] slub: dump more data on slab corruption
Message-ID: <Pine.LNX.4.64.0807181729370.7723@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The limit to 128 bytes is too small when debugging slab corruption of the skb
cache, for example. Increase the limit to PAGE_SIZE to make debugging
corruptions sligthly easier.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-07-18 17:26:01.000000000 +0300
+++ linux-2.6/mm/slub.c	2008-07-18 17:26:09.000000000 +0300
@@ -492,7 +492,7 @@
 	if (p > addr + 16)
 		print_section("Bytes b4", p - 16, 16);
 
-	print_section("Object", p, min(s->objsize, 128));
+	print_section("Object", p, min_t(unsigned long, s->objsize, PAGE_SIZE));
 
 	if (s->flags & SLAB_RED_ZONE)
 		print_section("Redzone", p + s->objsize,
