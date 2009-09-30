Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbZI3Ema@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbZI3Ema (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 00:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZI3Em3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 00:42:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61287 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZI3Em3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 00:42:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=f54GmmKb1Cp7hVkbCL3zIcla3mNYz9AxKv9HDrtxeQleypb1xvAt7dNZoxFqyhD1K
	rZ7NR6UI6C+2lbFcz5FeQ==
Date: Tue, 29 Sep 2009 21:42:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: [patch] slqb: remove unnecessary conditional in kmem_cache_create
Message-ID: <alpine.DEB.1.00.0909292141550.3686@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_open() panics when a SLAB_PANIC cache cannot be opened because
it has early callers using the flag that do not go through
kmem_cache_create().

If kmem_cache_open() fails for a SLAB_PANIC cache, it would have panicked
the machine.  Thus, checking for this flag in kmem_cache_create() is
unnecessary in the error patch since it is always clear.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slqb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -3077,9 +3077,6 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 
 err:
 	up_write(&slqb_lock);
-	if (flags & SLAB_PANIC)
-		panic("%s: failed to create slab `%s'\n", __func__, name);
-
 	return NULL;
 }
 EXPORT_SYMBOL(kmem_cache_create);
