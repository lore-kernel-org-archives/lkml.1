Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZD1A7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZD1A7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 20:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZD1A7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 20:59:31 -0400
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:46738 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZD1A73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 20:59:29 -0400
X-Greylist: delayed 2465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 20:59:29 EDT
Message-ID: <49F64B48.9050109@uni-koeln.de>
Date: Tue, 28 Apr 2009 02:18:16 +0200
From: Berthold Cogel <cogel@uni-koeln.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops with linux 2.6.29.1 in radeon_do_cp_idle
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Somewhere around kernel 2.6.25.x one of my computers (Acer Extensa 3000) 
started freezing very often. At this point I'm unable to shutdown the 
system because the power button doesn't work anymore. I have to remove 
the battery and the power plug.

I never saw anything in the logs. So I tried different kernel versions 
and I also reinstalled the system (Debian stable). Because of some 
problems with the Debian kernel I've to build my own. At the moment it's 
a 2.6.29.1 vanilla.

Today the system got stuck again. But this time I was able to login from 
another computer which showed me that the problem is somehow related to 
X. I tried to restart gdm, which didn't work. Then I tried to kill gdm 
and the xserver. At this point I captured an Oops:

Apr 28 01:50:11 acer01 kernel: [ 1669.775938] BUG: unable to handle 
kernel NULL pointer dereference at (null)
Apr 28 01:50:11 acer01 kernel: [ 1669.775947] IP: [<f8433893>] 
radeon_do_cp_idle+0x151/0x17f [radeon]
Apr 28 01:50:11 acer01 kernel: [ 1669.775964] *pde = 00000000
Apr 28 01:50:11 acer01 kernel: [ 1669.775969] Oops: 0000 [#1] PREEMPT SMP
Apr 28 01:50:11 acer01 kernel: [ 1669.775976] last sysfs file: 
/sys/devices/virtual/thermal/thermal_zone0/temp
Apr 28 01:50:11 acer01 kernel: [ 1669.775981] Modules linked in: wacom 
binfmt_misc radeon drm rfcomm l2cap bluetooth acpi_cpufreq 
cpufreq_conservative cpufreq_ondemand cpufreq_userspace 
cpufreq_powersave cpufreq_stats freq_table ipv6 nls_utf8 nls_cp437 vfat 
fat nls_base ext2 fuse sbp2 loop joydev snd_intel8x0 hid_gaff hid_pl 
hid_cypress hid_zpff hid_gyration hid_sony hid_ntrig hid_samsung 
hid_microsoft hid_tmff hid_monterey hid_ezkey hid_apple hid_a4tech 
hid_logitech ff_memless hid_cherry hid_sunplus hid_petalynx hid_belkin 
hid_chicony snd_intel8x0m snd_ac97_codec usbhid ac97_bus hid snd_pcm_oss 
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi 
snd_seq_midi_event snd_seq snd_timer snd_seq_device rfkill i2c_i801 b44 
ohci1394 led_class snd ssb wmi tifm_7xx1 pcspkr psmouse evdev soundcore 
snd_page_alloc yenta_socket rsrc_nonstatic ipw2200 libipw i2c_core 
ieee1394 tifm_core pcmcia mii pcmcia_core lib80211 iTCO_wdt sbs irda 
crc_ccitt rng_core ehci_hcd sbshc container uhci_hcd video output butto
Apr 28 01:50:11 acer01 kernel: n usbcore intel_agp agpgart ext3 jbd 
mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod ide_cd_mod 
cdrom ide_gd_mod thermal processor fan thermal_sys ata_generic ata_piix 
libata scsi_mod piix ide_pci_generic ide_core
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] Pid: 3296, comm: Xorg Not 
tainted (2.6.29.1 #1) Extensa 3000
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] EIP: 0060:[<f8433893>] 
EFLAGS: 00013202 CPU: 0
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] EIP is at 
radeon_do_cp_idle+0x151/0x17f [radeon]
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] EAX: 00000000 EBX: 
f64db000 ECX: 0003ffff EDX: 0001fa24
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] ESI: f8980000 EDI: 
f6694400 EBP: f6f9da5c ESP: f67b9df4
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  DS: 007b ES: 007b FS: 
00d8 GS: 0000 SS: 0068
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] Process Xorg (pid: 3296, 
ti=f67b8000 task=f6794be0 task.ti=f67b8000)
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] Stack:
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  f64db000 f6694400 
f84342be 00000008 f6694400 f65cacc4 f83b96c9 00000008
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  f67f3ec0 f65cacc4 
f6f9da5c c01867ac f700c0c0 f67f3ec0 00000000 f68a10c0
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  00000000 c0184002 
f68a10c0 007fffff 00000024 c012848c f59032c0 00000000
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] Call Trace:
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<f84342be>] 
radeon_do_release+0x43/0xfe [radeon]
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<f83b96c9>] 
drm_lastclose+0x31/0x230 [drm]
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c01867ac>] 
__fput+0xa6/0x135
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c0184002>] 
filp_close+0x4e/0x54
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c012848c>] 
put_files_struct+0x60/0xa6
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c0129b2d>] 
do_exit+0x1d4/0x6d7
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c0101ff6>] 
__switch_to+0x10f/0x14e
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c012a08b>] 
do_group_exit+0x5b/0x82
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c01319df>] 
get_signal_to_deliver+0x346/0x35f
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c0102a37>] 
do_notify_resume+0x64/0x5b4
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c01fbeb5>] 
delay_tsc+0x6e/0x89
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c01fbe33>] 
__const_udelay+0x2c/0x2d
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<f8432ba5>] 
radeon_do_wait_for_idle+0x9c/0xee [radeon]
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c02e2194>] 
preempt_schedule+0x46/0x4b
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c018f749>] 
vfs_ioctl+0x50/0x5f
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c018fc76>] 
do_vfs_ioctl+0x44c/0x487
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c01030a2>] 
restore_sigcontext+0x109/0x159
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c018fcf2>] 
sys_ioctl+0x41/0x58
Apr 28 01:50:11 acer01 kernel: [ 1669.776011]  [<c01036dc>] 
work_notifysig+0x13/0x1b
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] Code: c4 14 eb 03 89 43 20 
0f ae f0 89 f6 83 7b 60 00 74 0b 8b 83 e4 00 00 00 8b 40 10 eb 0e 8b 83 
30 03 00 00 8b 40 10 05 10 07 00 00 <8b> 00 8b 53 20 8b 83 30 03 00 00 
8b 40 10 05 14 07 00 00 89 10
Apr 28 01:50:11 acer01 kernel: [ 1669.776011] EIP: [<f8433893>] 
radeon_do_cp_idle+0x151/0x17f [radeon] SS:ESP 0068:f67b9df4
Apr 28 01:50:11 acer01 kernel: [ 1669.776956] ---[ end trace 
4ea80f26738662d4 ]---
Apr 28 01:50:11 acer01 kernel: [ 1669.776961] Fixing recursive fault but 
reboot is needed!


Thanks in advance!
Berthold Cogel
