Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZEHG2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZEHG2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 02:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZEHG2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 02:28:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbZEHG2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 02:28:42 -0400
Date: Fri, 8 May 2009 02:28:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, a.beregalov@gmail.com
Subject: Re: [PATCH] xfs: fix double unlock in xfs_swap_extents()
Message-ID: <20090508062819.GB1689@infradead.org>
References: <1241745202-7452-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241745202-7452-1-git-send-email-felixb@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks good, but a little nitpick:

On Thu, May 07, 2009 at 08:13:22PM -0500, Felix Blyakher wrote:
>  out:
>  	kmem_free(tempifp);
>  	return error;
>  
> +out_unlock:
> +	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
> +	goto out;
> +
>  out_trans_cancel:
>  	xfs_trans_cancel(tp, 0);
>  	goto out_unlock;

this would be more readable as:

 out_trans_cancel:
	xfs_trans_cancel(tp, 0);
 out_unlock:
	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
	goto out;
