Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXKGDHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXKGDHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXKGDHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:07:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37455 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755247AbXKGDHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:07:16 -0500
Date: Tue, 6 Nov 2007 19:07:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@kernel.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@skynet.ie>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [patch 09/23] SLUB: Add get() and kick() methods
In-Reply-To: <20071107023709.GU26163@stusta.de>
Message-ID: <Pine.LNX.4.64.0711061906290.5565@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011228.605750914@sgi.com>
 <20071107023709.GU26163@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Adrian Bunk wrote:

> A static inline dummy function for CONFIG_SLUB=n seems to be missing?

Correct. This patch is needed so that building with SLAB will work.


Slab defrag: Provide empty kmem_cache_setup_defrag function for SLAB.

Provide an empty function to satisfy dependencies for Slab defrag.

Signed-off-by: Christoph Lameter <clameter@sgi.com>?

---
 mm/slab.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c	2007-11-06 18:57:22.000000000 -0800
+++ linux-2.6/mm/slab.c	2007-11-06 18:58:40.000000000 -0800
@@ -2535,6 +2535,13 @@ static int __cache_shrink(struct kmem_ca
 	return (ret ? 1 : 0);
 }
 
+void kmem_cache_setup_defrag(struct kmem_cache *s,
+	void *(*get)(struct kmem_cache *, int nr, void **),
+	void (*kick)(struct kmem_cache *, int nr, void **, void *private))
+{
+}
+EXPORT_SYMBOL(kmem_cache_setup_defrag);
+
 /**
  * kmem_cache_shrink - Shrink a cache.
  * @cachep: The cache to shrink.
