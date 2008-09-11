Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYIKT0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYIKT0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYIKT0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:26:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17321 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752239AbYIKT0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:26:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:to:subject:message-id:mime-version:content-type:
	content-disposition:user-agent:from;
	b=nzDq4zQJJwKtabPhMzJ4v2cbOXqGMcJsua6vtVdsE7qdcvy+fYEqwpE2r1Wn8hAJw
	Q/3+HfiCMm2OEvhGB3KbA==
Date: Thu, 11 Sep 2008 12:25:41 -0700
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       penberg@cs.helsinki.fi
Subject: slub: fixed uninitialized counter in struct kmem_cache_node
Message-ID: <20080911192541.GA23822@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: sqazi@google.com (Salman Qazi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Initialized total objects atomic for the node in init_kmem_cache_node.  The uninitialized value was ruining the stats in /proc/slabinfo.

Signed-off-by: Salman Qazi <sqazi@google.com>
---

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1932,6 +1932,7 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
+	atomic_long_set(&n->total_objects, 0);
 	INIT_LIST_HEAD(&n->full);
 #endif
 }

