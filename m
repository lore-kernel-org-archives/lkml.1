Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYCLWyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYCLWyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYCLWym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:54:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47502 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbYCLWyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:54:41 -0400
Date: Wed, 12 Mar 2008 15:54:21 -0700
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
Message-ID: <20080312225421.GA24449@kroah.com>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com> <20080312213826.GA17101@kroah.com> <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 03:25:41PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 12 Mar 2008, Greg KH wrote:
> > 
> > Actually, here's a simple patch from -next that should test this logic
> > for you.  Can you let me know if this solves the start up WARNING dump
> > for you?
> 
> This patch looks bogus.
> 
> Why do you introduce a "dev->is_added" field that apparently has to match 
> the old "list_empty(&dev->global_list)" 1:1 anyway?
> 
> In other words: when is it *ever* permissible for "is_added" to have a 
> different value from the "list_empty(..)" logic? And if they must always 
> match (and it looks like they have to, since you set and clear the flag 
> exactly when you add/remove it from the list), then what exactly is this 
> supposed to fix?

In the patch series in -next, it is supposed to replace the list_empty()
logic exactly, as that list goes away in the next patch in the series.

So yes, it is not a "fix" per-say, but would be nice to see if it solves
this issue in some way.

All I can think is that somehow this pci device for the root hub isn't
added to that extra list (as that is only done in the pcibios logic) and
so it isn't set.

I can't get a box here to produce both of those PCI: messages myself,
and neither can Len, so something is really odd here.  And that has
nothing to do with the pci_bus rework, that is just showing the problem
more accuratly now.  Even if it were to be reverted, the root problem
would still be present.

thanks,

greg k-h
