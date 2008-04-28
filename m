Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbYD1Dd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbYD1Dd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762229AbYD1DdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:33:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53408 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762199AbYD1DdS (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:33:18 -0400
Date: Mon, 28 Apr 2008 13:32:49 +1000
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080428033249.GE103491721@sgi.com>
References: <200804261651.02078.vda.linux@googlemail.com> <20080427234056.GA108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427234056.GA108924158@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:40:56AM +1000, David Chinner wrote:
> On Sat, Apr 26, 2008 at 04:51:02PM +0200, Denys Vlasenko wrote:
> > Hi David,
> > 
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> 
> Can you please attach your patches inline, Denys (see
> Documentation/SubmittingPatches)?
> 
> > This results in some variables not taking stack space in
> > xfs_bmap_btalloc() anymore.
> > 
> > The helper itself does not call anything stack-deep.
> > Stack-deep call to xfs_alloc_vextent() happen
> > in xfs_bmap_btalloc(), as before.
> 
> I have a set of patches that introduces new functionality into the
> allocator (dynamic allocation policies) that reduces
> xfs_bmap_btalloc() function by 36 bytes (just by chance, I didn't
> design it for this purpose). It breaks it down on functional
> boundaries like Christoph's patch. I'm going to revist that patch
> w.r.t both these patches and see what falls out the bottom...

44 bytes saved in xfs_bmap_btalloc with the same factoring as
Christoph's patch being done. Given that most of this is now
the struct xfs_alloc_arg, I don't think this will be reduced a whole
lot more. I think I might be able to kill the tryagain and isaligned
variables as well which will save another 8 bytes, but I'll leave
that for later....

Good progress, folks.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
