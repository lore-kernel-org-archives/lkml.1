Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZBZQ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZBZQ7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZBZQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:58:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33476 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbZBZQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:58:41 -0500
Date: Thu, 26 Feb 2009 17:58:39 +0100
From: Jan Kara <jack@suse.cz>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
       linux-xfs <linux-xfs@oss.sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: XFS kernel BUG at fs/buffer.c:470! with 2.6.28.4
Message-ID: <20090226165838.GA9602@atrey.karlin.mff.cuni.cz>
References: <1234011974.7435.11.camel@champagne.cantina> <20090208222859.GA2532@infradead.org> <1234132752.12370.0.camel@champagne.cantina> <20090208224249.GA11931@infradead.org> <1234133120.12370.7.camel@champagne.cantina> <20090209075308.GA7360@infradead.org> <20090210104304.GP8830@disturbed> <1234432077.9204.15.camel@champagne.cantina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234432077.9204.15.camel@champagne.cantina>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-02-10 at 21:43 +1100, Dave Chinner wrote:
> > On Mon, Feb 09, 2009 at 02:53:08AM -0500, Christoph Hellwig wrote:
> > > On Sun, Feb 08, 2009 at 11:45:20PM +0100, Alessandro Bono wrote:
> > > > sure, attached
> > > 
> > > That would be a missing PagePrivate bit in page_buffers() called from
> > > end_buffer_async_write.  PG_private can only be cleared via drop_buffers
> > > which requires the page not having PG_writeback set which must be
> > > set until end_buffer_async_write is done.  Very strange, and all this
> > > is generic code without xfs involvement.  Did this happen once
> > > or can you reproduce it?
> > 
> > Hmmmm - i wonder if this has anything to do with the writeback fixes
> > that went into 2.6.28.2? Alessandro, can you revert to 2.6.28.1 (not
> > plain 2.6.28) and see if you can reproduce the problem?
> 
> another test another bug
> kernel 2.6.29-rc4-git4 with DEBUG_PAGEALLOC and CONFIG_DEBUG_LIST
> enabled (idea taken from a totally unrelated mail from Ingo Molnar to
> catch a memory corruption), usual bug attached
> 2.6.27 from ubuntu not survived to rsync
> 
> btw my first report of a similar problem was with a kernel 2.6.26.6 but
> at time I was using binary driver for my radeon card and Christoph
> suggest me that I have to recreate problem without any binary driver
> maybe it's not a recent regression, it's simply easier to hit with a
> newer kernel
> 
> I don't have abandoned idea of a hardware problem but I don't know how
> to be sure
> 
> any suggestion?
  Hmm, are you still able to reproduce the problem? As I'm looking into
registers in your dump, no register really seems to contain sensible page
flags so it could be some corruption of page pointer. If you are still
able to reproduce, could you please do so with the attached patch
applied? It will dump us much more information... Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
