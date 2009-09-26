Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbZIZIjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbZIZIjE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 04:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZIZIjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 04:39:03 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58942 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZIZIjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 04:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hiC+LND8g/9niOkMdOu181bV0hEYL0EWL8O8ZqvdoOYquBiftAYz8fBuF15jinsA2J
         aVLPtPqT/CTrWazkRRExW6VOnvXUScqGe6+Htx0cxyGNJJDAH5Dj41O4GtN0na88VwJK
         GE8jB0tZgUclETJV/WsUy5hSHXQoPgvC3QHO0=
MIME-Version: 1.0
Date: Sat, 26 Sep 2009 14:39:05 +0600
Message-ID: <3659cc8e0909260139i638d0f59sf738c43df0a97690@mail.gmail.com>
Subject: Problem with ACPI on HP Compaq 6720s with Linux kernel 2.6.31.1
From: Sergey Sharybin <g.ulairi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using Debian GNU/Linux Lenny on my HP Compaq 6720s notebook with
Linux kernel 2.6.31.1 and there are some troubles with ACPI:

1. I could not control screen's brightness from console (on kernel
version 2.6.27.30 I easily could control this).
2. Sometimes when I open or close notebook's lid kernel crashes with.
Last time I've got such messages in kern.log:

Sep 26 13:57:53 dyna kernel: ------------[ cut here ]------------
Sep 26 13:57:53 dyna kernel: kernel BUG at mm/highmem.c:109!
Sep 26 13:57:53 dyna kernel: invalid opcode: 0000 [#1] SMP
Sep 26 13:57:53 dyna kernel: last sysfs file:
/sys/class/power_supply/C23B/uevent
Sep 26 13:57:53 dyna kernel: Modules linked in: i915 drm i2c_algo_bit
i2c_core rfcomm l2cap vboxnetadp vboxnetflt vboxdrv ipv6 cpufreq_stats
cpufreq_userspace cpufreq_conservative fuse coretemp cpufreq_ondemand
cpufreq_powersave acpi_cpufreq freq_table loop joydev
snd_hda_codec_analog usbhid btusb wacom video output bluetooth
snd_hda_intel container snd_hda_codec iwl3945 iwlcore snd_pcm snd_seq
mac80211 snd_timer snd_seq_device ac led_class button battery
processor pcspkr psmouse serio_raw snd cfg80211 soundcore
snd_page_alloc intel_agp agpgart evdev reiserfs dm_mirror
dm_region_hash dm_log dm_snapshot dm_mod sg sr_mod cdrom sd_mod
ata_piix ata_generic pata_acpi ahci libata uhci_hcd ehci_hcd scsi_mod
e1000e usbcore thermal fan thermal_sys [last unloaded: scsi_wait_scan]
Sep 26 13:57:53 dyna kernel:
Sep 26 13:57:53 dyna kernel: Pid: 26362, comm: inetstatus.sh Not
tainted (2.6.31.1-vanilla #3) HP Compaq 6720s
Sep 26 13:57:53 dyna kernel: EIP: 0060:[<c107e413>] EFLAGS: 00010246 CPU: 1
Sep 26 13:57:53 dyna kernel: EIP is at flush_all_zero_pkmaps+0x2b/0x71
Sep 26 13:57:53 dyna kernel: EAX: 00000000 EBX: c1b11c20 ECX: 00007b7b
EDX: c13bb780
Sep 26 13:57:53 dyna kernel: ESI: 00000e00 EDI: c000fe00 EBP: f1e5fee8
ESP: f1e5fedc
Sep 26 13:57:53 dyna kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Sep 26 13:57:53 dyna kernel: Process inetstatus.sh (pid: 26362,
ti=f1e5e000 task=f1a48000 task.ti=f1e5e000)
Sep 26 13:57:53 dyna kernel: Stack:
Sep 26 13:57:53 dyna kernel:  00000000 c1b1aec0 bfffffed f1e5ff18
c107e4a4 f1e5fef8 f1e5ff20 c1095230
Sep 26 13:57:53 dyna kernel: <0> 00000001 00000001 00000001 f1e5ff10
00000ffc 0000000f bfffffed f1e5ff20
Sep 26 13:57:53 dyna kernel: <0> c101bffc f1e5ff58 c109536b f1969200
00000000 00000000 00000000 00000000
Sep 26 13:57:53 dyna kernel: Call Trace:
Sep 26 13:57:53 dyna kernel:  [<c107e4a4>] ? kmap_high+0x4b/0x169
Sep 26 13:57:53 dyna kernel:  [<c1095230>] ? get_arg_page+0x2d/0x80
Sep 26 13:57:53 dyna kernel:  [<c101bffc>] ? kmap+0x39/0x45
Sep 26 13:57:53 dyna kernel:  [<c109536b>] ? copy_strings+0xe8/0x160
Sep 26 13:57:53 dyna kernel:  [<c10953ff>] ? copy_strings_kernel+0x1c/0x2b
Sep 26 13:57:53 dyna kernel:  [<c109671c>] ? do_execve+0x1a6/0x2d2
Sep 26 13:57:53 dyna kernel:  [<c1001656>] ? sys_execve+0x26/0x53
Sep 26 13:57:53 dyna kernel:  [<c1002948>] ? sysenter_do_call+0x12/0x26
Sep 26 13:57:53 dyna kernel: Code: 55 31 c0 89 e5 57 56 31 f6 53 83 be
c4 95 3b c1 01 75 45 c7 86 c4 95 3b c1 00 00 00 00 89 f7 03 3d c0 95
3b c1 8b 07 85 c0 75 04 <0f> 0b eb fe 89 c3 c1 eb 0c c1 e3 05 03 1d 00
06 3c c1 89 d8 e8
Sep 26 13:57:53 dyna kernel: EIP: [<c107e413>]
flush_all_zero_pkmaps+0x2b/0x71 SS:ESP 0068:f1e5fedc
Sep 26 13:57:53 dyna kernel: ---[ end trace 8672ce23b8920e71 ]---

P.S. inetstatus.sh is my own script which checks ifconfig's output and
prints "Online" or "Offline" to the stdout.

-- 
With best regards, Sergey I. Sharybin
