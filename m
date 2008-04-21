Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbYDUJPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbYDUJPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 05:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbYDUJOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 05:14:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:14233 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbYDUJOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 05:14:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FJwJRirtosUc7vyWOzd12jhHsNAPnwaMWfP/aZciYMePJhqcMo/ozgFH0hMwc35p5VDAfdSKNje6wjeVpf0VKWG+YYldNkbHGYBdWq3W0Cu7BS5UMIs/sNEJjsUkHPvvugzCQ8N2eaKgOsOFI71CfMBjJplqgCjUxpcSCoW4VlI=
Message-ID: <c4e36d110804210214j5b6cd2e9p738b4a9c52d9aa03@mail.gmail.com>
Date: Mon, 21 Apr 2008 11:14:48 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel NULL pointer at d_free+0x18/0x80
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This oops appeared in my log - unsure how it is related to my DVB-T
tuner test before.
But I've also seen another weird resume with some similar crash.

Happens with 2.6.25 - commit 48a86f548fb74928f9a466f52527e83fecdb4575
(T61, 2GB)


BUG: unable to handle kernel NULL pointer dereference at 0000000000000110
IP: [d_free+24/128] d_free+0x18/0x80
PGD 0
Oops: 0000 [1] PREEMPT SMP
CPU 0
Modules linked in: usb_storage dvb_usb_af9015 dvb_usb_dibusb_common
dib3000mc dibx000_common dvb_usb dvb_core tun nls_iso8859_2 nls_cp852
vfat fat i915 drm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4
sunrpc binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput
kvm_intel kvm snd_hda_intel arc4 ecb snd_seq_oss crypto_blkcipher
snd_seq_midi_event snd_seq cryptomgr snd_seq_device snd_pcm_oss
crypto_algapi iwl3945 mac80211 e1000e psmouse snd_mixer_oss rtc_cmos
evdev rtc_core thinkpad_acpi video snd_pcm mmc_block sdhci mmc_core
snd_timer iTCO_wdt iTCO_vendor_support battery backlight nvram rtc_lib
i2c_i801 i2c_core ac snd soundcore snd_page_alloc intel_agp output
serio_raw cfg80211 button uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: dvb_core]
Pid: 210, comm: kswapd0 Not tainted 2.6.25 #56
RIP: 0010:[d_free+24/128]  [d_free+24/128] d_free+0x18/0x80
RSP: 0018:ffff81007ced9cf0  EFLAGS: 00010206
RAX: 00000000000000f0 RBX: ffff8100202723d8 RCX: 0000000000000132
RDX: 0000000000005e5d RSI: ffff81007ced4048 RDI: ffff8100202723d8
RBP: ffff81007ced9d00 R08: 0000000000000002 R09: d37a6f4de9bd37a7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8100202723d8
R13: ffff81007c9329d8 R14: ffff8100202723e0 R15: 0000000000000029
FS:  0000000000000000(0000) GS:ffffffff81486000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000110 CR3: 0000000001001000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kswapd0 (pid: 210, threadinfo ffff81007ced8000, task ffff81007ced4000)
Stack:  ffff8100202723d8 ffff81007b7e73d8 ffff81007ced9d20 ffffffff810cb3eb
 ffff8100202723d8 0000000000000000 ffff81007ced9d40 ffffffff810cb4d5
 ffff8100202723d8 ffff8100202723d8 ffff81007ced9d80 ffffffff810cb642
Call Trace:
 [d_kill+59/96] d_kill+0x3b/0x60
 [prune_one_dentry+197/240] prune_one_dentry+0xc5/0xf0
 [prune_dcache+322/512] prune_dcache+0x142/0x200
 [shrink_dcache_memory+65/80] shrink_dcache_memory+0x41/0x50
 [shrink_slab+274/480] shrink_slab+0x112/0x1e0
 [kswapd+1232/1552] kswapd+0x4d0/0x610
 [isolate_pages_global+0/64] ? isolate_pages_global+0x0/0x40
 [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
 [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
 [kswapd+0/1552] ? kswapd+0x0/0x610
 [kthread+73/144] kthread+0x49/0x90
 [child_rip+10/18] child_rip+0xa/0x12
 [restore_args+0/48] ? restore_args+0x0/0x30
 [kthread+0/144] ? kthread+0x0/0x90
 [child_rip+0/18] ? child_rip+0x0/0x12


Code: 95 49 81 e8 ab ff 21 00 5b 41 5c c9 c3 66 0f 1f 44 00 00 55 48
89 e5 53 48 89 fb 48 83 ec 08 48 8b 87 b8 00 00 00 48 85 c0 74 0b <48>
8b 40 20 48 85 c0 74 02 ff d0 48 83 7b 50 00 74 1e 48 8d bb
RIP  [d_free+24/128] d_free+0x18/0x80
 RSP <ffff81007ced9cf0>
CR2: 0000000000000110
---[ end trace ca143223eefdc828 ]---
