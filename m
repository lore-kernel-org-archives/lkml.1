Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbXJYUFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbXJYUFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757783AbXJYUFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:05:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760162AbXJYUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:05:18 -0400
Date: Thu, 25 Oct 2007 13:02:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: buytenh@wantstofly.org, svs1957@gmail.com, bgat@billgatliff.com,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to
 kernel
Message-Id: <20071025130250.cd759e90.akpm@linux-foundation.org>
In-Reply-To: <1193319816.6167.45.camel@localhost.localdomain>
References: <bug-9217-10286@http.bugzilla.kernel.org/>
	<20071024195717.0de6a248.akpm@linux-foundation.org>
	<47200F05.2050305@billgatliff.com>
	<20071025122303.GB7543@xi.wantstofly.org>
	<1193319816.6167.45.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 14:43:36 +0100
Richard Purdie <rpurdie@rpsys.net> wrote:

> On Thu, 2007-10-25 at 14:23 +0200, Lennert Buytenhek wrote:
> > On Wed, Oct 24, 2007 at 10:35:33PM -0500, Bill Gatliff wrote:
> > 
> > > >Something broke CONFIG_CMDLINE of ARM (at least) between 2.6.22 and 2.6.23.
> > > >
> > > >I don't know whether it was an ARM patch one of those kernel-wide changes. 
> > > >We have futzed with the command-line parsing a bit recently, but the 2.6.23
> > > >changelog doesn't suggest anything obvious.
> > > 
> > > What does the affected system's bootloader pass in r2?  If it's nonzero, 
> > > ARM's 2.6.23 may interpret it as being an ATAGS pointer.  And when that 
> > > happens, the system prefers the ATAGS over CONFIG_CMDLINE.
> > > 
> > > There's sanity checking in __vet_atags, but maybe it isn't enough.  
> > > Other than that, I can't see anything yet.
> > 
> > If this is the SHARP Shepherd (which seems to be the Zaurus SL-C750,
> > which looks like it's the one the submitter is using), it's not setting
> > boot_params at all:
> > 
> > 	MACHINE_START(SHEPHERD, "SHARP Shepherd")
> > 		.phys_io        = 0x40000000,
> > 		.io_pg_offst    = (io_p2v(0x40000000) >> 18) & 0xfffc,
> > 		.fixup          = fixup_corgi,
> > 		.map_io         = pxa_map_io,
> > 		.init_irq       = pxa25x_init_irq,
> > 		.init_machine   = corgi_init,
> > 		.timer          = &pxa_timer,
> > 	MACHINE_END
> 
> The Zaurus has an insane bootloader which doesn't pass any sane values,
> it doesn't support the right (well, any) machine number and the
> commandline it passes is unchangeable and bogus too. The approach has
> always therefore been to pretend it doesn't exist and used a commandline
> compiled into the kernel.
> 
> Could the original bug reporter please report what commandline the
> kernel actually uses please? In theory it can only be either:
> 
> * the one being compiled in with CONFIG_CMDLINE
> * the one hardcoded into the bootloader
> 
> but I'd be surprised it boots at all with the latter!
> 

It was in the inital report, at
http://bugzilla.kernel.org/show_bug.cgi?id=9217 :


: I try to upgrade kernel from 2.6.22.9 to 2.6.23.
: 2.6.22.9 works correct. Kernel 2.6.23 doesn't use  CONFIG_CMDLINE and doesn't
: pass bootparams:
: CONFIG_CMDLINE="console=ttyS0,115200n8 console=tty1 noinitrd
: root=/dev/mmcblk0p1 rootfstype=ext3 rw rootdelay=5"
: But kernel still try to mount /dev/mtdblock2 using jffs2.
: Steps to reproduce:
: Compile kernel with CONFIG_CMDLINE and try to boot.


