Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbXK0P6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbXK0P6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbXK0P6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:58:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44640 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbXK0P6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:58:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 2/6] Hibernation: Move low level resume to disk.c
Date: Tue, 27 Nov 2007 17:06:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200711270025.08128.rjw@sisk.pl> <200711270029.11185.rjw@sisk.pl> <20071127002929.GF9759@elf.ucw.cz>
In-Reply-To: <20071127002929.GF9759@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271706.05259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of November 2007, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Move the low level restore code to kernel/power/disk.c , since the
> > corresponding low level hibernation code is already there.
> > 
> > Make restore fail if device_power_down(PMSG_PRETHAW) returns an
> > error.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move looks ok to me.
> 
> 
> >  /**
> > + *	resume_target_kernel - prepare devices that need to be suspended with
> > + *	interrupts off, restore the contents of highmem that have not been
> > + *	restored yet from the image and run the low level code that will restore
> > + *	the remaining contents of memory and switch to the just restored target
> > + *	kernel.
> > + */
> > +
> > +static int resume_target_kernel(void)
> > +{
> > +	int error;
> > +
> > +	local_irq_disable();
> > +	error = device_power_down(PMSG_PRETHAW);
> > +	if (error) {
> > +		printk(KERN_ERR "Some devices failed to power down, "
> > +			KERN_ERR "aborting resume\n");
> > +		goto Enable_irqs;
> 
> Too many KERN_ERR's ;-)

Yeah, will fix.

> . Plus... are you sure this does the right 
> thing? ... .. ... yes, it does. If one device fails,
> device_power_down() powers up the rest using dpm_power_up(). Good.
> 
> ACK... modulo double KERN_ERR.

OK, thanks!

Rafael
