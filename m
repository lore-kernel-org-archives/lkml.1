Return-Path: <linux-kernel-owner+w=401wt.eu-S1765221AbXEYUf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765221AbXEYUf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 16:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXEYUfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 16:35:17 -0400
Received: from mail.suse.de ([195.135.220.2]:56270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764AbXEYUfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 16:35:16 -0400
Date: Fri, 25 May 2007 13:35:01 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Message-ID: <20070525203501.GD5413@suse.de>
References: <20070514160005.627435e3@osprey.hogchain.net> <m1odkmmft4.fsf@ebiederm.dsl.xmission.com> <20070515212200.517fcba2@osprey.hogchain.net> <m14pmcmz8r.fsf@ebiederm.dsl.xmission.com> <20070516185225.3f3ac082@osprey.hogchain.net> <m1sl9wl28m.fsf@ebiederm.dsl.xmission.com> <20070522204103.134bf5a2@osprey.hogchain.net> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <20070525052032.GB9386@suse.de> <m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1myztaq5s.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 09:17:35AM -0600, Eric W. Biederman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > Originally I would have thought this would be a good idea, but now that
> > Vista is out, which supports MSI, I don't think we are going to need
> > this in the future.  All new chipsets should support MSI fine and this
> > table will only grow in the future, while the blacklist should not need
> > to have many new entries added to it.
> >
> > So I don't think this is a good idea, sorry.
> 
> - The current situation is broken
> - In spec hardware does not require MSI to generate interrupts
>   Which leaves enabling MSI optional.
> 
> Do you have a better idea to solve the current brokenness?
> 
> MSI appears to have enough problems that enabling it in a kernel
> that is supposed to run lots of different hardware (like a distro
> kernel) is a recipe for disaster.

Oh, I agree it's a major pain in the ass at times...

But I'm real hesitant to change things this way.  We'll get reports of
people who used to have MSI working, and now it will not (like all AMD
chipsets).  That's a regression...

Perhaps we can trigger off of the same flag that Vista uses like Andi
suggested?  That's one way to "know" that the hardware works, right?

For non-x86 arches, they all seem to want to always enable MSI as they
don't have to deal with as many broken chipsets, if any at all.  So for
them, we'd have to just whitelist the whole arch.  Does that really make
sense?

And again, over time, like years, this list is going to grow way beyond
a managable thing, especially as any new chipset that comes out in 2009
is going to have working MSI, right?  I think our blacklist is easier to
manage over time, while causing a problem for some users in trying to
determine their broken hardware that they currently have.

It's a trade off, and I'd like to choose the one that over the long
term, causes the least ammount of work and maintaiblity.  I think the
current blacklist meets that goal.

thanks,

greg k-h
