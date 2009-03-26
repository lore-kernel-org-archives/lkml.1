Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZCZKI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZCZKI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 06:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZCZKIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 06:08:50 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57686 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZCZKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 06:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fA0nLAQzeyAV7tCH2l41tBgyHsp+ks5yP6xgLPz528lUpGLnYVoZdvrj4CYWA2bLGb
         LSDaqVjAI2Bsd3JTt8wIy+OrOqHVimoyrV6+aUl967CYeBe+kLJNrpTEH33EQu2sORjl
         zSqW2BaPt8kI2ydzbcZ2P5BBFkLQCk350NWUg=
MIME-Version: 1.0
Date: Thu, 26 Mar 2009 11:08:45 +0100
Message-ID: <c4e36d110903260308m795d7374gb068da5336e75a55@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer in i915 driver
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: intel-gfx@lists.freedesktop.org, Eric Anholt <eric@anholt.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It happened once during some Xorg crash/shutdown.

Hw - T61, 4GB, C2D, GMA965, X86_64, clean 2.6.29 vanilla kernel
Running git drm & intel driver, xorg-x11-server-Xorg-1.6.0-13.fc11.x86_64

i915_wait_ring() - looks like the function possible tried to access
some already removed pages after some msleep() ??

Also I'm not able to get the same oops again - so I've no idea how to
check potentional bugfixes... :(
and I should add that my kernel got "Tainted" by the Warning message -
also appended

Zdenek


BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
IP: [<ffffffffa030b96e>] i915_wait_ring+0x2e/0x1a0 [i915]
PGD 12f074067 PUD 11dac0067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
CPU 1
Modules linked in: oprofile tun sysprof_module fuse ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_connt
rack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp
llc rfcomm sco l2cap autofs4 sunrpc ipv6 binfmt_misc loop dm_mirror
dm_region_hash dm_log dm_mod kvm_intel kvm i91
5 drm i2c_algo_bit uinput arc4 snd_hda_codec_analog ecb cryptomgr aead
crypto_blkcipher crypto_hash snd_hda_intel btusb snd_hda_codec
snd_seq_oss snd_seq_midi_event snd_seq rtc_cmos blu
etooth rtc_core snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm
sr_mod snd_timer crypto_algapi thinkpad_acpi backlight iwl3945
i2c_i801 i2c_core rfkill usbhid mac80211 lib80211 hid sdh
ci_pci sdhci mmc_core intel_agp cfg80211 cdrom e1000e snd soundcore
rtc_lib led_class psmouse evdev serio_raw iTCO_wdt button ac battery
snd_page_alloc nvram iTCO_vendor_support uhci_hc
d ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
Pid: 21403, comm: X Tainted: G        W  2.6.29 #48 6464CTO
RIP: 0010:[<ffffffffa030b96e>]  [<ffffffffa030b96e>]
i915_wait_ring+0x2e/0x1a0 [i915]
RSP: 0018:ffff88011dac5c68  EFLAGS: 00010292
RAX: 0000000000000000 RBX: ffff88013a5d4000 RCX: 0000000000000000
RDX: ffffffffa0323b10 RSI: 0000000000000010 RDI: ffff8801374b2000
RBP: ffff88011dac5ca8 R08: 0000000000000000 R09: ffff88011db4c660
R10: 6db6db6db6db6db7 R11: 00001e0000000000 R12: 0000000000e4d091
R13: ffff88011db4c660 R14: 0000000000000041 R15: ffff8801374b2000
FS:  00007f45c74e37d0(0000) GS:ffff88013b803f80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000a8 CR3: 000000010f14f000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 21403, threadinfo ffff88011dac4000, task ffff8800687f3280)
Stack:
 ffff88013a5d4000 00000010a0310695 00002d790000540d ffff88013a5d4000
 0000000000e4d091 ffff88011db4c660 0000000000000041 ffff8801374b2000
 ffff88011dac5cf8 ffffffffa0310824 ffff88011dac5cf8 ffffffffa031024b
