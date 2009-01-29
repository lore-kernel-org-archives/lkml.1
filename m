Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZA2J6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZA2J6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZA2J57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:57:59 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:18860 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZA2J55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uOgqD872b6+eYd+tNyeStlM4/HVnumuCya2gYD8RAagZ68j0AfZ2OZxz0R9mAKki74
         jKe3sUaiAvLrtwRGvVYjtAMFj/GymcRsgm7BVzBW+8ohT+NBD9pwg7Z3a9HRD1eneiX7
         ls1H9kFAzfvKAmveFGMMeXyuXsoyNQokL45t8=
MIME-Version: 1.0
Date: Thu, 29 Jan 2009 10:57:54 +0100
Message-ID: <c4e36d110901290157q37223327m73db1e85f7699842@mail.gmail.com>
Subject: kernel BUG at drivers/gpu/drm/i915/i915_gem.c:2684!
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Eric Anholt <eric@anholt.net>, xorg@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've tried some experiments with UXA acceleration - it mostly appears
to work with fedora rawhide xorg server.
But with kernel  (commit e4a7ca29039e615ce13a61b9c6abfb2aa394e9a1)
(just shortly before -rc3)
I'm getting this oops - suspend doesn't work - display stays black,
magicsysrq works.

(using Lenovo T61, Integrated Graphics Chipset: Intel(R) 965GM)


kernel BUG at drivers/gpu/drm/i915/i915_gem.c:2684!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/backlight/thinkpad_screen/brightness
CPU 0
Modules linked in: udf crc_itu_t fuse ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc
sco l2cap bluetooth autofs4 usb_storage sunrpc ipv6 binfmt_misc loop
dm_mirror dm_region_hash dm_log dm_mod kvm_intel kvm i915 drm
i2c_algo_bit uinput snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_seq_oss snd_seq_midi_event arc4 snd_seq ecb snd_seq_device
cryptomgr aead snd_pcm_oss crypto_blkcipher crypto_hash snd_mixer_oss
snd_pcm crypto_algapi iwl3945 snd_timer thinkpad_acpi rfkill rtc_cmos
e1000e evdev intel_agp iTCO_wdt snd button rtc_core sdhci_pci i2c_i801
i2c_core soundcore mac80211 psmouse serio_raw backlight nvram sdhci
rtc_lib mmc_core led_class iTCO_vendor_support snd_page_alloc lib80211
sr_mod cdrom battery ac cfg80211 uhci_hcd ohci_hcd ehci_hcd usbcore
[last unloaded: microcode]
Pid: 3643, comm: X Not tainted 2.6.29-rc2 #24
RIP: 0010:[<ffffffffa02ee910>]  [<ffffffffa02ee910>]
i915_gem_object_unpin+0xa0/0xb0 [i915]
RSP: 0018:ffff88013aeebde8  EFLAGS: 00010296
RAX: 00000000ffffffff RBX: ffff88011215b480 RCX: 0000000000000000
RDX: ffff88011215b540 RSI: ffff88011215b540 RDI: ffff88011215b480
RBP: ffff88013aeebde8 R08: ffff88013be92000 R09: ffff88013bedc000
R10: ffff8801262129c8 R11: 0000000000000000 R12: ffff8801388de368
R13: ffff880015d3f800 R14: ffff88013be92060 R15: 0000000040086456
FS:  00007faf24ecd7b0(0000) GS:ffffffff80990040(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faf2007eef0 CR3: 00000001034a7000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 3643, threadinfo ffff88013aeea000, task ffff880126212260)
Stack:
 ffff88013aeebe18 ffffffffa02f07d8 00000000fffffff4 ffff88013be92000
 ffff880015d3f800 ffff8801388de368 ffff88013aeebe78 ffffffffa02bcc22
 ffffffff8027242d ffff88013aeebe50 ffffffffa02f0730 00007fff2ceff0c0
Call Trace:
 [<ffffffffa02f07d8>] i915_gem_unpin_ioctl+0xa8/0x110 [i915]
 [<ffffffffa02bcc22>] drm_ioctl+0x122/0x350 [drm]
 [<ffffffff8027242d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa02f0730>] ? i915_gem_unpin_ioctl+0x0/0x110 [i915]
 [<ffffffff802f3355>] vfs_ioctl+0x85/0xb0
 [<ffffffff802f3412>] do_vfs_ioctl+0x92/0x5b0
 [<ffffffff8020d1e9>] ? retint_swapgs+0xe/0x13
 [<ffffffff8020d1e9>] ? retint_swapgs+0xe/0x13
 [<ffffffff802f39d1>] sys_ioctl+0xa1/0xb0
 [<ffffffff802706bd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff8020c70b>] system_call_fastpath+0x16/0x1b
Code: 10 48 89 56 18 48 89 0a 49 8d 80 20 0a 00 00 f0 41 ff 88 20 0a
00 00 49 8d 90 24 0a 00 00 8b 47 60 f0 41 29 80 24 0a 00 00 c9 c3 <0f>
0b eb fe 0f 1f 40 00 0f 0b eb fe 0f 1f 40 00 55 48 89 e5 53
RIP  [<ffffffffa02ee910>] i915_gem_object_unpin+0xa0/0xb0 [i915]
 RSP <ffff88013aeebde8>
---[ end trace bf38996517b3b09c ]---


PM: Syncing filesystems ... done.
Freezing user space processes ...
Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze):
