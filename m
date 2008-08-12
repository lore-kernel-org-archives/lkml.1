Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbYHLSXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbYHLSXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYHLSXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:23:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbYHLSW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:22:59 -0400
Message-ID: <48A1D4A0.2030109@linux-foundation.org>
Date: Tue, 12 Aug 2008 13:21:20 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, mpm@selenic.com
Subject: Re: [patch 15/19] Filesystem: XFS slab defragmentation
References: <20080811150616.207532384@quilx.com> <20080811150659.051842926@quilx.com> <20080812002057.GH6119@disturbed> <48A136D7.4080505@cs.helsinki.fi>
In-Reply-To: <48A136D7.4080505@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
>
>>
>> Please update this patch as per my last comment.
> 
> Christoph, I'm dropping this patch from my tree.

Just apply this patch:

Subject: defrag/xfs: Move defrag setup directly after xfs_vnode_zone kmem
cache creation

Move the setup of the defrag directly after the creation of the xfs_vnode_zone

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2008-08-04 08:27:09.000000000
-0500
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2008-08-04 08:27:25.000000000 -0500
@@ -2021,11 +2021,11 @@
 	if (!xfs_vnode_zone)
 		goto out;

+	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
+
 	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
 	if (!xfs_ioend_zone)
 		goto out_destroy_vnode_zone;
-	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
-
 	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
 						  xfs_ioend_zone);
 	if (!xfs_ioend_pool)
