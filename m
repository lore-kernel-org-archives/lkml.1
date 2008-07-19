Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYGSMav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYGSMav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYGSMah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:30:37 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYGSMag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:30:36 -0400
Date: Sat, 19 Jul 2008 15:30:25 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 2/8] slub: Replace ctor field with ops field in /sys/slab/*
Message-ID: <Pine.LNX.4.64.0807191530100.13345@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

Create an ops field in /sys/slab/*/ops to contain all the operations defined
on a slab. This will be used to display the additional operations that will
be defined soon.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 1b910ab..f21ffb9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3843,16 +3843,18 @@ static ssize_t order_show(struct kmem_cache *s, char *buf)
 }
 SLAB_ATTR(order);
 
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
@@ -4185,7 +4187,7 @@ static struct attribute *slab_attrs[] = {
 	&slabs_attr.attr,
 	&partial_attr.attr,
 	&cpu_slabs_attr.attr,
-	&ctor_attr.attr,
+	&ops_attr.attr,
 	&aliases_attr.attr,
 	&align_attr.attr,
 	&sanity_checks_attr.attr,
-- 
1.5.4.3

