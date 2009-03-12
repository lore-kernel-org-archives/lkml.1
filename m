Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZCLNNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZCLNNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZCLNNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:13:13 -0400
Received: from phunq.net ([64.81.85.152]:60102 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752114AbZCLNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:13:12 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 06:12:58 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <20090312123230.GA14425@parisc-linux.org> <200903122345.13787.nickpiggin@yahoo.com.au>
In-Reply-To: <200903122345.13787.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120612.58643.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Nick Piggin wrote:
> On Thursday 12 March 2009 23:32:30 Matthew Wilcox wrote:
> > On Thu, Mar 12, 2009 at 05:24:33AM -0700, Daniel Phillips wrote:
> > > On Thursday 12 March 2009, Nick Piggin wrote:
> > > > That's interesting. Do you handle 1K block sizes with 64K page size? :)
> > >
> > > Not in its current incarnation.  That would require 32 bytes worth of
> > > state while the current code just has a 4 byte map (4 bits X 8 blocks).
> > > I suppose a reasonable way to extend it would be 4 x 8 byte maps.  Has
> > > somebody spotted a 64K page?
> >
> > I believe SGI ship their ia64 kernels configured this way.  Certainly
> > 16k ia64 kernels are common, which would (if I understand your scheme
> > correctly) be 8 bytes worth of state in your scheme.
> 
> I think some distros will (or do) ship configs with 64K page size for
> ia64 and powerpc too. I think I have heard of people using 64K pages
> with ARM. There was some (public) talk of x86-64 getting a 16K or 64K
> page size too (and even if not HW, some people want to be able to go
> bigger SW pagecache size).
> 
> I wouldn't expect 64K page and 1K block to be worth optimising for
> (although 64K page systems could easily use older or shared 4K block
> filesystems). But just keep in mind that a good solution should not
> rely on PAGE_CACHE_SIZE for correctness.

Not worth optimizing for, but it better work.  Which the current nasty
circular buffer list will, and I better keep that in mind for the next
round of effort on block handles.

On the other hand, 4K blocks on 64K pages better work really well or
those 64K systems will be turkeys.

Regards,

Daniel
