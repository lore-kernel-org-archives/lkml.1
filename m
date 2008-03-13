Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYCMKGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYCMKGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYCMKGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:06:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:56578 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752013AbYCMKGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:06:06 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/D9IYtJsrDnI2LUheyKDd5qFKXtiA8uh+Ysv0ce6
	TejEjMHRz7MZ3G
Date: Thu, 13 Mar 2008 11:06:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: pcibios_scanned needs to be set in ACPI?  (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <20080313054400.GA17102@kroah.com>
Message-ID: <Pine.LNX.4.64.0803131057550.4625@axis700.grange>
References: <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
 <47D6D61F.4050805@garzik.org> <200803112341.42517.rjw@sisk.pl>
 <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
 <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com>
 <20080312213826.GA17101@kroah.com> <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org>
 <20080312225421.GA24449@kroah.com> <alpine.LFD.1.00.0803121604580.3557@woody.linux-foundation.org>
 <20080313054400.GA17102@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Greg KH wrote:

> On Wed, Mar 12, 2008 at 04:09:17PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 12 Mar 2008, Greg KH wrote:
> > > 
> > > I can't get a box here to produce both of those PCI: messages myself,
> > > and neither can Len, so something is really odd here.
> 
> Ok, stupid me, this was my fault.  I was assuming that pci busses would
> never be registered multiple times with the pci core.  Obviously this
> isn't true.  The previous patch I proposed was only paying attention to
> the PCI devices, and that logic is just fine (it's already protected
> when it is attempted to be registered multiple times.)
> 
> So, the patch below fixes the issue for me, and reboot seems to work as
> well.
> 
> Guennadi, can you test this out on your machine?

Yes, it fixes all _3_ startup warnings and lets the machine reboot and 
power off again. 3 warnings are the 2 reported as a regression from 
2.6.24, and one present also under 2.6.24:

PCI: Probing PCI hardware
sysfs: duplicate filename 'bridge' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Pid: 1, comm: swapper Not tainted 2.6.24-hires-nohz #2
 [<c010541a>] show_trace_log_lvl+0x1a/0x30
 [<c0105ed2>] show_trace+0x12/0x20
 [<c010675e>] dump_stack+0x6e/0x80
 [<c01b246d>] sysfs_add_one+0x9d/0xe0
 [<c01b328b>] sysfs_create_link+0x8b/0x130
 [<c01f9f14>] pci_bus_add_devices+0x94/0x120
 [<c03f3920>] pci_legacy_init+0x50/0xf0
 [<c03d95f2>] kernel_init+0x142/0x320
 [<c0104fe3>] kernel_thread_helper+0x7/0x14
 =======================
pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...

So, well done! I was going to disturb you with that one after 2.6.25, now 
I don't have to any more, unless we want it fixed in 2.6.24-stable.

> thanks for your patience,

always at your disposal:-)

Thanks
Guennadi
---
Guennadi Liakhovetski