Call Trace:
 [<ffffffffa0310824>] i915_add_request+0x1c4/0x210 [i915]
 [<ffffffffa031024b>] ? i915_gem_flush+0x11b/0x150 [i915]
 [<ffffffffa0313e71>] i915_gem_execbuffer+0xe31/0xe70 [i915]
 [<ffffffffa02dd7e6>] drm_ioctl+0x106/0x360 [drm]
 [<ffffffffa0313040>] ? i915_gem_execbuffer+0x0/0xe70 [i915]
 [<ffffffff802dafdc>] vfs_ioctl+0x7c/0xa0
 [<ffffffff80238ad2>] ? finish_task_switch+0x32/0xe0
 [<ffffffff802db69b>] do_vfs_ioctl+0x33b/0x5d0
 [<ffffffff8052a215>] ? thread_return+0x3d/0x698
 [<ffffffff802db9b1>] sys_ioctl+0x81/0xa0
 [<ffffffff8020c88b>] system_call_fastpath+0x16/0x1b
Code: e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 0f 1f 44 00 00 89 75
cc 48 8b 87 70 03 00 00 48 8b 9f 20 03 00 00 48 8b 80 58 02 00 00 <
48> 8b 80 a8 00 00 00 48 89 45 c0 8b 87 0c 03 00 00 3d 82 29 00
RIP  [<ffffffffa030b96e>] i915_wait_ring+0x2e/0x1a0 [i915]
 RSP <ffff88011dac5c68>
CR2: 00000000000000a8


---


WARNING: at drivers/gpu/drm/i915/i915_gem.c:3115
i915_gem_idle+0x304/0x310 [i915]()
Hardware name: 6464CTO
Modules linked in: oprofile tun sysprof_module fuse ipt_MASQUERADE
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_connt
rack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp
llc rfcomm sco l2cap autofs4 sunrpc ipv6 binfmt_misc loop dm_mirror
dm_region_hash dm_log dm_mod kvm_intel kvm i91
5 drm i2c_algo_bit uinput arc4 snd_hda_codec_analog ecb cryptomgr aead
crypto_blkcipher crypto_hash snd_hda_intel btusb snd_hda_codec
snd_seq_oss snd_seq_midi_event snd_seq rtc_cmos blu
etooth rtc_core snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm
sr_mod snd_timer crypto_algapi thinkpad_acpi backlight iwl3945
i2c_i801 i2c_core rfkill usbhid mac80211 lib80211 hid sdh
ci_pci sdhci mmc_core intel_agp cfg80211 cdrom e1000e snd soundcore
rtc_lib led_class psmouse evdev serio_raw iTCO_wdt button ac battery
snd_page_alloc nvram iTCO_vendor_support uhci_hc
d ohci_hcd ehci_hcd usbcore [last unloaded: microcode]
Pid: 20056, comm: X Not tainted 2.6.29 #48
Call Trace:
 [<ffffffff802424df>] warn_slowpath+0xaf/0xf0
 [<ffffffff8024df4c>] ? try_to_del_timer_sync+0x5c/0x70
 [<ffffffffa0310da8>] ? i915_gem_retire_requests+0x128/0x180 [i915]
 [<ffffffffa0310da8>] ? i915_gem_retire_requests+0x128/0x180 [i915]
 [<ffffffffa0312294>] i915_gem_idle+0x304/0x310 [i915]
 [<ffffffffa0312321>] i915_gem_leavevt_ioctl+0x31/0x50 [i915]
 [<ffffffffa02dd7e6>] drm_ioctl+0x106/0x360 [drm]
 [<ffffffffa03122f0>] ? i915_gem_leavevt_ioctl+0x0/0x50 [i915]
 [<ffffffff802dafdc>] vfs_ioctl+0x7c/0xa0
 [<ffffffff802db69b>] do_vfs_ioctl+0x33b/0x5d0
 [<ffffffff8052c55b>] ? trace_hardirqs_off_thunk+0x3a/0x6c
 [<ffffffff802db9b1>] sys_ioctl+0x81/0xa0
 [<ffffffff8020c88b>] system_call_fastpath+0x16/0x1b
