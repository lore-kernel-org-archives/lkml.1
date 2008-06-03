Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYFCCT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYFCCT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYFCCTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 22:19:48 -0400
Received: from fallback.us4.outblaze.com ([205.158.62.120]:53815 "EHLO
	fallback.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbYFCCTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 22:19:47 -0400
X-OB-Received: from unknown (205.158.62.232)
  by wfilter.us4.outblaze.com; 3 Jun 2008 02:16:45 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Mike White" <argentia@operamail.com>
To: linux-kernel@vger.kernel.org
Date: Tue, 3 Jun 2008 03:16:45 +0100
Subject: Kernel GPF ACPI
X-Originating-Ip: 69.158.147.108
X-Originating-Server: ws5-11.us4.outblaze.com
Message-Id: <20080603021645.A63FDCBC9E@ws5-11.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running Opensuse 10.3 on Asus M2N32-SLI (default BIOS settings), AMD Dual core CPU.
Kernel is stock that comes with that version of suse.

Linux deathscape 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC x86_64 x86_64 x86_64 GNU/Linux

Upon booting the system, service /etc/rc.d/powersaved segfaults, specifically /usr/sbin/powersaved

Output from dmesg:


Jun  2 00:51:01 deathscape kernel: general protection fault: 0000 [1] SMP 
Jun  2 00:51:01 deathscape kernel: last sysfs file: /block/sr0/capability
Jun  2 00:51:01 deathscape kernel: CPU 1 
Jun  2 00:51:01 deathscape kernel: Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle cpufreq_conservative cpufreq_userspace nf_conntrack_ipv4 nf_conntrack cpufreq_powersave nfnetlink powernow_k8 ip_tables ip6table_filter ip6_tables x_tables ipv6 apparmor dm_crypt xfs loop dm_mod rfcomm l2cap joydev hci_usb usbhid parport_pc hid parport bluetooth ff_memless snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device ohci1394 snd_hda_intel snd_pcm snd_timer rtc_cmos rtc_core rtc_lib uvcvideo firmware_class compat_ioctl32 videodev snd_hwdep nvidia(P) snd k8temp forcedeth ieee1394 hwmon serio_raw sr_mod cdrom snd_page_alloc i2c_nforce2 v4l1_compat soundcore i2c_core v4l2_common button sg sd_mod ehci_hcd ohci_hcd usbcore edd ext3 mbcache jbd fan sata_sil24 sata_nv pata_amd libata scsi_mod thermal processor
Jun  2 00:51:01 deathscape kernel: Pid: 3327, comm: powersaved Tainted: P      N 2.6.22.5-31-default #1
Jun  2 00:51:01 deathscape kernel: RIP: 0010:[<ffffffff80333fda>]  [<ffffffff80333fda>] acpi_ns_map_handle_to_node+0x14/0x1d
Jun  2 00:51:01 deathscape kernel: RSP: 0018:ffff810111ae7e10  EFLAGS: 00010246
Jun  2 00:51:01 deathscape kernel: RAX: 0000000000000000 RBX: 0000000000001001 RCX: ffffffff804801f7
Jun  2 00:51:01 deathscape kernel: RDX: 000000000000b57b RSI: 0000000000000100 RDI: 4d52454854584e4c
Jun  2 00:51:01 deathscape kernel: RBP: 4d52454854584e4c R08: ffffffff8047fdf0 R09: ffffffff804801af
Jun  2 00:51:01 deathscape kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff810111ae7e78
Jun  2 00:51:01 deathscape kernel: R13: ffffffff8033f448 R14: ffff810111ae7e78 R15: 00002b0fae66f000
Jun  2 00:51:01 deathscape kernel: FS:  00002b0fb02ac140(0000) GS:ffff81011b962840(0000) knlGS:0000000000000000
Jun  2 00:51:01 deathscape kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jun  2 00:51:01 deathscape kernel: CR2: 00002b0fae66f000 CR3: 00000001118c4000 CR4: 00000000000006e0
Jun  2 00:51:01 deathscape kernel: Process powersaved (pid: 3327, threadinfo ffff810111ae6000, task ffff81011a738850)
Jun  2 00:51:01 deathscape kernel: Stack:  ffffffff8033321e ffff810111859c38 ffff810111ae7e78 4d52454854584e4c
Jun  2 00:51:01 deathscape kernel:  ffff81011969b8c0 ffffffff8801434d ffffffff8033e980 0000000000000003
Jun  2 00:51:01 deathscape kernel:  ffff810119a6f000 0000000000000000 ffffffff880135c5 0000000000100073
Jun  2 00:51:01 deathscape kernel: Call Trace:
Jun  2 00:51:01 deathscape kernel:  [<ffffffff8033321e>] acpi_get_data+0x3e/0x6e
Jun  2 00:51:01 deathscape kernel:  [<ffffffff8033e980>] acpi_bus_get_device+0x25/0x68
Jun  2 00:51:01 deathscape kernel:  [<ffffffff880135c5>] :thermal:acpi_thermal_trip_seq_show+0x12b/0x257
Jun  2 00:51:01 deathscape kernel:  [<ffffffff802a19c2>] seq_read+0x105/0x28b
Jun  2 00:51:01 deathscape kernel:  [<ffffffff8028943d>] vfs_read+0xcb/0x153
Jun  2 00:51:01 deathscape kernel:  [<ffffffff802897d1>] sys_read+0x45/0x6e
Jun  2 00:51:01 deathscape kernel:  [<ffffffff80209dac>] tracesys+0xdc/0xe1
Jun  2 00:51:01 deathscape kernel: 
Jun  2 00:51:01 deathscape kernel: 
Jun  2 00:51:01 deathscape kernel: Code: 80 7f 08 0f 48 0f 44 c7 c3 48 89 f8 c3 31 c0 48 85 ff 74 0d 
Jun  2 00:51:01 deathscape kernel: RIP  [<ffffffff80333fda>] acpi_ns_map_handle_to_node+0x14/0x1d
Jun  2 00:51:01 deathscape kernel:  RSP <ffff810111ae7e10>


-- 
_______________________________________________
Surf the Web in a faster, safer and easier way:
Download Opera 9 at http://www.opera.com

Powered by Outblaze
