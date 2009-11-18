Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZKRV1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZKRV1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZKRV1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:27:54 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:33192 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754938AbZKRV1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:27:53 -0500
Date: Thu, 19 Nov 2009 08:27:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/12] writeback: remove unused nonblocking and
	congestion checks (xfs)
Message-ID: <20091118212755.GM9467@discord.disaster>
References: <20091118082648.140755818@intel.com> <20091118082846.279046849@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118082846.279046849@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 04:26:55PM +0800, Wu Fengguang wrote:
> No one is calling wb_writeback and write_cache_pages with
> wbc.nonblocking=1 any more. And lumpy pageout will want to do
> nonblocking writeback without the congestion wait.

....

> --- linux.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-11-06 09:22:35.000000000 +0800
> +++ linux/fs/xfs/linux-2.6/xfs_aops.c	2009-11-06 09:52:21.000000000 +0800
> @@ -908,12 +908,8 @@ xfs_convert_page(
>  
>  			bdi = inode->i_mapping->backing_dev_info;
>  			wbc->nr_to_write--;
> -			if (bdi_write_congested(bdi)) {
> -				wbc->encountered_congestion = 1;

bdi is unused now, so can be removed as well. Otherwise looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
