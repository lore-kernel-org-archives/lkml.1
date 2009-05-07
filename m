Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZEGKnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZEGKnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbZEGKmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:42:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbZEGKmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:42:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Don't check vm_region::vm_start is page aligned in
	add_nommu_region()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Greg Ungerer <gerg@uclinux.org>
Date: Thu, 07 May 2009 11:41:37 +0100
Message-ID: <20090507104136.18257.56874.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't check vm_region::vm_start is page aligned in add_nommu_region() because
the region may reflect some non-page-aligned mapped file, such as could be
obtained from RomFS XIP.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
---

 mm/nommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/mm/nommu.c b/mm/nommu.c
index cdc6f60..325706b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -515,8 +515,6 @@ static void add_nommu_region(struct vm_region *region)
 
 	validate_nommu_regions();
 
-	BUG_ON(region->vm_start & ~PAGE_MASK);
-
 	parent = NULL;
 	p = &nommu_region_tree.rb_node;
 	while (*p) {

