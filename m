Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXBBEJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXBBEJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 23:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964845AbXBBEJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 23:09:15 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:43948 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964812AbXBBEJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 23:09:14 -0500
Date: Fri, 2 Feb 2007 15:08:58 +1100
From: David Chinner <dgc@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Lameter <clameter@sgi.com>, Andrew Morton <akpm@osdl.org>,
       David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070202040858.GN33919298@melbourne.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org> <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com> <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com> <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com> <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com> <20070201191857.GQ10305@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201191857.GQ10305@kernel.dk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 08:18:57PM +0100, Jens Axboe wrote:
> That down() probably wants a replug to precede it. Probably something
> like:
> 
>         if (atomic_read(&bp->b_io_remaining))
>                 blk_replug_current_nested();
> 
> for xfs_buf_wait_unpin() and xfs_buf_lock(). Does this fix it?

Jens, this patch looks like you originally removed the explicit
unplug calls that XFS used to prevent metadata I/O hangs and now you
are putting them back.  Correct?

Reading on from Andrew's earlier comments, shouldn't XFS have
worked unchanged? I'm just trying to understand why you removed
the explicit unplugs in the first place.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
