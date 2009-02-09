Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZBIQ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZBIQ0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZBIQ0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:26:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:52051 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbZBIQ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:26:06 -0500
Date: Mon, 9 Feb 2009 08:24:02 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, len.brown@intel.com, stable@kernel.org
Subject: Re: patch acpi-remove-locking-from-pm1x_sts-register-reads.patch
	added to 2.6.28-stable tree
Message-ID: <20090209162402.GA13931@suse.de>
References: <20090208211932.4CAB349019@coco.kroah.org> <200902090124.44228.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902090124.44228.s.L-H@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 01:24:43AM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Sonntag, 8. Februar 2009, gregkh@suse.de wrote:
> > 
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: ACPI: remove locking from PM1x_STS register reads
> > 
> > to the 2.6.28-stable tree.  Its filename is
> > 
> >     acpi-remove-locking-from-pm1x_sts-register-reads.patch
> [...]
> > From a2b7b01c072435b7832ab392167545a1b38cabc3 Mon Sep 17 00:00:00 2001
> > From: Len Brown <len.brown@intel.com>
> > Date: Wed, 28 Jan 2009 12:47:15 -0500
> > Subject: ACPI: remove locking from PM1x_STS register reads
> > 
> > From: Len Brown <len.brown@intel.com>
> > 
> > commit a2b7b01c072435b7832ab392167545a1b38cabc3 upstream.
> > 
> > PM1a_STS and PM1b_STS are twins that get OR'd together
> > on reads, and all writes are repeated to both.
> > 
> > The fields in PM1x_STS are single bits only,
> > there are no multi-bit fields.
> > 
> > So it is not necessary to lock PM1x_STS reads against
> > writes because it is impossible to read an intermediate
> > value of a single bit.  It will either be 0 or 1,
> > even if a write is in progress during the read.
> > Reads are asynchronous to writes no matter if a lock
> > is used or not.
> > 
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> This patch fails to compile on 2.6.28.4 + queue-2.6.28 (and 2.6.27 as 
> well):
> 
> 
>   BUILD   arch/x86/boot/bzImage
> Root device is (254, 1)
> Setup is 11676 bytes (padded to 11776 bytes).
> System is 2175 kB
> CRC d4d9303a
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> ERROR: "acpi_get_register_unlocked" [drivers/acpi/processor.ko] undefined!
> make[4]: *** [__modpost] Error 1
> make[3]: *** [modules] Error 2
> 
> 
> because it seems to depend on the larger changes started in, but not 
> limited to:

Odd, it builds for me.  I see acpi_get_register_unlocked being defined
in include/acpi/acpixf.h and then implemented in
drivers/acpi/hardware/hwregs.c in the 2.6.28.4 + queue tree.

Do you not have it somehow?

Do you think this patch shouldn't be added to the tree?  If so, I have
no objection to removing it, it just looked like a bugfix that would be
good to backport.

thanks,

greg k-h
