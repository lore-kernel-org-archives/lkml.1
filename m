Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbYAKFTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYAKFTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 00:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbYAKFTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 00:19:37 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46450 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYAKFTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 00:19:37 -0500
Date: Thu, 10 Jan 2008 23:18:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Is it possible to change IRQ for certain device?
In-reply-to: <fa.LwvfKOhzep/AjTQmtXaIiXMm6zI@ifi.uio.no>
To: Jan Marek <linux@hazard.jcu.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
Message-id: <4786FC30.9000706@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.LwvfKOhzep/AjTQmtXaIiXMm6zI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Marek wrote:
> Hello lkml,
> 
> I have problem with my computer: I have motherboard with AMD690G chipset
> and nVidia VGA card. But I cannot set BIOS, to assign for VGA unique
> IRQ. VGA card is sharing IRQ with two ohci_hcd (USB 1.1 controllers).
> But when I want use for X proprietary nvidia driver, X didn't work with
> this errors:
> 
> In dmesg:
> 
> NVRM: RmInitAdapter failed! (0x23:0xffffffff:678)
> NVRM: rm_init_adapter(0) failed
> 
> and in /var/log/Xorg.0.log:
> 
> (II) Setting vga for screen 0.
> (**) NVIDIA(0): Depth 24, (--) framebuffer bpp 32
> (==) NVIDIA(0): RGB weight 888
> (==) NVIDIA(0): Default visual is TrueColor
> (==) NVIDIA(0): Using gamma correction (1.0, 1.0, 1.0)
> (**) NVIDIA(0): Enabling RENDER acceleration
> (II) NVIDIA(0): Support for GLX with the Damage and Composite X
> extensions is
> (II) NVIDIA(0):     enabled.
> (EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device
> PCI:1:0:0.
> (EE) NVIDIA(0):     Please see the COMMON PROBLEMS section in the
> README for
> (EE) NVIDIA(0):     additional information.
> (EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device!
> (EE) NVIDIA(0):  *** Aborting ***
> (II) UnloadModule: "nvidia"
> (II) UnloadModule: "fb"
> (EE) Screen(s) found, but none have a usable configuration.
> 
> Fatal server error:
> no screens found
> 
> I've found in README for NVIDIA, that VGA has to have unique IRQ. I've
> tried to set INTERRUPT_LINE and INTERRUPT_PIN with setpci tool, set
> pci=routeirq, pci=noacpi as the kernel boot parameters, but IRQ
> is still the same.
> 
> Is there a way to change IRQ for VGA (or for ohci_hcd instead of VGA)
> directly in Linux?

The kernel has no control over IRQ assignments. Often they are hardwired 
in the motherboard and can't be changed at all. You could check for any 
relevant BIOS settings (Assign IRQ to VGA, also see if it has an APIC 
mode setting that needs to be enabled).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

