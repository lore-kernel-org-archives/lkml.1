Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZGDDUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZGDDUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 23:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZGDDUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 23:20:31 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:41273 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZGDDUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 23:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=DPurMFHYln3rNx4Iaa+oSJEaCxlRRjhGNh6dDcT2HP6BAvDifSo1e6JW4oL16zd3ik
         CtIJrnQ7DGLl9s0GS/EqSi2tM3TZNghx/SuM8SZy6lmGH3WQ5+I8mIYUhz91qeKYCEO4
         aTXV8FhmY2j1C/2Ah/p9/q4sIgcZMrjvpFNhU=
Message-ID: <4A4ECA63.2080500@gmail.com>
Date: Sat, 04 Jul 2009 07:20:03 +0400
From: Eugene Kapun <abacabadabacaba@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: reiserfs-devel@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: PROBLEM: crash if reiserfs partition has regular file named .reiserfs_priv
 in it's root directory
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reiserfs crashes if regular file .reiserfs_priv exists in root directory
of reiserfs partitions. This is reproducible on different builds of
2.6.29, 2.6.30 and 2.6.31 kernel. On 2.6.29 and older 2.6.30 kernels,
crash will occur only if CONFIG_REISERFS_XATTR=y.

How to reproduce:
1. Create reiserfs partition.
2. On older kernel compiled with CONFIG_REISERFS_XATTR=n create file
.reiserfs_priv in partition root.
3. Mount this partition on newer kernel. Older kernels compiled with
CONFIG_REISERFS_XATTR=y will crash too, but only when trying to delete
some file/directory.
4. Oops.

Software versions:
Gnu C                  4.4.0
Gnu make               3.81
binutils               2.19.51.20090622
util-linux             2.15.1-rc1
mount                  support
module-init-tools      3.8
e2fsprogs              1.41.5
reiserfsprogs          3.6.21
pcmciautils            014
Linux C Library        2.9
Dynamic linker (ldd)   2.9
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
wireless-tools         29
Modules Loaded         usb_storage tun binfmt_misc ppdev kqemu sbp2 lp
parport snd_hda_codec_realtek snd_hda_intel snd_hda_codec joydev
snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy snd_seq_oss ecb
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq ath5k pcmcia
snd_timer snd_seq_device mac80211 nsc_ircc uvcvideo ath yenta_socket
rsrc_nonstatic snd soundcore videodev sdhci_pci psmouse irda acer_wmi
pcmcia_core snd_page_alloc v4l1_compat v4l2_compat_ioctl32 tifm_7xx1
tifm_core iTCO_wdt iTCO_vendor_support sdhci serio_raw pcspkr cfg80211
crc_ccitt led_class ohci1394 ieee1394 tg3 usbhid fbcon tileblit font
bitblit softcursor i915 drm i2c_algo_bit video output intel_agp

