Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYLCPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYLCPT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYLCPTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:19:45 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:44944 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbYLCPTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:19:44 -0500
To: linux-kernel@vger.kernel.org
Subject: .28-rc7-91 Starting X.Org fails and display hangs
From: Frans Pop <elendil@planet.nl>
Date: Wed, 3 Dec 2008 16:19:41 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031619.41679.elendil@planet.nl>
X-OriginalArrivalTime: 03 Dec 2008 15:19:41.0954 (UTC) FILETIME=[90AE7620:01C9555A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just booted my HP 2510p with v2.6.28-rc7-91-gf6f7b52 and got a rather 
nasty failure:
- last message on console is Starting kdm
- screen blanks (as normal before switch to kdm on VT7)
- system is alive: can ssh to it
- rebooting the system fails; hard poweroff needed

.28-rc6-209 boots without problems.

Diff of X.Org logs (see below) shows it just stops at some point. There
are no changes in the log before the failure point.

Diff of dmesg only shows the following missing for the failed boot:
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0

But that is probably just because X.Org does not get that far. The diff
between the X.Org logs shows that drm only gets enabled after the point
of failure.

I did try reverting:
commit 9c84ba4e502184d95ab75128d3166f595ea2dea0
    drivers/gpu/drm/i915/i915_irq.c: fix warning
commit 151903d5466fbcfb56ce792c3d5ea0ecbae15d07
    drm/i915: Fix copy'n'pasteo that broke VT switch if flushing was
              non-empty.
commit bca404afdc5206c3bb30168315ee8a98a579ec65
    fbdev: fix FB console blanking

But none of those made any difference. It's only a fairly small set of
changes and I've been staring at the commit log for other potential
culprits, but nothing else jumps out at me.

Any suggestions?

Cheers,
FJP

Extract from good X.Org.log to show failure point:
[...]
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Reloading /usr/lib/xorg/modules//libint10.so
(II) intel(0): initializing int10
(WW) intel(0): Bad V_BIOS checksum
(II) intel(0): Primary V_BIOS segment is: 0xc000
(II) intel(0): VESA BIOS detected
(II) intel(0): VESA VBE Version 3.0
(II) intel(0): VESA VBE Total Mem: 7616 kB
(II) intel(0): VESA VBE OEM: Intel(r)GM965/PM965/GL960 Graphics Chip Accelerated VGA BIOS
(II) intel(0): VESA VBE OEM Software Rev: 1.0
(II) intel(0): VESA VBE OEM Vendor: Intel Corporation
(II) intel(0): VESA VBE OEM Product: Intel(r)GM965/PM965/GL960 Graphics Controller
(II) intel(0): VESA VBE OEM Product Rev: Hardware Version 0.0
(II) intel(0): found backlight control method /sys/class/backlight/acpi_video0
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOB" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOB:SDVO Controller B" registered at address 0x70.
(II) intel(0): No SDVO device found on SDVOB
(II) intel(0): I2C device "SDVOCTRL_E for SDVOB:SDVO Controller B" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOB" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C" registered at address 0x72.
(II) intel(0): No SDVO device found on SDVOC
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" removed.
(II) intel(0): Output TV has no monitor section
(II) intel(0): EDID vendor "LCD", prod id 22767

[X.Org log stops here for bad boot]

(II) intel(0): Output VGA disconnected
(II) intel(0): Output LVDS connected
(II) intel(0): Output TV disconnected
(II) intel(0): Output LVDS using initial mode 1280x800
(II) intel(0): Monitoring connected displays enabled
(II) intel(0): detected 512 kB GTT.
(II) intel(0): detected 7676 kB stolen memory.
(==) intel(0): video overlay key set to 0x101fe
(==) intel(0): Will not try to enable page flipping
(==) intel(0): Triple buffering disabled
(==) intel(0): Intel XvMC decoder disabled
(==) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(++) intel(0): DPI set to (96, 96)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
