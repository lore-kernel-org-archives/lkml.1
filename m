Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZDOPuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZDOPuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZDOPu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:50:26 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:39978 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZDOPuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:50:24 -0400
Date: Wed, 15 Apr 2009 11:49:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: archlinux 2.6.28 ac oops (was Re: Regression: EEE PC hangs when
 booting off battery)
In-reply-to: <49E1B2E9.5090706@tuffmail.co.uk>
Message-id: <alpine.LFD.2.00.0904151146160.5664@localhost.localdomain>
References: <49E065CF.6040408@tuffmail.co.uk>
 <20090411214045.7bdd497f.kristoffer.ericson@gmail.com>
 <49E1B2E9.5090706@tuffmail.co.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Kristoffer Ericson wrote:

> > Getting this myself, even if power cord attached. Its an tainted
> > kernel though (archlinux 2.6.28) so wasnt sure if
> > vanilla was affected.
> >
> > BUG: unable to handle kernel NULL pointer dereference at 00000000
> > IP: [<f850d031>] acpi_ac_get_state+0x1b/0x59 [ac]
> > *pde = 00000000
> > Oops: 0000 [#1] PREEMPT SMP
> > last sysfs file: /sys/devices/platform/i8042/modalias
> > Modules linked in: joydev psmouse snd_pcsp serio_raw i2c_i801 iTCO_wdt iTCO_vendor_support i2c_core uvcvideo compat_ioctl32 videodev v4l1_compat sg option usbserial video output eeepc_laptop rfkill intel_agp agpgart thermal processor fan evdev button battery ac snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ath_pci wlan ath_hal(P) arc4 ecb ath5k mac80211 led_class cfg80211 atl2 rtc_cmos rtc_core rtc_lib ext3 jbd mbcache usbhid hid usb_storage sd_mod uhci_hcd ehci_hcd usbcore ata_piix ahci ata_generic pata_acpi libata scsi_mod
> >
> > Pid: 1794, comm: fsck.ext3 Tainted: P           (2.6.28-ARCH #1) 701
> > EIP: 0060:[<f850d031>] EFLAGS: 00010246 CPU: 0
> > EIP is at acpi_ac_get_state+0x1b/0x59 [ac]
> > EAX: f69559dc EBX: 00000000 ECX: 00000000 EDX: f850d418
> > ESI: f6955980 EDI: 00000001 EBP: f6834480 ESP: f6853f0c
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > Process fsck.ext3 (pid: 1794, ti=f6852000 task=f737e400 task.ti=f6852000)
> > Stack:
> >  f69559dc f6955980 f692e360 f850d2fd 00000001 f692e360 c01ab0e0 00000400
> >  b80cb000 f6834480 f692e380 00000000 00000000 00000001 00000000 00000000
> >  f7327c00 fffffffb c01aafb0 f6834480 c01cead4 f6853fa0 00000400 b80cb000
> > Call Trace:
> >  [<f850d2fd>] acpi_ac_seq_show+0x12/0x5d [ac]
> >  [<c01ab0e0>] seq_read+0x130/0x2e0
> >  [<c01aafb0>] seq_read+0x0/0x2e0
> >  [<c01cead4>] proc_reg_read+0x64/0xa0
> >  [<c01cea70>] proc_reg_read+0x0/0xa0
> >  [<c019346d>] vfs_read+0x9d/0x160
> >  [<c0193601>] sys_read+0x41/0x80
> >  [<c0103f13>] sysenter_do_call+0x12/0x33
> >  [<c0320000>] serial_pnp_probe+0x150/0x250
> > Code: b8 ea ff ff ff 75 07 8b 43 5c 89 01 31 c0 5b c3 56 89 c6 85 f6 b8 ea ff ff ff 53 74 49 8b 5e 58 8d 46 5c 31 c9 50 ba 18 d4 50 f8 <8b> 03 e8 e0 be d2 c7 89 c2 58 31 c0 85 d2 74 2b 68 1d d4 50 f8
> > EIP: [<f850d031>] acpi_ac_get_state+0x1b/0x59 [ac] SS:ESP 0068:f6853f0c
> > ---[ end trace eb12d69e27c56472 ]---
> >   
> 
> I'm pretty sure that's a separate bug :-).  As you say, it happens under
> different circumstances, it's a BUG as opposed to a hang, and it's in a
> different version (I didn't have my problem in 2.6.28).
> 
> www.kerneloops.org says no-one else has reported your bug.  So maybe
> you're right, and Arch have applied some patches which nobody else runs
> with.  I don't know how to find Arch source packages, so I can't really
> tell.
> 
> But the only _taint_ as such is due to the ath_hal module.  Let's see,
> Arch linux...
> 
> <http://wiki.archlinux.org/index.php/Udev#Blacklisting_Modules>
> describes how you can (reversibly) blacklist modules.  If you blacklist
> ath_pci (and ath_hal too, just to make sure), you could boot without any
> taint and generate a "clean" backtrace.

This oops is happening in the ac driver when user-space is 
reading /proc/acpi/ac_adapter/*/state

it would be interesting if...
you can reproduce this using a kernel.org kernel
if you delay loading of the ac module till after
the system is up and see if you can reproduce this
at will by reading the file above.

thanks,
-Len

