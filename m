Return-Path: <linux-kernel-owner+w=401wt.eu-S1760125AbZEFOLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125AbZEFOLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758719AbZEFOL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:11:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37160 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbZEFOL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:11:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A00EF23.4050302@snapgear.com>
References: <4A00EF23.4050302@snapgear.com> <49FF96A7.5040401@snapgear.com> <3662.1241530861@redhat.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: BUG: failure at mm/nommu.c:518/add_nommu_region()
Date: Wed, 06 May 2009 15:11:19 +0100
Message-ID: <30031.1241619079@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can you try the attached patch, please?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Don't check vm_region::vm_start is page aligned in add_nommu_region()

Don't check vm_region::vm_start is page aligned in add_nommu_region() because
the region may reflect some non-page-aligned mapped file, such as could be
obtained from RomFS XIP.

Signed-off-by: David Howells <dhowells@redhat.com>
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
