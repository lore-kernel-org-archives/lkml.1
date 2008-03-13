Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbYCMPcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbYCMPcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYCMPcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:32:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38259 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYCMPcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:32:46 -0400
Date: Thu, 13 Mar 2008 08:32:13 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
	Reported regressions from 2.6.24)
Message-ID: <20080313153213.GB27723@kroah.com>
References: <200803112341.42517.rjw@sisk.pl> <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org> <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com> <20080312213826.GA17101@kroah.com> <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org> <20080312225421.GA24449@kroah.com> <alpine.LFD.1.00.0803121604580.3557@woody.linux-foundation.org> <20080313054400.GA17102@kroah.com> <Pine.LNX.4.64.0803131057550.4625@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803131057550.4625@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 11:06:10AM +0100, Guennadi Liakhovetski wrote:
> On Wed, 12 Mar 2008, Greg KH wrote:
> 
> > On Wed, Mar 12, 2008 at 04:09:17PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Wed, 12 Mar 2008, Greg KH wrote:
> > > > 
> > > > I can't get a box here to produce both of those PCI: messages myself,
> > > > and neither can Len, so something is really odd here.
> > 
> > Ok, stupid me, this was my fault.  I was assuming that pci busses would
> > never be registered multiple times with the pci core.  Obviously this
> > isn't true.  The previous patch I proposed was only paying attention to
> > the PCI devices, and that logic is just fine (it's already protected
> > when it is attempted to be registered multiple times.)
> > 
> > So, the patch below fixes the issue for me, and reboot seems to work as
> > well.
> > 
> > Guennadi, can you test this out on your machine?
> 
> Yes, it fixes all _3_ startup warnings and lets the machine reboot and 
> power off again. 3 warnings are the 2 reported as a regression from 
> 2.6.24, and one present also under 2.6.24:
> 
> PCI: Probing PCI hardware
> sysfs: duplicate filename 'bridge' can not be created

Yes, I noticed that if you were having this problem, .24 would also be
complaining to you about creating sysfs links.  I'll make up a .24 patch
for -stable after this.

Kay just pointed out that I can use a struct device field instead of
creating my own in the bus device, so I'll simplify the patch and then
send it to Linus in a bit.

Thanks so much for testing quickly and letting me know.

greg k-h
