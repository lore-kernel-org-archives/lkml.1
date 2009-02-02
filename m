Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbZBBXYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbZBBXYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbZBBXYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:24:00 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:50792 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZBBXX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:23:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sxVsjIHPP9nhDJEQoKgfc2gVdlmTchhqLl0Xj5C5lCbnvXeJKvgxrLXJDDWUOSi478
         pS3iEakz8JkdLO6uggzN/nR9POVPdM6pTJ8RCG6qPQzk/Yc0bURnWvk5KHSHJPTp2inq
         2jK2lGMXrry7BUXTC3wSyVDqjKVAF6YDg1oCA=
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 00:23:57 +0100
Message-ID: <c4e36d110902021523q267c1929mcaf75db318fd35f5@mail.gmail.com>
Subject: jffs2 divide error: 0000 [#1] SMP
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing some experiments with jffs2 I've got this oops:

I assume division by zero in fs/jffs2/fs.c : 508   should be checked
for valid argument

MTDSB: lookup_bdev() returned 0
MTDSB: New superblock for device 0 ("block2mtd: /dev/loop0")
divide error: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 1
Modules linked in: block2mtd jffs2 zlib_deflate lzo_decompress
lzo_compress zlib_inflate mtdblock mtd_blkdevs mtd fuse ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge stp llc sco l2cap bluetooth autofs4 sunrpc ipv6 binfmt_misc
loop dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm i915 drm
i2c_algo_bit uinput arc4 ecb cryptomgr snd_hda_codec_analog aead
snd_hda_intel crypto_blkcipher crypto_hash snd_hda_codec crypto_algapi
iwl3945 snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device evdev
sdhci_pci snd_pcm_oss mac80211 sdhci mmc_core e1000e rtc_cmos
thinkpad_acpi rfkill backlight button rtc_core nvram led_class ac
iTCO_wdt snd_mixer_oss snd_pcm lib80211 psmouse serio_raw sr_mod cdrom
battery i2c_i801 i2c_core iTCO_vendor_support intel_agp snd_timer
cfg80211 rtc_lib snd soundcore snd_page_alloc uhci_hcd ohci_hcd
ehci_hcd usbcore [last unloaded: block2mtd]
Pid: 4459, comm: mount Not tainted 2.6.29-rc3 #27
RIP: 0010:[<ffffffffa05029a6>]  [<ffffffffa05029a6>]
jffs2_do_fill_super+0x46/0x2a0 [jffs2]
RSP: 0018:ffff8800adcb9c88  EFLAGS: 00010246
RAX: 0000000000005000 RBX: ffff8801276e5800 RCX: 0000000000005000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8800adcb9ca8 R08: 0000000000000004 R09: ffffffff8074d8f0
R10: 0000000000000001 R11: ffffffff802706bd R12: ffff8801276e0800
R13: 0000000000000000 R14: ffff8801276e0800 R15: 0000000000000000
FS:  00007f9591a927e0(0000) GS:ffff88013b294000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f959273b000 CR3: 00000000aa0b6000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 4459, threadinfo ffff8800adcb8000, task ffff8800aa0a0000)
Stack:
 ffff8801276e5800 ffff8801276e0800 0000000000000000 0000000000000000
 ffff8800adcb9cd8 ffffffffa05037da ffff8801276e0800 00000000276e0800
 0000000000000000 ffff880129043c18 ffff8800adcb9d18 ffffffffa03649ea
Call Trace:
 [<ffffffffa05037da>] jffs2_fill_super+0x11a/0x130 [jffs2]
 [<ffffffffa03649ea>] get_sb_mtd_aux+0x8a/0x110 [mtd]
 [<ffffffffa05036c0>] ? jffs2_fill_super+0x0/0x130 [jffs2]
 [<ffffffffa05036c0>] ? jffs2_fill_super+0x0/0x130 [jffs2]
 [<ffffffffa0364ad9>] get_sb_mtd_nr+0x69/0xa0 [mtd]
 [<ffffffffa05036c0>] ? jffs2_fill_super+0x0/0x130 [jffs2]
 [<ffffffffa0364c07>] get_sb_mtd+0xf7/0x210 [mtd]
 [<ffffffff802c499b>] ? kstrdup+0x5b/0x80
 [<ffffffffa0503498>] jffs2_get_sb+0x18/0x20 [jffs2]
 [<ffffffff802e6fd1>] vfs_kern_mount+0x81/0x180
 [<ffffffff802e7143>] do_kern_mount+0x53/0x110
 [<ffffffff80300ad6>] do_mount+0x676/0x8b0
 [<ffffffff80300dd0>] sys_mount+0xc0/0xf0
 [<ffffffff80555a1e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b
Code: 0f 1f 44 00 00 48 8b 9f 18 05 00 00 49 89 fe 48 8b 03 48 8b 50
08 89 93 6c 01 00 00 89 d1 8b 78 10 89 d0 89 bb 88 01 00 00 31 d2 <f7>
f7 89 c2 89 c8 48 0f af d7 48 39 c2 0f 85 08 02 00 00 8b b3
RIP  [<ffffffffa05029a6>] jffs2_do_fill_super+0x46/0x2a0 [jffs2]
 RSP <ffff8800adcb9c88>
---[ end trace e00b83d1001e1d51 ]---

Zdenek
