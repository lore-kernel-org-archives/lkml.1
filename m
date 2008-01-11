Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbYAKQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbYAKQ5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757464AbYAKQ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:57:14 -0500
Received: from hazard.jcu.cz ([160.217.1.6]:55014 "EHLO hazard.jcu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759923AbYAKQ5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:57:13 -0500
Date: Fri, 11 Jan 2008 17:57:11 +0100
From: Jan Marek <linux@hazard.jcu.cz>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Is it possible to change IRQ for certain device?
Message-ID: <20080111165711.GA21173@hazard.jcu.cz>
References: <20080110110535.GA25706@hazard.jcu.cz> <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks a lot for replies.

But...
On Thu, Jan 10, 2008 at 09:01:37AM -0500, linux-os (Dick Johnson) wrote:
> 
> On Thu, 10 Jan 2008, Jan Marek wrote:
> 
> > Hello lkml,
> >
> > I have problem with my computer: I have motherboard with AMD690G chipset
> > and nVidia VGA card. But I cannot set BIOS, to assign for VGA unique
> > IRQ. VGA card is sharing IRQ with two ohci_hcd (USB 1.1 controllers).
> > But when I want use for X proprietary nvidia driver, X didn't work with
> > this errors:
> >
> > In dmesg:
> >
> > NVRM: RmInitAdapter failed! (0x23:0xffffffff:678)
> > NVRM: rm_init_adapter(0) failed
> >
> > and in /var/log/Xorg.0.log:
> >
> > (II) Setting vga for screen 0.
> > (**) NVIDIA(0): Depth 24, (--) framebuffer bpp 32
> > (==) NVIDIA(0): RGB weight 888
> > (==) NVIDIA(0): Default visual is TrueColor
> > (==) NVIDIA(0): Using gamma correction (1.0, 1.0, 1.0)
> > (**) NVIDIA(0): Enabling RENDER acceleration
> > (II) NVIDIA(0): Support for GLX with the Damage and Composite X
> > extensions is
> > (II) NVIDIA(0):     enabled.
> > (EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device
> > PCI:1:0:0.
> > (EE) NVIDIA(0):     Please see the COMMON PROBLEMS section in the
> > README for
> > (EE) NVIDIA(0):     additional information.
> > (EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device!
> > (EE) NVIDIA(0):  *** Aborting ***
> > (II) UnloadModule: "nvidia"
> > (II) UnloadModule: "fb"
> > (EE) Screen(s) found, but none have a usable configuration.
> >
> > Fatal server error:
> > no screens found
> >
> > I've found in README for NVIDIA, that VGA has to have unique IRQ. I've
> > tried to set INTERRUPT_LINE and INTERRUPT_PIN with setpci tool, set
> > pci=routeirq, pci=noacpi as the kernel boot parameters, but IRQ
> > is still the same.
> >
> > Is there a way to change IRQ for VGA (or for ohci_hcd instead of VGA)
> > directly in Linux?
> >
> > Thanks a lot.
> >
> > Sincerely
> > Jan Marek
> 
> The interrupt lines are set by the traces on the PC board and
> the contents of various "glue" chips and FPGAs. Many lap-tops,
> for instance, only have one IRQ serving any PCI devices. If
> your screen card can't share the only IRQ you have, it is
> broken. Contact the vendor of both your motherboard (they
> may have a BIOS upgrade) and the screen card (they may
> have a fix).

I know, that interrupt lines are hardwired, but IMHO IOAPIC can assign
for every device on every hardwired line another IRQ. Am I right? I
think, that in this process can do some work BIOS. But I though, that
Linux can do similar work, when initializing hardware and can reassign
IRQ for certain device to another "number".

In BIOS of my motherboard there is no options like "IRQ for VGA" or
similar... :-( It's Gigabyte MA69G-S3H. I have already flashed newest
BIOS, which is on the Gigabyte web pages...

I suppose, that VGA card does not need unique IRQ, but programmers,
which wrote driver, want it. I can imagine, that VGA card have many
interrupts, especially in the OpenGL games, but I cannot assign unique
IRQ for VGA card at all :-(

But thank you for advice: I will try to send e-mail to Gigabyte and ask
they, if it possible to do change in the BIOS.

BTW: it is interesting: I had a Biostar TA690G motherboard and it behave
similar as Gigabyte: I cannnot assign unique IRQ to the external
graphics card... Chipsets of this motherboards are the same...

I've tried to solve this problem by bought of new motherboard: Gigabyte
MA790FX-DS5. I will see, if this board will behave as previous board...

> 
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
> My book : http://www.AbominableFirebug.com/

Sincerely
Jan Marek
