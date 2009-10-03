Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZJCNxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZJCNxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbZJCNxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:53:44 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:43860 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403AbZJCNxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:53:43 -0400
Date: Sat, 3 Oct 2009 16:53:42 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: How to disable drm/kms actions during boot?
Message-ID: <20091003135342.GF32486@mea-ext.zmailer.org>
References: <20091003121958.GD32486@mea-ext.zmailer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003121958.GD32486@mea-ext.zmailer.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 03:19:58PM +0300, Matti Aarnio wrote:
> I have a display card + display combination that has recently had much problems
> during system boot.  Some system versions boot just fine to very large text mode,
> others create entirely black display.
> 
> Is there any way to forbid the DRM from doing "maximize the text display area"
> operation at all during the boot?  I do want the DRM/KMS to happen latter, but
> NOT during system boot!

I will emphasize some more:  I want to have all of that drm initialization to happen,
EXCEPT do not want to allow it to make display mode change during the boot!

Call me a dinosaur, or whatever, but getting the system to boot to text console
used to be "guaranteed thing", except that now it is not :-(   I do not want windows,
I want Linux.   When I then see that system did boot correctly, I will MANUALLY
start X.

I might even permit the init-script to start the xdm or other graphical login manager,
but only after the bootup has been completed all the way to userspace!

I tried  vga=ask  on boot line, but of course it did not have effect on drm.

>    Best regards,  Matti Aarnio
> 
> From failing case:
> 
>   kernel: Linux version 2.6.31.1-48.fc12.x86_64 (mockbuild@x86-6.fedora.phx.redhat.com) (gcc version 4.4.1 20090923 (Red Hat 4.4.1-16) (GCC) ) #1 SMP Fri Sep 25 16:57:40 EDT 2009
>   ....
>  kernel: [drm] Initialized drm 1.1.0 20060810
>  kernel: [drm] radeon defaulting to kernel modesetting.
>  rsyslogd: [origin software="rsyslogd" swVersion="4.4.1" x-pid="1396" x-info="http://www.rsyslog.com"] (re)start
>  kernel: [drm] radeon kernel modesetting enabled.
>  kernel: ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
>  kernel: radeon 0000:01:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
>  kernel: [drm] radeon: Initializing kernel modesetting.
>  kernel: [drm] register mmio base: 0xC1000000
>  kernel: [drm] register mmio size: 65536
>  kernel: ATOM BIOS: 11X
>  kernel: [drm] Clocks initialized !
>  kernel: [drm] Detected VRAM RAM=512M, BAR=256M
>  kernel: [drm] RAM width 128bits DDR
>  kernel: [TTM] Zone  kernel: Available graphics memory: 1997734 kiB.
>  kernel: [drm] radeon: 512M of VRAM memory ready
>  kernel: [drm] radeon: 512M of GTT memory ready.
>  kernel: [drm] Loading RV630 CP Microcode
>  kernel: platform radeon_cp.0: firmware: requesting radeon/RV630_pfp.bin
>  kernel: platform radeon_cp.0: firmware: requesting radeon/RV630_me.bin
>  kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
>  kernel: [drm] ring test succeeded in 0 usecs
>  kernel: usb 1-7: new high speed USB device using ehci_hcd and address 6
>  kernel: [drm] radeon: ib pool ready.
>  kernel: [drm] ib test succeeded in 0 usecs
>  kernel: [drm] radeon: kernel modesetting successfully initialized.
>  kernel: [drm] Radeon Display Connectors
>  kernel: [drm] Connector 0:
>  kernel: [drm]   DVI-I
>  kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
>  kernel: [drm]   Encoders:
>  kernel: [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
>  kernel: [drm]     CRT2: INTERNAL_KLDSCP_DAC2
>  kernel: [drm] Connector 1:
>  kernel: [drm]   DIN
>  kernel: [drm]   Encoders:
>  kernel: [drm]     TV1: INTERNAL_KLDSCP_DAC2
>  kernel: [drm] Connector 2:
>  kernel: [drm]   DVI-I
>  kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
>  kernel: [drm]   Encoders:
>  kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
>  kernel: [drm]     DFP2: INTERNAL_LVTM1
>  kernel: usb 1-7: New USB device found, idVendor=05e3, idProduct=0605
>  kernel: usb 1-7: New USB device strings: Mfr=0, Product=1, SerialNumber=0
>  kernel: usb 1-7: Product: USB2.0 Hub
>  kernel: usb 1-7: configuration #1 chosen from 1 choice
>  kernel: hub 1-7:1.0: USB hub found
>  kernel: hub 1-7:1.0: 4 ports detected
>  kernel: [drm] fb mappable at 0xB0141000
>  kernel: [drm] vram apper at 0xB0000000
>  kernel: [drm] size 9216000
>  kernel: [drm] fb depth is 24
>  kernel: [drm]    pitch is 7680
>  kernel: executing set pll
>  kernel: executing set crtc timing
>  kernel: [drm] TMDS-15: set mode 1920x1200 27
>  kernel: Console: switching to colour frame buffer device 240x75
>  kernel: fb0: radeondrmfb frame buffer device
>  kernel: registered panic notifier
>  kernel: [drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0
>  kernel: work_for_cpu used greatest stack depth: 2672 bytes left
>  kernel: dracut: Starting plymouth daemon
> .....
> 
> 
> And from case showing up the text console:
> 
>  kernel: Linux version 2.6.31-33.fc12.x86_64 (mockbuild@x86-5.fedora.phx.redhat.com) (gcc version 4.4.1 20090916 (Red Hat 4.4.1-14) (GCC) ) #1 SMP Thu Sep 17 15:40:43 EDT 2009
>  .....
>  kernel: [drm] Initialized drm 1.1.0 20060810
>  kernel: [drm] radeon defaulting to kernel modesetting.
>  kernel: [drm] radeon kernel modesetting enabled.
>  kernel: ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
>  kernel: radeon 0000:01:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
>  kernel: [drm] radeon: Initializing kernel modesetting.
>  kernel: [drm] register mmio base: 0xC1000000
>  kernel: [drm] register mmio size: 65536
>  kernel: ATOM BIOS: 11X
>  kernel: [drm] Clocks initialized !
>  kernel: [TTM] Zone  kernel: Available graphics memory: 1997734 kiB.
>  kernel: [drm] radeon: 512M of VRAM memory ready
>  kernel: [drm] radeon: 512M of GTT memory ready.
>  kernel: [drm] Loading RV630 CP Microcode
>  kernel: platform radeon_cp.0: firmware: requesting radeon/RV630_pfp.bin
>  kernel: platform radeon_cp.0: firmware: requesting radeon/RV630_me.bin
>  kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
>  kernel: usb 1-7: new high speed USB device using ehci_hcd and address 6
>  kernel: [drm] ring test succeeded in 0 usecs
>  kernel: [drm] radeon: ib pool ready.
>  kernel: [drm] ib test succeeded in 0 usecs
>  kernel: [drm] Radeon Display Connectors
>  kernel: [drm] Connector 0:
>  kernel: [drm]   DVI-I
>  kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
>  kernel: [drm]   Encoders:
>  kernel: [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
>  kernel: [drm]     CRT2: INTERNAL_KLDSCP_DAC2
>  kernel: [drm] Connector 1:
>  kernel: [drm]   DVI-I
>  kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
>  kernel: [drm]   Encoders:
>  kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
>  kernel: [drm]     DFP2: INTERNAL_LVTM1
>  kernel: usb 1-7: New USB device found, idVendor=05e3, idProduct=0605
>  kernel: usb 1-7: New USB device strings: Mfr=0, Product=1, SerialNumber=0
>  kernel: usb 1-7: Product: USB2.0 Hub
>  kernel: usb 1-7: configuration #1 chosen from 1 choice
>  kernel: hub 1-7:1.0: USB hub found
>  kernel: hub 1-7:1.0: 4 ports detected
>  kernel: [drm] fb mappable at 0xB0141000
>  kernel: [drm] vram apper at 0xB0000000
>  kernel: [drm] size 9216000
>  kernel: [drm] fb depth is 24
>  kernel: [drm]    pitch is 7680
>  kernel: executing set pll
>  kernel: executing set crtc timing
>  kernel: [drm] TMDS-10: set mode 1920x1200 22
>  kernel: Console: switching to colour frame buffer device 240x75
>  kernel: fb0: radeondrmfb frame buffer device
>  kernel: registered panic notifier
>  kernel: [drm] radeon: kernel modesetting successfully initialized.
>  kernel: [drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0
>  kernel: work_for_cpu used greatest stack depth: 2656 bytes left
>  kernel: dracut: Starting plymouth daemon
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
