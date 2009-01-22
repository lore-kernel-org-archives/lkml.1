Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbZAVXho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbZAVXho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZAVXhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:37:36 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:31175 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307AbZAVXhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:37:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai4EAAuQeEl5LAUpgWdsb2JhbACTegEBFiK2XYVz
X-IronPort-AV: E=Sophos;i="4.37,309,1231075800"; 
   d="scan'208";a="273367713"
Date: Fri, 23 Jan 2009 10:37:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Pavel Machek <pavel@suse.cz>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       npiggin@yahoo.com.au, xfs@oss.sgi.com
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122233717.GB32390@disturbed>
Mail-Followup-To: Eric Sesterhenn <snakebyte@gmx.de>,
	Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>, Pavel Machek <pavel@suse.cz>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	npiggin@yahoo.com.au, xfs@oss.sgi.com
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed> <200901211503.07308.nickpiggin@yahoo.com.au> <20090122043747.GU10158@disturbed> <20090122061158.GA31104@infradead.org> <20090122100648.GA16660@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122100648.GA16660@alice>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 11:06:48AM +0100, Eric Sesterhenn wrote:
> * Christoph Hellwig (hch@infradead.org) wrote:
> > On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> > >  xfs_buf_t *
> > >  xlog_get_bp(
> > >  	xlog_t		*log,
> > > -	int		num_bblks)
> > > +	int		nbblks)
> > 
> > Any reason for reanming this variable?  That causes quite a bit of
> > churn.
> > 
> > >  {
> > > -	ASSERT(num_bblks > 0);
> > > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> > 
> > And doesn't prevent this line from needing a linebreak to stay under 80
> > characters :)
> > 
> > Except for these nitpicks it looks fine to me.
> 
> Using the image at http://www.cccmz.de/~snakebyte/xfs.254.img.bz2
> I was able to produce a pretty similar error with the patch applied

Different problem, obviously. ;)

I'll have a look at this later today....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
