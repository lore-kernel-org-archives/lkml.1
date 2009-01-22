Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbZAVXgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbZAVXgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbZAVXge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:36:34 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:30427 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307AbZAVXge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:36:34 -0500
Date: Fri, 23 Jan 2009 10:35:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Eric Sesterhenn <snakebyte@gmx.de>,
       Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, npiggin@yahoo.com.au, xfs@oss.sgi.com
Subject: Re: [PATCH] Re: Corrupted XFS log replay oops.
Message-ID: <20090122233542.GA32390@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Eric Sesterhenn <snakebyte@gmx.de>, Pavel Machek <pavel@suse.cz>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	npiggin@yahoo.com.au, xfs@oss.sgi.com
References: <20090113142147.GE16333@alice> <20090120173455.GC21339@alice> <20090121035703.GH10158@disturbed> <200901211503.07308.nickpiggin@yahoo.com.au> <20090122043747.GU10158@disturbed> <20090122061158.GA31104@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122061158.GA31104@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 01:11:58AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 22, 2009 at 03:37:47PM +1100, Dave Chinner wrote:
> >  xfs_buf_t *
> >  xlog_get_bp(
> >  	xlog_t		*log,
> > -	int		num_bblks)
> > +	int		nbblks)
> 
> Any reason for reanming this variable?  That causes quite a bit of
> churn.

Just so it was the same variable name as the other I/O functions
around it. It's kind of strange to have one function use num_bblks
and another 4 or so related functions use nbblks....

> >  {
> > -	ASSERT(num_bblks > 0);
> > +	if (nbblks <= 0 || nbblks > log->l_logBBsize) {
> > +		xlog_warn("XFS: Invalid block length (0x%x) given for buffer", nbblks);
> 
> And doesn't prevent this line from needing a linebreak to stay under 80
> characters :)

I'll respin it to fix this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
