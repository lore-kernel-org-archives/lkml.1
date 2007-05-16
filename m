Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbXEPNOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbXEPNOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXEPNOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:14:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48185 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXEPNN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:13:59 -0400
Date: Wed, 16 May 2007 09:10:25 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Woodhouse <dwmw2@infradead.org>, David Howells <dhowells@redhat.com>,
       David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
Message-ID: <20070516131025.GU26766@think.oraclecorp.com>
References: <20070318233008.GA32597093@melbourne.sgi.com> <18993.1179310769@redhat.com> <1179317360.2859.225.camel@shinybook.infradead.org> <20070516125341.GS26766@think.oraclecorp.com> <464B014B.20109@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B014B.20109@yahoo.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:04:11PM +1000, Nick Piggin wrote:
> Chris Mason wrote:
> >On Wed, May 16, 2007 at 08:09:19PM +0800, David Woodhouse wrote:
> >
> >>On Wed, 2007-05-16 at 11:19 +0100, David Howells wrote:
> >>
> >>>The start and end points passed to block_prepare_write() delimit the 
> >>>region of
> >>>the page that is going to be modified.  This means that prepare_write()
> >>>doesn't need to fill it in if the page is not up to date. 
> >>
> >>Really? Is it _really_ going to be modified? Even if the pointer
> >>userspace gave to write() is bogus, and is going to fault half-way
> >>through the copy_from_user()?
> >
> >
> >This is why there are so many variations on copy_from_user that zero on
> >faults.  One way or another, the prepare_write/commit_write pair are
> >responsible for filling it in.
> 
> I'll add to David's question about David's comment on David's patch, yes
> it will be modified but in that case it would be zero-filled as Chris
> says. However I believe this is incorrect behaviour.
> 
> It is possible to easily fix that so it would only happen via a tiny race
> window (where the source memory gets unmapped at just the right time)
> however nobody seemed to interested (just by checking the return value of
> fault_in_pages_readable).
> 
> The buffered write patches I'm working on fix that (among other things) of
> course. But they do away with prepare_write and introduce new aops, and
> they indeed must not expect the full range to have been written to.

I was also wrong to say prepare_write and commit_write are
responsible, they work together with their callers to make the right
things happen.  Oh well, so much for trying to give a short answer for a
chunk of code full of corner cases ;)

-chris

