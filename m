Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbZGVJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbZGVJEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZGVJEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:04:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbZGVJEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:04:21 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: penberg@cs.helsinki.fi, cl@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] slub: sysfs_slab_remove should free kmem_cache when debug is enabled
Date: Wed, 22 Jul 2009 17:03:57 +0800
Message-Id: <1248253437-23313-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_destroy use sysfs_slab_remove to release the kmem_cache,
but when CONFIG_SLUB_DEBUG is enabled, sysfs_slab_remove just release
related kobject, the whole kmem_cache is missed to release and cause
a memory leak.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 mm/slub.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..05b69fd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4559,6 +4559,7 @@ static void sysfs_slab_remove(struct kmem_cache *s)
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 	kobject_put(&s->kobj);
+	kfree(s);
 }
 
 /*
-- 
1.6.2.5

