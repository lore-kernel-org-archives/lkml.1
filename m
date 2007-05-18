Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXERS00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXERS00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbXERS0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:26:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59616 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753742AbXERS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:26:19 -0400
Date: Fri, 18 May 2007 11:26:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 06/10] xfs: inode defragmentation support
In-Reply-To: <20070518181119.997242349@sgi.com>
Message-ID: <Pine.LNX.4.64.0705181124430.11881@schroedinger.engr.sgi.com>
References: <20070518181040.465335396@sgi.com> <20070518181119.997242349@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rats. Missing a piece due to the need to change the parameters of
kmem_zone_init_flags (Isnt it possible to use kmem_cache_create 
directly?).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: slub/fs/xfs/xfs_vfsops.c
===================================================================
--- slub.orig/fs/xfs/xfs_vfsops.c	2007-05-18 11:23:27.000000000 -0700
+++ slub/fs/xfs/xfs_vfsops.c	2007-05-17 22:14:34.000000000 -0700
@@ -109,13 +109,13 @@ xfs_init(void)
 	xfs_inode_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_t), "xfs_inode",
 					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
-					KM_ZONE_SPREAD, NULL);
+					KM_ZONE_SPREAD, NULL, NULL);
 	xfs_ili_zone =
 		kmem_zone_init_flags(sizeof(xfs_inode_log_item_t), "xfs_ili",
-					KM_ZONE_SPREAD, NULL);
+					KM_ZONE_SPREAD, NULL, NULL);
 	xfs_chashlist_zone =
 		kmem_zone_init_flags(sizeof(xfs_chashlist_t), "xfs_chashlist",
-					KM_ZONE_SPREAD, NULL);
+					KM_ZONE_SPREAD, NULL, NULL);
 
 	/*
 	 * Allocate global trace buffers.

