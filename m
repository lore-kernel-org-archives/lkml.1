Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYHLA0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYHLA0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYHLA0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:26:07 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:19534 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbYHLA0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:26:06 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2008 20:26:05 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOdyoEh5LAMb/2dsb2JhbACtFA
X-IronPort-AV: E=Sophos;i="4.32,192,1217773800"; 
   d="scan'208";a="179742577"
Date: Tue, 12 Aug 2008 10:20:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com
Subject: Re: [patch 15/19] Filesystem: XFS slab defragmentation
Message-ID: <20080812002057.GH6119@disturbed>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
	mpm@selenic.com
References: <20080811150616.207532384@quilx.com> <20080811150659.051842926@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811150659.051842926@quilx.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 08:06:31AM -0700, Christoph Lameter wrote:
> Support inode defragmentation for xfs
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-next/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- linux-next.orig/fs/xfs/linux-2.6/xfs_super.c	2008-08-11 07:42:11.892359719 -0700
> +++ linux-next/fs/xfs/linux-2.6/xfs_super.c	2008-08-11 07:47:05.072348463 -0700
> @@ -1947,6 +1947,7 @@ xfs_init_zones(void)
>  	xfs_ioend_zone = kmem_zone_init(sizeof(xfs_ioend_t), "xfs_ioend");
>  	if (!xfs_ioend_zone)
>  		goto out_destroy_vnode_zone;
> +	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);
>  
>  	xfs_ioend_pool = mempool_create_slab_pool(4 * MAX_BUF_PER_PAGE,
>  						  xfs_ioend_zone);

Please update this patch as per my last comment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
