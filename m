Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbZDKTZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbZDKTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbZDKTZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:25:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47881 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758244AbZDKTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hPlTINLz5Hmpv2eWfmi+/WqnwY4sCSFpC2MuQKTsZ4uTDIIo+ycOkf7XWe3tpcc2R9
         AnzxUQaCpfXefPXKpn0kkevgcc2EV/GcYWUN2U8/HoQoE11V7cK6gktQMAn0mB8H0PBz
         PvzWaYhQlEg2H+KoNWPWl0ExTFCJ+cvctWfS4=
Date: Sat, 11 Apr 2009 21:40:45 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Regression: EEE PC hangs when booting off battery
Message-Id: <20090411214045.7bdd497f.kristoffer.ericson@gmail.com>
In-Reply-To: <49E065CF.6040408@tuffmail.co.uk>
References: <49E065CF.6040408@tuffmail.co.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 10:41:35 +0100
Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> Regression #6 on latest git! (last known good is 2.6.29-rc8)
> 
> My EEE PC hangs on bootup if it is not connected to mains power.  The
> hang happens during udev coldplug.  I've left it for >60 seconds with
> nmi_watchdog=1, soft lockup and hung task detection are enabled, and I
> get no trace.  Key presses are not echoed to the screen.

Getting this myself, even if power cord attached. Its an tainted
kernel though (archlinux 2.6.28) so wasnt sure if
vanilla was affected.

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<f850d031>] acpi_ac_get_state+0x1b/0x59 [ac]
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/platform/i8042/modalias
Modules linked in: joydev psmouse snd_pcsp serio_raw i2c_i801 iTCO_wdt iTCO_vendor_support i2c_core uvcvideo compat_ioctl32 videodev v4l1_compat sg option usbserial video output eeepc_laptop rfkill intel_agp agpgart thermal processor fan evdev button battery ac snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss snd soundcore ath_pci wlan ath_hal(P) arc4 ecb ath5k mac80211 led_class cfg80211 atl2 rtc_cmos rtc_core rtc_lib ext3 jbd mbcache usbhid hid usb_storage sd_mod uhci_hcd ehci_hcd usbcore ata_piix ahci ata_generic pata_acpi libata scsi_mod

Pid: 1794, comm: fsck.ext3 Tainted: P           (2.6.28-ARCH #1) 701
EIP: 0060:[<f850d031>] EFLAGS: 00010246 CPU: 0
EIP is at acpi_ac_get_state+0x1b/0x59 [ac]
EAX: f69559dc EBX: 00000000 ECX: 00000000 EDX: f850d418
ESI: f6955980 EDI: 00000001 EBP: f6834480 ESP: f6853f0c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process fsck.ext3 (pid: 1794, ti=f6852000 task=f737e400 task.ti=f6852000)
Stack:
 f69559dc f6955980 f692e360 f850d2fd 00000001 f692e360 c01ab0e0 00000400
 b80cb000 f6834480 f692e380 00000000 00000000 00000001 00000000 00000000
 f7327c00 fffffffb c01aafb0 f6834480 c01cead4 f6853fa0 00000400 b80cb000
Call Trace:
 [<f850d2fd>] acpi_ac_seq_show+0x12/0x5d [ac]
 [<c01ab0e0>] seq_read+0x130/0x2e0
 [<c01aafb0>] seq_read+0x0/0x2e0
 [<c01cead4>] proc_reg_read+0x64/0xa0
 [<c01cea70>] proc_reg_read+0x0/0xa0
 [<c019346d>] vfs_read+0x9d/0x160
 [<c0193601>] sys_read+0x41/0x80
 [<c0103f13>] sysenter_do_call+0x12/0x33
 [<c0320000>] serial_pnp_probe+0x150/0x250
Code: b8 ea ff ff ff 75 07 8b 43 5c 89 01 31 c0 5b c3 56 89 c6 85 f6 b8 ea ff ff ff 53 74 49 8b 5e 58 8d 46 5c 31 c9 50 ba 18 d4 50 f8 <8b> 03 e8 e0 be d2 c7 89 c2 58 31 c0 85 d2 74 2b 68 1d d4 50 f8
EIP: [<f850d031>] acpi_ac_get_state+0x1b/0x59 [ac] SS:ESP 0068:f6853f0c
---[ end trace eb12d69e27c56472 ]---

> 
> Magic SysRQ keys work though.  Unfortunately, SysRq-W / SysRq-T generate
> too much output, so the useful bits immediately scroll off the top of
> the screen.  I can't press SysRq-P (even if that would help), because
> the SysRQ key on my laptop is accessed using a Fn modifier key, which
> also turns the left hand side of the keyboard into a numeric pad.
> 
> Magic SysRQs on my USB keyboard generate no response.  (Sometimes the
> numlock key seems to work though.  I can't tell on the laptop keyboard
> because the laptop doesn't have a numlock led).
> 
> I also tried booting with vga=ask (anticipating nmi_watchdog output),
> and selecting the highest mode, 80x60.  It turns out that this doesn't
> really work, the screen flickers constantly until userspace changes the
> console font.  However, it avoided the hang in udev coldplug.  Instead,
> the hang occurred when X started, leaving me with a black screen and a
> non-responsive X cursor.
> 
> Booting with acpi=off fixes this.
> 
> Regards
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
