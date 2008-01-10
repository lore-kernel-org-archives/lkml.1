Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYAJXno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYAJXno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYAJXni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:43:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:42347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYAJXnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:43:37 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Is it possible to change IRQ for certain device?
Date: Thu, 10 Jan 2008 18:43:06 -0500
User-Agent: KMail/1.9.5
Cc: "Jan Marek" <linux@hazard.jcu.cz>, "lkml" <linux-kernel@vger.kernel.org>
References: <20080110110535.GA25706@hazard.jcu.cz> <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101843.07067.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 09:01, linux-os (Dick Johnson) wrote:
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


What Dick writes is true.
If you can move devices between slots, you can often get onto a different
physical interrupt wire.

However, if your system has an IOAPIC but you're not using IOAPIC mode,
often that programs the "glue" above so spread interrutps out.
See if your BIOS setup has any IRQ options, and see if your kernel
has the IOAPIC enabled.  dmesg would tell.

cheers,
-Len
