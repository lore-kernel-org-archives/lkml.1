Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbXFURFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbXFURFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbXFUREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:04:53 -0400
Received: from 3miasto.net.pl ([213.192.74.8]:57993 "EHLO 3miasto.net.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbXFUREv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:04:51 -0400
X-Greylist: delayed 791 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 13:04:51 EDT
Date: Thu, 21 Jun 2007 18:51:36 +0200 (CEST)
From: Leszek Koltunski <leszek@3miasto.net.pl>
To: linux-kernel@vger.kernel.org
Subject: 2.6.21.4:  general protection fault: 0000 [1]
Message-ID: <20070621184017.G93439@3miasto.net.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While trying to copy a file from my cell phone to a ext3 partition over 
bluetooth ( with gnome-vfs-obexftp 0.2 using bluez-utils 3.7 ) I got two
'general protection faults' in my vanilla 2.6.21.4 kernel ( tainted with 
NVidia module )

This appeared in the console:
---------------------------------------------------------
tajwan:/etc/init.d#
Message from syslogd@tajwan at Fri Jun 22 00:34:38 2007 ...
tajwan kernel: general protection fault: 0000 [1]

Message from syslogd@tajwan at Fri Jun 22 00:34:38 2007 ...
tajwan kernel: general protection fault: 0000 [1]
---------------------------------------------------------

Relevant syslog section:
---------------------------------------------------------
Jun 22 00:32:09 tajwan hcid[32544]: Device hci0 has been activated
Jun 22 00:32:09 tajwan hcid[32544]: name_listener_add(:1.15)
Jun 22 00:32:09 tajwan hcid[32544]: Default passkey agent (:1.15, /org/bluez/applet) registered
Jun 22 00:32:45 tajwan hcid[32544]: Connect in progress
Jun 22 00:32:45 tajwan hcid[32544]: link_key_request (sba=00:10:60:D1:08:4E, dba=00:11:9F:83:EC:DC)
Jun 22 00:32:45 tajwan hcid[32544]: rfcomm_connect_cb: connected
Jun 22 00:32:45 tajwan hcid[32544]: name_listener_add(:1.59)
Jun 22 00:32:45 tajwan hcid[32544]: Connect requestor :1.59 exited. Releasing /dev/rfcomm0 node
Jun 22 00:32:45 tajwan hcid[32544]: rfcomm_release(/dev/rfcomm0)
Jun 22 00:33:56 tajwan hcid[32544]: Connect in progress
Jun 22 00:33:57 tajwan hcid[32544]: link_key_request (sba=00:10:60:D1:08:4E, dba=00:11:9F:83:EC:DC)
Jun 22 00:33:57 tajwan hcid[32544]: rfcomm_connect_cb: connected
Jun 22 00:33:57 tajwan hcid[32544]: name_listener_add(:1.61)
Jun 22 00:33:57 tajwan hcid[32544]: Connect requestor :1.61 exited. Releasing /dev/rfcomm0 node
Jun 22 00:33:57 tajwan hcid[32544]: rfcomm_release(/dev/rfcomm0)
Jun 22 00:34:38 tajwan kernel: BUG: at lib/kref.c:32 kref_get()
Jun 22 00:34:38 tajwan kernel:
Jun 22 00:34:38 tajwan kernel: Call Trace:
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80134540>] kref_get+0x30/0x40
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80154312>] kobject_get+0x12/0x20
Jun 22 00:34:38 tajwan kernel:  [<ffffffff802c1697>] get_device+0x17/0x30
Jun 22 00:34:38 tajwan kernel:  [<ffffffff802c16da>] 
device_move+0x2a/0x150
Jun 22 00:34:38 tajwan kernel:  [<ffffffff88a86237>] 
:rfcomm:rfcomm_tty_close+0x37/0xa0
Jun 22 00:34:38 tajwan kernel:  [<ffffffff802a857c>] 
release_dev+0x27c/0x680
Jun 22 00:34:38 tajwan kernel:  [<ffffffff8014f05c>] tty_release+0xc/0x20
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80111dd5>] __fput+0xc5/0x1b0
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80122841>] filp_close+0x71/0x90
Jun 22 00:34:38 tajwan kernel:  [<ffffffff8011cbe2>] sys_close+0x72/0xc0
Jun 22 00:34:38 tajwan kernel:  [<ffffffff8015a81e>] system_call+0x7e/0x83
Jun 22 00:34:38 tajwan kernel:
Jun 22 00:34:38 tajwan kernel: general protection fault: 0000 [1]
Jun 22 00:34:38 tajwan kernel: CPU 0
Jun 22 00:34:38 tajwan kernel: Modules linked in: isofs rfcomm l2cap 
nvidia(P) vboxdrv ipt_owner xt_MARK iptable_filter thermal xt_tcpmss 
xt_tcpudp iptable_mangle ip_tables x_tables it87 hwmon_vid i2c_isa eeprom 
snd_emu10k1x hci_usb mousedev snd_seq_oss snd_seq_midi snd_seq_midi_event 
snd_seq snd_rawmidi snd_seq_device snd_intel8x0 snd_ac97_codec snd_pcm_oss 
snd_mixer_oss snd_pcm snd_timer ac97_bus via_rhine 8139too mii forcedeth 
snd ehci_hcd ohci_hcd psmouse i2c_nforce2 k8temp i2c_core soundcore 
snd_page_alloc
Jun 22 00:34:38 tajwan kernel: Pid: 14366, comm: gnome-vfs-daemo Tainted: 
P       2.6.21.4 #1
Jun 22 00:34:38 tajwan kernel: RIP: 0010:[<ffffffff8026a8e2>] 
[<ffffffff8026a8e2>] strlen+0x2/0x20
Jun 22 00:34:38 tajwan kernel: RSP: 0018:ffff8100535add70  EFLAGS: 
00010246
Jun 22 00:34:38 tajwan kernel: RAX: 0000000000000000 RBX: 0000000000000001 
RCX: 0000000000004000
Jun 22 00:34:38 tajwan kernel: RDX: ffff81005ffe1000 RSI: 00000000000000d0 
RDI: 2f3d454d414e5645
Jun 22 00:34:38 tajwan kernel: RBP: ffff8100467610d0 R08: 00000000000060cf 
R09: 00000000ffffffff
Jun 22 00:34:38 tajwan kernel: R10: 0000000000000000 R11: 0000000000000002 
R12: ffff8100467610d0
Jun 22 00:34:38 tajwan kernel: R13: 00000000000000d0 R14: 0000000000000000 
R15: ffff810014a99ec0
Jun 22 00:34:38 tajwan kernel: FS:  00002ba50a119f60(0000) 
GS:ffffffff804fe000(0000) knlGS:00000000f71f46d0
Jun 22 00:34:38 tajwan kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
000000008005003b
Jun 22 00:34:38 tajwan kernel: CR2: 000000000050ea28 CR3: 000000005372a000 
CR4: 00000000000006e0
Jun 22 00:34:38 tajwan kernel: Process gnome-vfs-daemo (pid: 14366, 
threadinfo ffff8100535ac000, task ffff810053626e80)
Jun 22 00:34:38 tajwan kernel: Stack:  ffffffff8015426e ffff81005ffe1030 
ffff8100467610d0 ffff81005ffe1030
Jun 22 00:34:38 tajwan kernel:  00000000ffffffea 0000000000000000 
ffffffff80269240 0000000000000000
Jun 22 00:34:38 tajwan kernel:  ffffffff80134540 ffff810046761000 
0000000000000000 ffff810036b68c38
Jun 22 00:34:38 tajwan kernel: Call Trace:
Jun 22 00:34:38 tajwan kernel:  [<ffffffff8015426e>] 
kobject_get_path+0x3e/0xd0
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80269240>] 
kobject_move+0x70/0x140
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80134540>] kref_get+0x30/0x40
Jun 22 00:34:38 tajwan kernel:  [<ffffffff802c1727>] 
device_move+0x77/0x150
Jun 22 00:34:38 tajwan kernel:  [<ffffffff88a86237>] 
:rfcomm:rfcomm_tty_close+0x37/0xa0
Jun 22 00:34:38 tajwan kernel:  [<ffffffff802a857c>] 
release_dev+0x27c/0x680
Jun 22 00:34:38 tajwan kernel:  [<ffffffff8014f05c>] tty_release+0xc/0x20
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80111dd5>] __fput+0xc5/0x1b0
Jun 22 00:34:38 tajwan kernel:  [<ffffffff80122841>] filp_close+0x71/0x90
Jun 22 00:34:38 tajwan kernel:  [<ffffffff8011cbe2>] sys_close+0x72/0xc0
Jun 22 00:34:38 tajwan kernel:  [<ffffffff8015a81e>] system_call+0x7e/0x83
Jun 22 00:34:38 tajwan kernel:
Jun 22 00:34:38 tajwan kernel:
Jun 22 00:34:38 tajwan kernel: Code: 80 3f 00 74 14 48 89 f8 66 0f 1f 44 
00 00 48 ff c0 80 38 00
Jun 22 00:34:38 tajwan kernel: RIP  [<ffffffff8026a8e2>] strlen+0x2/0x20
Jun 22 00:34:38 tajwan kernel:  RSP <ffff8100535add70>
------------------------------------------------------------------------

best,

Leszek
