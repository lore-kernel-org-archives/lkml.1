Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbXFMX2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbXFMX2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbXFMX2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:28:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:56255 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321AbXFMX2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:28:44 -0400
Date: Thu, 14 Jun 2007 01:28:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, mark.fasheh@oracle.com,
       ext4 <linux-ext4@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com
Subject: Re: + fs-introduce-write_begin-write_end-and-perform_write-aops.patch added to -mm tree
Message-ID: <20070613232838.GB4015@wotan.suse.de>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613114356.GD17547@wotan.suse.de> <1181776021.21924.87.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181776021.21924.87.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 04:07:01PM -0700, Badari Pulavarty wrote:
> On Wed, 2007-06-13 at 13:43 +0200, Nick Piggin wrote:
> ..
> >  
> > > 5) ext3_write_end:
> > > 	Before  write_begin/write_end patch set we have folowing locking
> > > 	order:
> > > 		stop_journal(handle);
> > > 		unlock_page(page);
> > > 	But now order is oposite:
> > > 		unlock_page(page);
> > > 		stop_journal(handle);
> > > 	Can we got any race condition now? I'm not sure is it actual problem,
> > > 	may be somebody cant describe this.
> > 
> > Can we just change it to the original order? That would seem to be
> > safest unless one of the ext3 devs explicitly acks it.
> 
> It would be nice to go back to original order, but its not that
> simple with current structure of the code. With Nick's patches
> unlock_page() happens in generic_write_end(). journal_stop() 
> needs to happen after generic_write_end(). :(

Well we could use block_write_end?

 
> Mingming, can you take a look at the current & proposed order ?
> I ran into bunch of races when I tried to change the order for
> ->writepages() support earlier :(

OK, it sounds like we probably want to revert to the original
order at least for this patchset. If the new order is proven
safe then that could be introduced later to simplify things...

Thanks,
Nick

