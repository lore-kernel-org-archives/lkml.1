Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0BNWCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:02:44 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:43710 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751856Ab0BNWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:02:42 -0500
Date: Mon, 15 Feb 2010 09:02:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernl.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.32.3 x86_64 - XFS hangs, all I/O to D-state bug (again)
Message-ID: <20100214220229.GB28392@discord.disaster>
References: <alpine.DEB.2.00.1002110903080.25392@p34.internal.lan> <20100211145123.GA13114@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211145123.GA13114@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:51:23AM -0500, Christoph Hellwig wrote:
> Can you check if this still happens with the patch below?
> 
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:47:49.677253958 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2010-02-11 15:48:03.630005040 +0100
> @@ -1158,8 +1158,7 @@ _xfs_buf_ioapply(
>  		bp->b_flags &= ~_XBF_RUN_QUEUES;
>  		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
>  	} else {
> -		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
> -		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
> +		rw = (bp->b_flags & XBF_WRITE) ? WRITE : READ;
>  	}

We don't ever issue readahead on the AGF buffers, so I'm not sure
this will fix the hang. More often than not a hang like this
is caused by a write IO completion not occurring....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
