Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbYAJLOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbYAJLOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYAJLN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:13:58 -0500
Received: from hazard.jcu.cz ([160.217.1.6]:42856 "EHLO hazard.jcu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbYAJLN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:13:57 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 06:13:57 EST
Date: Thu, 10 Jan 2008 12:05:35 +0100
From: Jan Marek <linux@hazard.jcu.cz>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Is it possible to change IRQ for certain device?
Message-ID: <20080110110535.GA25706@hazard.jcu.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml,

I have problem with my computer: I have motherboard with AMD690G chipset
and nVidia VGA card. But I cannot set BIOS, to assign for VGA unique
IRQ. VGA card is sharing IRQ with two ohci_hcd (USB 1.1 controllers).
But when I want use for X proprietary nvidia driver, X didn't work with
this errors:

In dmesg:

NVRM: RmInitAdapter failed! (0x23:0xffffffff:678)
NVRM: rm_init_adapter(0) failed

and in /var/log/Xorg.0.log:

(II) Setting vga for screen 0.
(**) NVIDIA(0): Depth 24, (--) framebuffer bpp 32
(==) NVIDIA(0): RGB weight 888
(==) NVIDIA(0): Default visual is TrueColor
(==) NVIDIA(0): Using gamma correction (1.0, 1.0, 1.0)
(**) NVIDIA(0): Enabling RENDER acceleration
(II) NVIDIA(0): Support for GLX with the Damage and Composite X
extensions is
(II) NVIDIA(0):     enabled.
(EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device
PCI:1:0:0.
(EE) NVIDIA(0):     Please see the COMMON PROBLEMS section in the
README for
(EE) NVIDIA(0):     additional information.
(EE) NVIDIA(0): Failed to initialize the NVIDIA graphics device!
(EE) NVIDIA(0):  *** Aborting ***
(II) UnloadModule: "nvidia"
(II) UnloadModule: "fb"
(EE) Screen(s) found, but none have a usable configuration.

Fatal server error:
no screens found

I've found in README for NVIDIA, that VGA has to have unique IRQ. I've
tried to set INTERRUPT_LINE and INTERRUPT_PIN with setpci tool, set
pci=routeirq, pci=noacpi as the kernel boot parameters, but IRQ
is still the same.

Is there a way to change IRQ for VGA (or for ohci_hcd instead of VGA)
directly in Linux?

Thanks a lot.

Sincerely
Jan Marek
