Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZLWItz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZLWItz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbZLWIty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:49:54 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:43699 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZLWIty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:49:54 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Dec 2009 03:49:53 EST
Date: Wed, 23 Dec 2009 10:43:01 +0200 (EET)
From: Timo Jantunen <jeti@welho.com>
To: Greg KH <gregkh@suse.de>, Alex Deucher <alexdeucher@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: KMS regression (Re: Linux 2.6.32.2)
In-Reply-To: <20091218225656.GA19000@kroah.com>
Message-ID: <alpine.LNX.2.00.0912231029130.6892@limbo>
References: <20091218225656.GA19000@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009, Greg KH wrote:

> I'm announcing the release of the 2.6.32.2 kernel.  All users of the
> 2.6.32 kernel series are very strongly encouraged to upgrade.


> Alex Deucher (5):
>      drm/radeon/kms: handle vblanks properly with dpms on

This patch breaks KMS on my machine. If it is in, the screen goes blank, 
and as far as I can tell the machine hangs (no disk activity, SysRq keys 
don't work, nothing on the netconsole.) The machine boots (and works) 
normally if KMS is disabled.

I'm using the DVI connector.

lspci
===cut
01:00.0 VGA compatible controller: ATI Technologies Inc RV770 [Radeon HD 4850] (prog-if 00 [VGA controller])
 	Subsystem: Giga-byte Technology Device 21c7
 	Flags: bus master, fast devsel, latency 0, IRQ 16
 	Memory at e0000000 (64-bit, prefetchable) [size=256M]
 	Memory at fbde0000 (64-bit, non-prefetchable) [size=64K]
 	I/O ports at ce00 [size=256]
 	[virtual] Expansion ROM at fbd00000 [disabled] [size=128K]
 	Capabilities: [50] Power Management version 3
 	Capabilities: [58] Express Legacy Endpoint, MSI 00
 	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
 	Capabilities: [100] Vendor Specific Information <?>
===cut

And partial dmesg from 2.6.32.2 with that one patch reverted:
dmesg | egrep 'drm|radeon'
===cut
Kernel command line: ro root=/dev/sda2 
netconsole=2001@10.0.0.1/eth0,2001@10.0.0.254/ vga=6 radeon.modeset=1
[drm] Initialized drm 1.1.0 20060810
[drm] radeon kernel modesetting enabled.
radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
radeon 0000:01:00.0: setting latency timer to 64
[drm] radeon: Initializing kernel modesetting.
[drm] register mmio base: 0xFBDE0000
[drm] register mmio size: 65536
[drm] Clocks initialized !
[drm] Detected VRAM RAM=256M, BAR=256M
[drm] RAM width 256bits DDR
[drm] radeon: 256M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Loading RV770 CP Microcode
platform radeon_cp.0: firmware: using built-in firmware 
radeon/RV770_pfp.bin
platform radeon_cp.0: firmware: using built-in firmware radeon/RV770_me.bin
[drm] GART: num cpu pages 131072, num gpu pages 131072
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   HDMI-A
[drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY
[drm] Connector 1:
[drm]   VGA
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Connector 2:
[drm]   DVI-I
[drm]   DDC: 0x7e20 0x7e20 0x7e24 0x7e24 0x7e28 0x7e28 0x7e2c 0x7e2c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[drm] fb mappable at 0xE0141000
[drm] vram apper at 0xE0000000
[drm] size 7680000
[drm] fb depth is 24
[drm]    pitch is 6400
[drm] TMDS-15: set mode 1600x1200 21
fb0: radeondrmfb frame buffer device
[drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0
===cut


//T

