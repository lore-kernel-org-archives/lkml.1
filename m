Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbYCLXRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbYCLXRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYCLXQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:16:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52020 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYCLXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:16:57 -0400
Date: Wed, 12 Mar 2008 16:16:01 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
	Reported regressions from 2.6.24)
Message-ID: <20080312231601.GB24820@kroah.com>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com> <alpine.LFD.1.00.0803121502450.3557@woody.linux-foundation.org> <20080312223431.GA24150@kroah.com> <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803121553070.3557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 04:02:57PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 12 Mar 2008, Greg KH wrote:
> > 
> > What happend in .25-rc was that we now catch these kinds of problems
> > (watching for duplicate kobjects to be registered and such.)  So this
> > might have always been happening, but no warning was ever produced.
> 
> It's not the warning that worries me. It's the apparent oops (keyboard 
> leds blinking?) at shutdown/poweroff!

It oopses at shutdown?  I thought this was originally reported as a
"will not power off" which for a while was attributed to the cpufreq fix
that went into -rc2 or -rc3.

I didn't realize there was an oops, sorry.

> > The reason we aren't shutting down is also due to the way kobjects now
> > work.  If you don't clean up properly, they linger around and something
> > on the shutdown path (I haven't figured that out yet) doesn't want to
> > stop the machine.
> 
> .. and that's my issue! We're too late in the game to try to figure things 
> out and leave things hanging. The patch broke something, it needs to be 
> fixed or reverted. It's been going on too long.
> 
> I think it should have been reverted probably two weeks ago already. We 
> can re-apply it early in the 2.6.26 series, and then try to fix it right. 
> 
> Since there is at least a patch worth trying now, I'll hold off reverting 
> it and wait for Guennardi to test the patch, but the fact is, we shouldn't 
> have a known-broken kernel for several weeks, when there is a known fix 
> for it in reverting a single commit!
> 
> We have _way_ too many regressions as it is. Regressions are bad. Ones 
> that have known causes and haven't been fixed in three weeks are 
> unacceptable.

Sorry, I thought this was just a warning at boot time.

It would be interesting to see if reverting the pci_bus patch did
anything about the fact that we register the root PCI bus through two
different methods.

thanks,

greg k-h
