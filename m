Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab0AOUuH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116Ab0AOUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:50:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab0AOUuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:50:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=EP7dJqnEAEK1FfQovjC8ZtZi+pOonuthqmNHIjKxFg6B5bnSdwNkDod6cwKJmDkm4
	F8HRF+2QDjegEjhLJJtNA==
Date: Fri, 15 Jan 2010 12:49:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] slub: remove impossible condition
Message-ID: <alpine.DEB.2.00.1001151249040.11990@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`s' cannot be NULL if kmalloc_caches is not NULL.

This conditional would trigger a NULL pointer on `s', anyway, since it is
immediately derefernced if true.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2641,7 +2641,7 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 	if (slab_state >= SYSFS)
 		slabflags |= __SYSFS_ADD_DEFERRED;
 
-	if (!s || !text || !kmem_cache_open(s, flags, text,
+	if (!text || !kmem_cache_open(s, flags, text,
 			realsize, ARCH_KMALLOC_MINALIGN, slabflags, NULL)) {
 		s->size = 0;
 		kfree(text);
