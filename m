Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXIXNjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXIXNjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbXIXNjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:39:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057AbXIXNi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:38:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents
Date: Mon, 24 Sep 2007 15:52:32 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200709231257.12213.rjw@sisk.pl> <200709241457.40669.rjw@sisk.pl> <1190639101.4035.185.camel@chaos>
In-Reply-To: <1190639101.4035.185.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709241552.32567.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 September 2007 15:05, Thomas Gleixner wrote:
> On Mon, 2007-09-24 at 14:57 +0200, Rafael J. Wysocki wrote:
> > > > http://tglx.de/projects/hrtimers/2.6.23-rc4/patch-2.6.23-rc4-hrt1.patches.tar.bz2
> > > > 
> > > > applied.  I also have the 2.6.23-rc6-mm1 dmesg output ready, but there's some
> > > > -mm-specific noise in it.  Please let me know if you want it, though.
> > > 
> > > Hmm:
> > > 
> > > > Command line: root=/dev/sda3 vga=792 resume=/dev/sda1 noacpitimer apic=verbose 2
> > > --------------------------------------------------------^^^^^^^^^^^
> > > 
> > > noacpitimer is not a valid commandline option.
> > > 
> > > I asked for: 
> > > >> > > noapictimer
> > 
> > I'm blind, sorry.
> > 
> > > So I really wonder, why noacpitimer on the kernel command line makes any
> > > difference. I'm confused.
> > 
> > \metoo
> > 
> > Well, it was probably read as "noacpi". :-)
> 
> Hmm, ACPI is in the log all over the place.

Well, "noacpi" seems to be a synonym for "pci=noacpi".

Anyway, it causes acpi_disable_pci() to be executed, which according to
Documentation/kernel-parameters.txt means "Do not use ACPI for IRQ routing or
for PCI scanning" (it works like this on x86_64 too, although the doc says it's
x86_32-specific).

And yes, it matches "noacpiwhatever" in the command line with "noacpi".  Sigh.

> > Fortunately, noapictimer helps as well, dmesg attached (I have the one
> > from 2.6.23-rc6-mm1 ready, too).
> 
> Ok, at which point is the box stopping, when you omit noa* ? Is
> earlyprintk giving you any useful info ?

earlyprintk=vga doesn't display anything (ie. black screen) and there are no
serial ports in the box.

Greetings,
Rafael
