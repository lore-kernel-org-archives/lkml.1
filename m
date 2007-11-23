Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXKWSCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXKWSCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 13:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbXKWSCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 13:02:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60568 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbXKWSCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 13:02:42 -0500
Date: Fri, 23 Nov 2007 18:02:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] Clean up open coded inode dirty checks
Message-ID: <20071123180239.GA13229@infradead.org>
References: <20071122004422.GO114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122004422.GO114266761@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
> +{
> +	return (((ip->i_itemp == NULL) ||
> +		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
> +		(ip->i_update_core == 0));
> +}

Can we please get rid of this useless STATIC_INLINE junk?  It's really
hurting my eyes.  As does to a lesser extent the verbose style of this
function.  This should be something like:

static inline int xfs_inode_clean(struct xfs_inode *ip)
{
	return (!ip->i_itemp ||
	        !(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
	       !ip->i_update_core;
}
