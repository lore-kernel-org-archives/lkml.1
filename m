Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbYE0R7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbYE0R7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYE0R6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:58:53 -0400
Received: from ns2.suse.de ([195.135.220.15]:47859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbYE0R6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:58:53 -0400
Date: Tue, 27 May 2008 10:55:52 -0700
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
	interrupts
Message-ID: <20080527175552.GB11645@suse.de>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local> <20080523105604.GA23800@digi.com> <20080523135557.27fe4855@bluebox.local> <20080524044354.GA8129@suse.de> <alpine.LFD.1.10.0805250013450.3295@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805250013450.3295@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 12:22:20AM +0200, Thomas Gleixner wrote:
> On Fri, 23 May 2008, Greg KH wrote:
> 
> > On Fri, May 23, 2008 at 01:55:57PM +0200, Hans J. Koch wrote:
> > > Sometimes it is necessary to enable/disable the interrupt of a UIO device
> > > from the userspace part of the driver. With this patch, the UIO kernel driver
> > > can implement an "irqcontrol()" function that does this. Userspace can write
> > > an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> > > UIO core will then call the driver's irqcontrol function.
> > 
> > Why not just a new sysfs file for the uio device, irq_enabled, or
> > something like that?  That way our main read/write path is left alone.
> 
> It makes a certain amount of sense to use write. You hold the device
> file descriptor anyway for the read (wait for interrupt) operation,
> so using the same file descriptor is not a too bad idea:
> 
>     while (!stop) {
> 
>         /* wait for interrupt */
> 	read(fd);
> 
> 	do_stuff();
> 
> 	/*reenable interrupt */
> 	write(fd);
>     }
> 
> I thought about using a sysfs entry for a while, but looking at the
> actual use case made the write() solution a more natural choice.

Ok, that makes sense, I can accept this.

Anyone care to respin the patches with the latest updates and send them
to me?

thanks,

greg k-h
