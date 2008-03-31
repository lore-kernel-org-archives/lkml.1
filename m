Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYCaSuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYCaSuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYCaSt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:49:56 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47838 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753044AbYCaStz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:49:55 -0400
Date: Mon, 31 Mar 2008 11:47:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: build issue for v2.6.25-rc7-187-ga9edadb in mm/slub.c
In-Reply-To: <200803311459.56037.toralf.foerster@gmx.de>
Message-ID: <Pine.LNX.4.64.0803311146280.6510@schroedinger.engr.sgi.com>
References: <200803311459.56037.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this fix things?


Subject: Fix undefined count_partial of !CONFIG_SLABINFO

Typo in the check if we need the count_partial function that was 
introduced by 53625b4204753b904addd40ca96d9ba802e6977d

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-03-31 11:29:28.000000000 -0700
+++ linux-2.6/mm/slub.c	2008-03-31 11:32:23.000000000 -0700
@@ -2688,7 +2688,7 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
-#if defined(SLUB_DEBUG) || defined(CONFIG_SLABINFO)
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SLABINFO)
 static unsigned long count_partial(struct kmem_cache_node *n)
 {
 	unsigned long flags;

