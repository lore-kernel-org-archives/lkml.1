Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbXKHTv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbXKHTv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbXKHTvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:51:19 -0500
Received: from mtl.rackplans.net ([69.90.0.18]:33018 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761114AbXKHTvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:51:18 -0500
Date: Thu, 8 Nov 2007 14:51:15 -0500 (EST)
From: Gerhard Mack <gmack@innerfire.net>
X-X-Sender: gmack@mtl.rackplans.net
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc2 breaks nVidia MCP51 High Definition Audio
In-Reply-To: <s5h640cycah.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.0.999.0711081450480.23267@mtl.rackplans.net>
References: <alpine.DEB.0.999.0711071737030.552@mtl.rackplans.net>
 <20071107152127.6d012c6c.akpm@linux-foundation.org>
 <alpine.DEB.0.999.0711071900390.31982@mtl.rackplans.net> <s5hsl3h9zf7.wl%tiwai@suse.de>
 <alpine.DEB.0.999.0711080825480.24103@mtl.rackplans.net>
 <s5h640cycah.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Takashi Iwai wrote:

> At Thu, 8 Nov 2007 08:38:18 -0500 (EST),
> Gerhard Mack wrote:
> > 
> > On Thu, 8 Nov 2007, Takashi Iwai wrote:
> > 
> > > At Wed, 7 Nov 2007 19:07:07 -0500 (EST),
> > > Gerhard Mack wrote:
> > > > 
> > > > On Wed, 7 Nov 2007, Andrew Morton wrote:
> > > > 
> > > > > Date: Wed, 7 Nov 2007 15:21:27 -0800
> > > > > From: Andrew Morton <akpm@linux-foundation.org>
> > > > > To: Gerhard Mack <gmack@innerfire.net>
> > > > > Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
> > > > >     Takashi Iwai <tiwai@suse.de>, Rafael J. Wysocki <rjw@sisk.pl>
> > > > > Subject: Re: 2.6.24-rc2 breaks nVidia MCP51 High Definition Audio
> > > > > 
> > > > > > On Wed, 7 Nov 2007 17:39:41 -0500 (EST) Gerhard Mack <gmack@innerfire.net> wrote:
> > > > > > hello,
> > > > > > 
> > > > > > This worked fine in 2.6.23 but now the kernel no longer sees my audio 
> > > > > > controller.
> > > > > > 
> > > > > > 00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev 
> > > > > > a2)
> > > > > > 00:10.1 0403: 10de:026c (rev a2)
> > > > > > 
> > > > > > Let me know if I can provide more info or test patches.
> > > > > > 
> > > > > 
> > > > > Please provide the output of `dmesg -s 1000000' for both 2.6.23
> > > > > and 2.6.24-rc3, thanks.
> > > > > 
> > > > > Are you sure that the driver is suitably configured?  Sometimes
> > > > > we like to fiddle config options so that a `make oldconfig' will go and
> > > > > unconfigure drivers which you need.
> > > > 
> > > > Found an option for generic HD audio and enabled that with only marginally 
> > > > better results.  Now instead of not detecting my card it's showing a 
> > > > single volume control in the mixer and not providing any sound at all.
> > > > 
> > > > 2.6.23:
> > > > Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 
> > > > 09:12:58 2007 UTC).
> > > > ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> > > > ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level, low) 
> > > > -> IRQ 22
> > > > PCI: Setting latency timer of device 0000:00:10.1 to 64
> > > > ALSA device list:
> > > >   #0: HDA NVidia at 0xfe024000 irq 22
> > > > GACT probability on
> > > > 
> > > > 2.6.24-rc2:
> > > > Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Oct 23 
> > > > 06:09:18 2007 UTC).
> > > > ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> > > > ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [AAZA] -> GSI 22 (level, low) 
> > > > -> IRQ 22
> > > > PCI: Setting latency timer of device 0000:00:10.1 to 64
> > > > ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d8000101f761]
> > > > ALSA device list:
> > > >   #0: HDA NVidia at 0xfe024000 irq 22
> > > > GACT probability on
> > > 
> > > Both look OK.
> > > 
> > > Please show your kernel config and /proc/asound/card0/codec#*
> > > contents.  Did you choose CONFIG_SND_HDA_CODEC_* properly?
> > > 
> > > Also, please be more specific about your hardware.  The implementation
> > > of HD-audio stuff is deifferent greatly among products.  It's very
> > > important to know what kind of machine (h/w vendor, product name,
> > > model, etc) to identify whether the configuration is known or not
> > > (i.e. it was really supported or it worked just casually).
> > 
> > The machine is an Asus M2NPV-VM motherboard with an Nforce MCP51 chpset. 
> > and there is not an CONFIG_SND_HDA_CODEC_ option for NVIDIA so I selected 
> > generic instead.
> 
> That's the problem.   MCP51 is the controller chip, not a codec chip.
> It's always supported by snd-hda-intel driver.  CONFIG_SND_HDA_CODEC_*
> are configs to choose codec chips.
> 
> Simply select all CONFIG_SND_HDA_CODEC_*=y if you are not sure (as
> they are default=y).  I guess CONFIG_SND_HDA_CODEC_ANALOG=y should
> suffice but selecting others won't hurt except for a small memory
> footprint.
> 
Codec: Analog Devices AD1986A
Address: 0
Vendor Id: 0x11d41986
Subsystem Id: 0x104381b3
Revision Id: 0x100500

Works like a charm now,

 thanks.

	Gerhard

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.
