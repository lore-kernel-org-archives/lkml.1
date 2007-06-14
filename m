Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbXFNKjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbXFNKjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXFNKjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:39:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:56079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbXFNKjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:39:11 -0400
Date: Thu, 14 Jun 2007 12:39:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Badari Pulavarty <pbadari@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       mark.fasheh@oracle.com, ext4 <linux-ext4@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, cmm@us.ibm.com
Subject: Re: + fs-introduce-write_begin-write_end-and-perform_write-aops.patch added to -mm tree
Message-ID: <20070614103903.GA6703@wotan.suse.de>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613114356.GD17547@wotan.suse.de> <1181776021.21924.87.camel@dyn9047017100.beaverton.ibm.com> <20070614095249.GG17819@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614095249.GG17819@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 11:52:49AM +0200, Jan Kara wrote:
> > On Wed, 2007-06-13 at 13:43 +0200, Nick Piggin wrote:
> > ..
> > >  
> > > > 5) ext3_write_end:
> > > > 	Before  write_begin/write_end patch set we have folowing locking
> > > > 	order:
> > > > 		stop_journal(handle);
> > > > 		unlock_page(page);
> > > > 	But now order is oposite:
> > > > 		unlock_page(page);
> > > > 		stop_journal(handle);
> > > > 	Can we got any race condition now? I'm not sure is it actual problem,
> > > > 	may be somebody cant describe this.
> > > 
> > > Can we just change it to the original order? That would seem to be
> > > safest unless one of the ext3 devs explicitly acks it.
>   Sorry, I've missed beginning of this thread. But what problems can
> exactly cause this ordering change? ext3_journal_stop has no need to be
> protected by the page lock - it can be even better that it's not
> protected as it can trigger commit and all that would happen
> unnecessarily under page lock...

Sure, if you think it is safe. I would rather it be done in a
different patch though.

