Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbXFNXaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbXFNXaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXFNXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:30:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40895 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751108AbXFNXaN (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:30:13 -0400
Date: Fri, 15 Jun 2007 09:30:02 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Message-ID: <20070614233002.GG86004887@sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com> <20070614143248.736312f8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com> <20070614150417.c73fb6b9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614150417.c73fb6b9.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 03:04:17PM -0700, Andrew Morton wrote:
> fsck is single-threaded (hence no locking issues) and operates against the
> blockdev pagecache and does a _lot_ of small reads (indirect blocks,
> especially).

Commenting purely about the above statement (and not on large pages
or block sizes), xfs-repair has had multithreaded capability for some
time now. E.g. from the xfs_repair man page:

       -M    Disable  multi-threaded  mode. Normally, xfs_repair runs with
	     twice the number of threads as processors.


We have the second generation multithreading code out for review
right now. e.g:

http://oss.sgi.com/archives/xfs/2007-06/msg00069.html

xfs_repair also uses direct I/O and does it's own userspace block
caching and so avoids the problems involved with low memory, context
unaware cache reclaim and blockdev cache thrashing.

And to top it all off, some of the prefetch smarts we added result
in reading multiple sparse metadata blocks in a single, larger I/O,
so repair is now often bandwidth bound rather than seek bound...

All I'm trying to say here is that you shouldn't assume that the
problems a particular filesystem fsck has is common to all the
rest....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
