Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZEDVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZEDVEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbZEDVEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:04:10 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:47201 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbZEDVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R3+mTH35wT1UksZl8nBMhuURd47NsfEKYiurKLBCCd+fdCaS5rEPdWtx0kobb0OCVs
         JrFbCD7JWHha/VxgD/n4GPwMyZdXYjC4Xvfrq5szHx/zrET+TK1cuRFsZ5nSsnmXn6Yy
         EG/iy+/a45dzrjQGO7M7tQ4gs97xQw+gEn6Us=
MIME-Version: 1.0
Date: Mon, 4 May 2009 23:04:07 +0200
Message-ID: <b637ec0b0905041404h481463cckd4f6fb90cfd61ab2@mail.gmail.com>
Subject: 2.6.29.2 - WARNING: at kernel/hrtimer.c:625 hres_timers_resume+0x2f/0x45()
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
After a successful resume from disk I get this warning:

May  4 22:53:15 hawking kernel: ------------[ cut here ]------------
May  4 22:53:15 hawking kernel: WARNING: at kernel/hrtimer.c:625
hres_timers_resume+0x2f/0x45()
May  4 22:53:15 hawking kernel: Hardware name: Pavilion dv4000 (ES973EA#ABZ)
May  4 22:53:15 hawking kernel: hres_timers_resume() called with IRQs
enabled!Modules linked in: radeon(N) drm(N) michael_mic(N) arc4(N)
ecb(N) lib80211_crypt_tkip(N) af_packet(N) snd_pcm_oss(N)
snd_mixer_oss(N) snd_seq(N) microcode(N) snd_seq_device(N) edd(N)
cpufreq_conservative(N) cpufreq_userspace(N) cpufreq_powersave(N)
acpi_cpufreq(N) speedstep_lib(N) fuse(N) loop(N) dm_mod(N)
snd_intel8x0m(N) snd_intel8x0(N) snd_ac97_codec(N) pcmcia(N)
ac97_bus(N) sdhci_pci(N) sdhci(N) snd_pcm(N) thermal(N) snd_timer(N)
yenta_socket(N) btusb(N) iTCO_wdt(N) mmc_core(N) ipw2200(N)
tifm_7xx1(N) ohci1394(N) rsrc_nonstatic(N) 8139too(N) snd(N)
rtc_cmos(N) iTCO_vendor_support(N) video(N) processor(N) soundcore(N)
thermal_sys(N) i2c_i801(N) intel_agp(N) wmi(N) libipw(N) output(N)
led_class(N) battery(N) ac(N) 8139cp(N) tifm_core(N) ieee1394(N)
pcmcia_core(N) rtc_core(N) sr_mod(N) button(N) snd_page_alloc(N)
pcspkr(N) rtc_lib(N) i2c_core(N) hwmon(N) bluetooth(N) agpgart(N)
cdrom(N) joydev(N) sg(N) ext4(N) mbcache(N) jbd2(N) crc16(
May  4 22:53:15 hawking kernel: N) sd_mod(N) crc_t10dif(N) ata_piix(N)
libata(N) scsi_mod(N) ehci_hcd(N) uhci_hcd(N) usbcore(N)
May  4 22:53:15 hawking kernel: Supported: Yes
May  4 22:53:15 hawking kernel: Pid: 3533, comm: s2disk Tainted: G
     N  2.6.29.2-6-pae #1
May  4 22:53:15 hawking kernel: Call Trace:
May  4 22:53:15 hawking kernel:  [<c010688c>] try_stack_unwind+0x51/0x11d
May  4 22:53:15 hawking kernel:  [<c0105ca3>] dump_trace+0x55/0xca
May  4 22:53:15 hawking kernel:  [<c010665f>] show_trace_log_lvl+0x33/0x3e
May  4 22:53:15 hawking kernel:  [<c010667a>] show_trace+0x10/0x14
May  4 22:53:15 hawking kernel:  [<c03727ab>] dump_stack+0x57/0x61
May  4 22:53:15 hawking kernel:  [<c012f2a2>] warn_slowpath+0x71/0xa8
May  4 22:53:16 hawking kernel:  [<c01431cb>] hres_timers_resume+0x2f/0x45
May  4 22:53:16 hawking kernel:  [<c0147049>] timekeeping_resume+0x11f/0x125
May  4 22:53:16 hawking kernel:  [<c02bdd58>] __sysdev_resume+0x14/0x38
May  4 22:53:16 hawking kernel:  [<c02bdedd>] sysdev_resume+0xcb/0x105
May  4 22:53:16 hawking kernel:  [<c0155e69>] hibernation_snapshot+0xf1/0x189
May  4 22:53:16 hawking kernel:  [<c0159008>] snapshot_ioctl+0x214/0x4c5
May  4 22:53:16 hawking kernel:  [<c01b341f>] vfs_ioctl+0x22/0x67
May  4 22:53:16 hawking kernel:  [<c01b397a>] do_vfs_ioctl+0x444/0x47d
May  4 22:53:16 hawking kernel:  [<c01b3a1a>] sys_ioctl+0x67/0x81
May  4 22:53:16 hawking kernel:  [<c010406b>] sysenter_do_call+0x12/0x2f
May  4 22:53:17 hawking kernel:  [<ffffe430>] 0xffffe430
May  4 22:53:17 hawking kernel: ---[ end trace 8cd3b732941f0f91 ]---


This causes a second hibernate-resume cycle to hang solid during
resume. Power cycle is needed.

I'm not sure if this is a regression wrt 2.6.28.7 (my previous kernel)
because I changed the DRI driver from fglrx to radeon and also
upgraded the X.org userspace. I didn't have any hibernation-related
problem with any previous kernels for sure.

It may be related to http://lkml.org/lkml/2009/4/19/133 but the
backtrace is somewhat different.

Please let me know if you need more details.

Regards,
Fabio
