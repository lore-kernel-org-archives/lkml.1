Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbXGMIjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbXGMIjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935880AbXGMIjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:39:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33651 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935376AbXGMIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:39:04 -0400
Date: Fri, 13 Jul 2007 16:37:32 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070713083732.GC21833@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com> <20070712221842.f5e47065.akpm@linux-foundation.org> <20070713064004.GA21833@joejin-pc.cn.oracle.com> <20070712234938.c77f3a48.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712234938.c77f3a48.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> if (nid > MAX_NUMNODES) then that is a bug and we should report it (doing
> this via a BUG() is OK) rather than quietly covering it up.

I have create a patch to check if nid > MAX_NUMNODES, please apply it
thanks

Signed-off-by: Joe Jin <joe.jin@oracle.com>
---

--- linux-2.6.22/include/linux/gfp.h.orig	2007-07-12 15:06:23.000000000 +0800
+++ linux-2.6.22/include/linux/gfp.h	2007-07-13 16:23:52.000000000 +0800
@@ -127,6 +127,8 @@ FASTCALL(__alloc_pages(gfp_t, unsigned i
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
+	BUG_ON(nid > MAX_NUMNODES);
+
 	if (unlikely(order >= MAX_ORDER))
 		return NULL;
 
