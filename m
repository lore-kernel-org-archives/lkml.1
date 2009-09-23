Return-Path: <linux-kernel-owner+w=401wt.eu-S1751277AbZIWNfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbZIWNfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZIWNfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:35:32 -0400
Received: from poutre.nerim.net ([62.4.16.124]:58319 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbZIWNfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:35:31 -0400
Date: Wed, 23 Sep 2009 15:35:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>, jbarnes@virtousgeek.org,
       linux-pci@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Crash on reading the whole PCI config of PIIX4 SMBus
Message-ID: <20090923153531.1642b77d@hyperion.delvare>
In-Reply-To: <4ABA1B9C.9070302@nachtwindheim.de>
References: <4AB8F142.9090609@nachtwindheim.de>
	<20090922231839.GA20656@pengutronix.de>
	<4ABA1B9C.9070302@nachtwindheim.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 14:59:08 +0200, Henrik Kretzschmar wrote:
> Wolfram Sang schrieb:
> > On Tue, Sep 22, 2009 at 05:46:10PM +0200, Henrik Kretzschmar wrote:
> >
> >   
> >> at boot time my system (Wincor/Nixdorf Beetle D1) sometimes crashs while loading the i2c-piix4 driver.
> >>     
> >
> > Have you checked if you have the latest BIOS for this machine? Sometimes
> > PCI-problems got fixed there...
> >
> >   
> Thanks for you fast replies,
> 
> the latest BIOS (05/08) is already installed, so no fixing can be expected that way
> 
> 
> I tested my killer-commands at the other box @home with no crashes.
> 
> The commands _work_ with a coldstarted Linux and i2c-piix not loaded,
> so the only thing I can do is blacklisting it and renounce sensors support,
> having a good a argument for a new hardware aquisition. :)

That's really odd, considering that the i2c-piix4 driver doesn't change
the PCI device configuration, it only reads from it.

If you trigger some transactions (for example by running "sensors -s"
at boot time?) then you also write to the I/O ports. But this hardly
explains how subsequently reading the PCI config space would crash.

You might still want to check if maybe ACPI is interfering with the
i2c-piix4 driver. This isn't the kind of result I'd expect, but who
knows.

> 
> For completness the message with the SMBus revision, which is not the pci-revision, is:
> 
> SMBus Host Controller at 0x1040, revision 0

Revision 0 here as well, I suspect there never was any other revision
of this chip.

> 
> 
> The "?" at the interrupt line of lspci is a little strange:
> 
> >> Interrupt: pin ? routed to IRQ 9
> 
> looking at lspci -x -s 7.3 I can see that PCI_INTERRUPT_PIN == 0 
> 
> I cant see that i2p-piix does any interrupts, refering /proc/irq/9/spurious
> 
> The driver says:
>  
> Using Interrupt SMI# for SMBus

This is only a debug message, saying how the interrupt line is
configured, but you are right that the driver doesn't use interrupts
(much to our shame.)

> 
> I'm not sure, but my box @home has the same lspci output with the "?".
> 
> So long, thanks for help.

-- 
Jean Delvare
http://khali.linux-fr.org/wishlist.html
