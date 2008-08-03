Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYHCBml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYHCBml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 21:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYHCBmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 21:42:25 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:29930 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbYHCBmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 21:42:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEMAO6olEh5LDlw/2dsb2JhbACKY6JD
X-IronPort-AV: E=Sophos;i="4.31,298,1215354600"; 
   d="scan'208";a="162956948"
Date: Sun, 3 Aug 2008 11:42:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com
Subject: Re: [patch 15/19] Filesystem: XFS slab defragmentation
Message-ID: <20080803014218.GA6119@disturbed>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
	mpm@selenic.com
References: <20080801182324.572058187@lameter.com> <20080801182347.427403976@lameter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801182347.427403976@lameter.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 07:21:16PM -0700, Christoph Lameter wrote:
> Support inode defragmentation for xfs
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-31 12:18:12.000000000 -0500
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2008-07-31 12:18:15.000000000 -0500
> @@ -861,6 +861,7 @@
>  	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
>  	if (!xfs_ioend_zone)
>  		goto out_destroy_vnode_zone;
> +	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
>  
>  	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
>  						  xfs_ioend_zone);

I think that hunk is mis-applied. You're configuring the
xfs_vnode_zone defrag after allocating the xfs_ioend_zone. This
should be afew lines higher up, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
