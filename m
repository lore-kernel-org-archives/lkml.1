Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZGIU5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZGIU5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbZGIU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:56:52 -0400
Received: from claw.goop.org ([74.207.240.146]:49669 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbZGIU4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:56:51 -0400
Message-ID: <4A565991.2060606@goop.org>
Date: Thu, 09 Jul 2009 13:56:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Tony Cook <tony-cook@bigpond.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.29.5: Oops when unplugging Moschip 7840/7820 USB serial device
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I unplugged a Moschip 7840/7820 USB serial adapter, and it oopsed.  I had been using it
with picoterm, but it was not open at the time I unplugged it.

Thanks,
	J

BUG: unable to handle kernel NULL pointer dereference at 00000000000000b4
IP: [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
PGD 12e19c067 PUD 12e19d067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
CPU 0 
Modules linked in: mos7840 usbserial joydev aes_x86_64 aes_generic hidp fuse ipt_MASQUERADE iptable_nat nf_nat rfcomm bridge stp llc bnep sco l2cap coretemp sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath kvm_intel kvm uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec arc4 ecb snd_hwdep thinkpad_acpi iwlagn usb_storage snd_pcm hwmon btusb e1000e pcspkr iwlcore snd_timer iTCO_wdt lib80211 iTCO_vendor_support mac80211 i2c_i801 wmi snd bluetooth cfg80211 soundcore snd_page_alloc i915 drm i2c_algo_bit i2c_core video output [last unloaded: microcode]
Pid: 27, comm: khubd Not tainted 2.6.29.5-191.fc11.x86_64 #1 74542GU
RIP: 0010:[<ffffffff81029eb5>]  [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
RSP: 0018:ffff88013a413ba0  EFLAGS: 00010046
RAX: 0000000000000100 RBX: 00000000000000b4 RCX: 000000000010000f
RDX: ffff88013a413af0 RSI: 0000000000000203 RDI: 00000000000000b4
RBP: ffff88013a413ba0 R08: ffffffff815fcf28 R09: ffff880073f51c00
R10: 0000000000000003 R11: ffff88013a438818 R12: 0000000000000203
R13: ffff880073f51c10 R14: 0000000000000002 R15: 00000000000000b4
FS:  0000000000000000(0000) GS:ffffffff817b7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000b4 CR3: 000000012e199000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 27, threadinfo ffff88013a412000, task ffff88013a40ae00)
Stack:
 ffff88013a413bb0 ffffffff81029f7f ffff88013a413bd0 ffffffff813abf94
 ffff880073f51c00 0000000000000000 ffff88013a413c10 ffffffffa0399afa
 ffff88013a413c10 ffff880073f51c00 ffff880119898800 0000000000000000
Call Trace:
 [<ffffffff81029f7f>] default_spin_lock_flags+0x9/0xe
 [<ffffffff813abf94>] _spin_lock_irqsave+0x32/0x3b
 [<ffffffffa0399afa>] mos7840_shutdown+0x93/0x120 [mos7840]
 [<ffffffffa038de76>] usb_serial_disconnect+0xe9/0x152 [usbserial]
 [<ffffffff812a3d56>] usb_unbind_interface+0x6e/0xec
 [<ffffffff8125375f>] __device_release_driver+0x68/0x89
 [<ffffffff8125386f>] device_release_driver+0x26/0x33
 [<ffffffff81252de1>] bus_remove_device+0xa4/0xb9
 [<ffffffff8125165d>] device_del+0x135/0x189
 [<ffffffff812a135c>] usb_disable_device+0x96/0x10d
 [<ffffffff8129ce29>] usb_disconnect+0xa1/0x124
 [<ffffffff8129dc12>] hub_thread+0x4e1/0xe8f
 [<ffffffff8105c8d7>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8129d731>] ? hub_thread+0x0/0xe8f
 [<ffffffff8105c541>] kthread+0x4d/0x78
 [<ffffffff8101264a>] child_rip+0xa/0x20
 [<ffffffff81011f67>] ? restore_args+0x0/0x30
 [<ffffffff8105c4f4>] ? kthread+0x0/0x78
 [<ffffffff81012640>] ? child_rip+0x0/0x20
Code: 9c 02 81 44 89 c6 48 89 c7 e8 0a fb ff ff eb 0f 0f b7 f6 40 0f b6 ff 48 89 c2 e8 1c fb ff ff c9 c3 90 55 b8 00 01 00 00 48 89 e5 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 55 48 89 e5 
RIP  [<ffffffff81029eb5>] __ticket_spin_lock+0x9/0x1a
 RSP <ffff88013a413ba0>
CR2: 00000000000000b4
---[ end trace 8b6fd3d1bbb45aa9 ]---


