Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYDMVf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYDMVf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYDMVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:35:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:32992 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYDMVfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:35:50 -0400
Subject: Re: pci: add to global list before sysfs?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <gregkh@suse.de>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080404210132.GA14418@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
	 <20080404210132.GA14418@suse.de>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 07:35:38 +1000
Message-Id: <1208122538.6958.57.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 14:01 -0700, Greg KH wrote:
> As I mention above, the "global list" is now gone, so it's going to be
> a
> bit harder to do this.  We now only keep one list of all PCI devices,
> and that is with the driver core mechanisms as the duplicate list was
> just sitting there doing nothing for the past 4 years.
> 
> So is the problem that your driver need to bind to multiple pci
> devices
> at the same time in order to work properly?
> 
> Or is this just really broken hardware?

Haven't had a chance to look at your changes yet, but I have memories of
being pretty happy with having that 2 step mechanism in PCI where the
driver core would only see the devices after fixup.

The reason for that is powerpc, like many other archs, need to do all
sorts of fixups before devices get used by drivers. Resources need to be
fixed up, interrupts, etc...

A lot of that happens in pcibios_fixup_bus() and we did rely on having
no driver bound before that happens. The binding can only happen after
the arch calls pci_bus_add_devices().

Is that still the case ? If not, then there is some big potential
breakage here and we need to look closely at re-organizing the way we do
our fixups.

Cheers,
Ben.


