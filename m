Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbZJLPn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbZJLPn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932583AbZJLPnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:43:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:49737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570AbZJLPnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:43:50 -0400
Subject: Re: Moving drivers into staging (was Re: [GIT PULL] SCSI fixes for
 2.6.32-rc3)
From: James Bottomley <James.Bottomley@suse.de>
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jing Huang <huangj@brocade.com>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20091012150911.GB1656@suse.de>
References: <1255031298.4187.260.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain>
	 <20091008210737.GD29181@mit.edu>
	 <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
	 <20091009091538.GA4154@elte.hu>
	 <1255097287.2934.21.camel@localhost.localdomain>
	 <20091012130652.GB25464@elte.hu>
	 <1255357148.2850.91.camel@localhost.localdomain>
	 <20091012145453.GD4565@elte.hu>  <20091012150911.GB1656@suse.de>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 10:43:06 -0500
Message-Id: <1255362186.2850.348.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 08:09 -0700, Greg KH wrote:
> adding David Miller and the wireless developers who had this idea as
> well...
> 
> On Mon, Oct 12, 2009 at 04:54:53PM +0200, Ingo Molnar wrote:
> > I think your interpretation is arbitrary - where did you get that ABI 
> > rule from? I'm sure it cannot be from any of the drivers/staging/ 
> > discussions on lkml, i've followed them quite closely. If 'has a messy 
> > ABI' was the only requirement for drivers/staging/ then we could move 
> > 90% of drivers/staging/ into drivers/ straight away - and that would be 
> > counter-productive IMHO.
> 
> I agree with this, and the other points you raised that I snipped out.
> 
> > Sidenote, in fact i think we should expand on that: drivers/staging/ 
> > should be used in the _other_ direction as well - to un-upstream stale 
> > drivers that are abandoned and unused, in a gradual fashion. 'git mv' is 
> > cheap.
> 
> Ok, this is about the 3rd or 4th time I've heard this, from totally
> different people lately.  It seems that I'm the only one that has the
> ability to drop drivers out of the kernel tree, which is a funny
> situation :)
> 
> In thinking about this a lot more, I don't really mind it.  If people
> want to push stuff out of "real" places in the kernel, into
> drivers/staging/ and give the original authors and maintainers notice
> about what is going on, _and_ provide a TODO file for what needs to
> happen to get the code back into the main portion of the kernel tree,
> then I'll be happy to help out with this and manage it.
> 
> I think a 6-9 month window (basically 3 kernel releases) should be
> sufficient time to have a driver that has been in drivers/staging/ be
> cleaned up enough to move back into the main kernel tree.  If not, it
> could be easily dropped.
> 
> Any objections to this?

Not as an optional tool to use when necessary.

If you want to make this a mandatory path for old drivers, then, I think
it's far too rigid, yes.   There's a huge amount of danger to changing
working drivers simply on grounds of code cleanup and that danger
increases exponentially as they get older and the hardware gets rarer.
Look at what happened to the initio driver in 2008 for instance.  That
was cleaned up by Alan Cox, no mean expert in the field, with the
assistance of a tester with the actual card, so basically a textbook
operation.  However, a bug crept in during this process that wasn't
spotted by the tester.  When it was spotted (bug report ~6 months later)
the original tester wasn't available and code inspection across the
cleanup was very hard.  Fortunately, the reporter was motivated to track
down and patch the driver, so it worked out all right in the end, but a
lot of bug reporters aren't so capable (or so motivated).  Plus most
clean up patches for old hardware tend only to be compile tested, so the
potential for bugs is far greater.

James

> > Basically, drivers/staging/ gives us an excellent opportunity to 
> > _increase_ the quality of drivers by applying stronger upstream 
> > inclusion filters, without having to hurt users/developers in the 
> > process. We just have to start using it that way as well.
> 
> I totally agree.  And so far, it does seem to be working well for this.
> A number of companies have used it to successfully get their code into
> the main kernel, as well as driving them to clean up their code better
> to keep it from having to go into the staging tree.
> 
> thanks,
> 
> greg k-h

