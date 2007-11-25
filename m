Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbXKYXaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbXKYXaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 18:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbXKYXaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 18:30:04 -0500
Received: from relay1.sgi.com ([192.48.171.29]:39257 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756336AbXKYXaB (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 18:30:01 -0500
Date: Mon, 26 Nov 2007 10:29:53 +1100
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9]: introduce radix_tree_gang_lookup_range
Message-ID: <20071125232953.GF114266761@sgi.com>
References: <20071122003211.GG114266761@sgi.com> <200711261017.24694.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711261017.24694.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 10:17:24AM +1100, Nick Piggin wrote:
> On Thursday 22 November 2007 11:32, David Chinner wrote:
> > Introduce radix_tree_gang_lookup_range()
> >
> > The inode clustering in XFS requires a gang lookup on the radix tree to
> > find all the inodes in the cluster.  The gang lookup has to set the
> > maximum items to that of a fully populated cluster so we get all the
> > inodes in the cluster, but we only populate the radix tree sparsely (on
> > demand).
> >
> > As a result, the gang lookup can search way, way past the index of end
> > of the cluster because it is looking for a fixed number of entries to
> > return.
> >
> > We know we want to terminate the search at either a specific index or a
> > maximum number of items, so we need to add a "last_index" parameter to
> > the lookup.
> 
> Yeah, this fixes one downside of the gang lookup API. For consistency
> it would be nice to do this for the tag lookup API as well...

Sure, I have need to do that as well. ;)

> > Furthermore, the existing radix_tree_gang_lookup() can use this same
> > function if we define a RADIX_TREE_MAX_INDEX value so the search is not
> > limited by the last_index.
> 
> Nit: should just define it to be ULONG_MAX.

Oh, right. Silly me. I'll post updated radix tree patches later today.

Thanks, Nick.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
