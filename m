Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZCFUdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZCFUdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZCFUdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:33:21 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43130 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751168AbZCFUdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:33:21 -0500
Date: Fri, 6 Mar 2009 15:33:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: David Airlie <airlied@linux.ie>
Subject: Problems with AGPGART/drm and X11 2D-acceleration
Message-ID: <Pine.LNX.4.44L0.0903061522001.2715-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been experiencing problems running X with recent kernels.  
Without 2D-acceleration everything seems to work okay, but scrolling is
uncomfortably slow.  With acceleration enabled...

Under 2.6.27.19, X runs okay.  But the dmesg log gets these error
messages when X start:

[   54.375769] [drm] Initialized drm 1.1.0 20060810
[   54.441049] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   54.441521] pci 0000:00:02.0: setting latency timer to 64
[   54.442380] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   54.543516] [drm:i915_getparam] *ERROR* Unknown parameter 5
[   55.292058] [drm:i915_getparam] *ERROR* Unknown parameter 5

Under 2.6.28.7, X fails during startup and exits with an error message.  
Dmesg says:

[   63.129319] [drm] Initialized drm 1.1.0 20060810
[   63.196690] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   63.196704] pci 0000:00:02.0: setting latency timer to 64
[   63.197679] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   63.457664] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
[   63.457673] [drm:i915_gem_object_pin] *ERROR* Failure to bind: -12

Under 2.6.29-rc6, X hangs during startup.  I have to reboot the machine
to recover.  Dmesg says only:

[   57.001997] [drm] Initialized drm 1.1.0 20060810
[   57.121966] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   57.121980] pci 0000:00:02.0: setting latency timer to 64
[   57.127739] [drm] Initialized i915 1.6.0 20080730 on minor 0

Relevant device info:

# lspci -v -s 0:2.0
00:02.0 VGA compatible controller: Intel Corporation 82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device (rev 03) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation Device 5247
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
        Capabilities: [d0] Power Management version 1
        Kernel modules: intelfb

>From /etc/X11/xorg.conf:

Section "Device"
        Identifier  "Card0"
        Driver      "intel"
        VendorName  "Intel Corporation"
        BoardName   "82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device"
        BusID       "PCI:0:2:0"
        Option      "AccelMethod"       "XAA"
#       Option      "NoAccel" "yes"
        Option      "BackingStore"      "on"
EndSection

I use XAA because the default EXA method causes X to hang during 
startup even under 2.6.27.

Any advice or suggestions for things to try?

Alan Stern