dmesg output:
[   95.335301] REISERFS (device sdb): found reiserfs format "3.6" with
standard journal
[   95.336228] REISERFS (device sdb): using ordered data mode
[   95.360648] REISERFS (device sdb): journal params: device sdb, size
8192, journal first block 18, max trans len 1024, max batch 900, max
commit age 30, max trans age 30
[   95.364551] REISERFS (device sdb): checking transaction log (sdb)
[   95.394471] REISERFS (device sdb): Using r5 hash to sort names
[   95.397182] BUG: unable to handle kernel NULL pointer dereference at
(null)
[   95.397803] IP: [<(null)>] (null)
[   95.398043] PGD 1d9f067 PUD 3a36067 PMD 0
[   95.398324] Oops: 0010 [#1] SMP
[   95.398645] last sysfs file: /sys/kernel/uevent_seqnum
[   95.398846] CPU 0
[   95.398965] Modules linked in: reiserfs ppdev virtio_balloon psmouse
serio_raw pcspkr parport_pc i2c_piix4 parport ne2k_pci 8390 virtio_pci
virtio_ring floppy virtio fbcon tileblit font bitblit softcursor i915
drm i2c_algo_bit video output intel_agp
[   95.399985] Pid: 1917, comm: mount Not tainted
2.6.31-rc1-git10-generic-vanilla #1
[   95.400169] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
[   95.400169] RSP: 0018:ffff880003a9dbc0  EFLAGS: 00000286
[   95.400169] RAX: ffffffffa0167180 RBX: ffff88000386d600 RCX:
0000000000000000
[   95.400169] RDX: 0000000000000000 RSI: ffff88000386d600 RDI:
ffff8800039e2350
[   95.400169] RBP: ffff880003a9dc08 R08: ffff8800019a2d73 R09:
00000000000000c0
[   95.400169] R10: ffde61db876d5807 R11: 0000000000000000 R12:
ffff880003a9dc28
[   95.400169] R13: ffff8800039e2350 R14: fffffffffffffff4 R15:
0000000000000000
[   95.400169] FS:  00007f11d793b7d0(0000) GS:ffff880001991000(0000)
knlGS:0000000000000000
[   95.400169] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   95.400169] CR2: 0000000000000000 CR3: 0000000002995000 CR4:
00000000000006b0
[   95.400169] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   95.400169] DR3: 0000000000000000 DR6: 0000000000000000 DR7:
0000000000000000
[   95.400169] Process mount (pid: 1917, threadinfo ffff880003a9c000,
task ffff880000cb2d60)
[   95.400169] Stack:
[   95.400169]  ffffffff8111901a ffff880003a9dc18 ffffffff8111901a
0000000000000001
[   95.400169] <0> ffff880000804540 ffffffffa016cfd0 0000000000000000
0000000000000000
[   95.400169] <0> ffff880003386000 ffff880003a9dc48 ffffffff811192e7
ffff880003a9dc58
[   95.400169] Call Trace:
[   95.400169]  [<ffffffff8111901a>] ? __lookup_hash+0xfa/0x150
[   95.400169]  [<ffffffff8111901a>] ? __lookup_hash+0xfa/0x150
[   95.400169]  [<ffffffff811192e7>] lookup_one_len+0xc7/0x110
[   95.400169]  [<ffffffff811192e7>] ? lookup_one_len+0xc7/0x110
[   95.400169]  [<ffffffffa016530c>] reiserfs_xattr_init+0x1dc/0x260
[reiserfs]
[   95.400169]  [<ffffffffa0150da7>] reiserfs_fill_super+0x8c7/0xc00
[reiserfs]
[   95.400169]  [<ffffffff8111132f>] get_sb_bdev+0x16f/0x1b0
[   95.400169]  [<ffffffffa01504e0>] ? reiserfs_fill_super+0x0/0xc00
[reiserfs]
[   95.400169]  [<ffffffff8110959b>] ? __alloc_percpu+0xb/0x10
[   95.400169]  [<ffffffffa014d653>] get_super_block+0x13/0x20 [reiserfs]
[   95.400169]  [<ffffffff81110e06>] vfs_kern_mount+0x76/0x180
[   95.400169]  [<ffffffff81110f7d>] do_kern_mount+0x4d/0x120
[   95.400169]  [<ffffffff8112929f>] do_mount+0x2ff/0x880
[   95.400169]  [<ffffffff811298af>] sys_mount+0x8f/0xe0
[   95.400169]  [<ffffffff81011ec2>] system_call_fastpath+0x16/0x1b
[   95.400169] Code:  Bad RIP value.
[   95.400169] RIP  [<(null)>] (null)
[   95.400169]  RSP <ffff880003a9dbc0>
[   95.400169] CR2: 0000000000000000
[   95.426324] ---[ end trace 5768429dcc99b425 ]---

BTW, it will be good if any special treatment of .reiserfs_priv could be
disabled by mount option.
