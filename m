Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409Ab0A2Uvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab0A2Uvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246Ab0A2Uvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:31 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42822 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab0A2UvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:22 -0500
Message-Id: <20100129204959.074588549@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:33 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub: Replace ctor field with ops field in /sys/slab/*
Content-Disposition: inline; filename=slub_replace_ctor_field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an ops field in /sys/slab/*/ops to contain all the operations defined
on a slab. This will be used to display the additional operations that will
be defined soon.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-01-29 10:27:09.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-01-29 10:27:14.000000000 -0600
@@ -4089,16 +4089,18 @@ static ssize_t min_partial_store(struct 
 }
 SLAB_ATTR(min_partial);
 
-static ssize_t ctor_show(struct kmem_cache *s, char *buf)
+static ssize_t ops_show(struct kmem_cache *s, char *buf)
 {
-	if (s->ctor) {
-		int n = sprint_symbol(buf, (unsigned long)s->ctor);
+	int x = 0;
 
-		return n + sprintf(buf + n, "\n");
+	if (s->ctor) {
+		x += sprintf(buf + x, "ctor : ");
+		x += sprint_symbol(buf + x, (unsigned long)s->ctor);
+		x += sprintf(buf + x, "\n");
 	}
-	return 0;
+	return x;
 }
-SLAB_ATTR_RO(ctor);
+SLAB_ATTR_RO(ops);
 
 static ssize_t aliases_show(struct kmem_cache *s, char *buf)
 {
@@ -4448,7 +4450,7 @@ static struct attribute *slab_attrs[] = 
 	&slabs_attr.attr,
 	&partial_attr.attr,
 	&cpu_slabs_attr.attr,
-	&ctor_attr.attr,
+	&ops_attr.attr,
 	&aliases_attr.attr,
 	&align_attr.attr,
 	&sanity_checks_attr.attr,

-- 
