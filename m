Return-Path: <linux-kernel-owner+w=401wt.eu-S933961AbYBOBYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961AbYBOBYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 20:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759870AbYBOBYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 20:24:01 -0500
Received: from dot.reactive-networks.net ([217.144.82.11]:3096 "EHLO
	dot.oreally.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324AbYBOBX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 20:23:59 -0500
X-Greylist: delayed 2974 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 20:23:59 EST
Date: Fri, 15 Feb 2008 00:34:19 +0000
From: linux-kernel@ckeith.clara.net
To: linux-kernel@vger.kernel.org
Subject: Oops on 2.6.24.2 "rmmod fan" && "rmmod 8250_pnp"
Message-ID: <20080215003419.GE15194@dot.oreally.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just trying out 2.6.24.2 and in unloading some modules which I don't need
managed to generate kernel oopsii. My apologies if these had been reported,
I did a search and didn't see any other reports.

rmmod fan gives:

Feb 14 19:02:22 nike kernel: [  150.012343] WARNING: at fs/proc/generic.c:736 remove_proc_entry()
Feb 14 19:02:22 nike kernel: [  150.012379] Pid: 3570, comm: rmmod Not tainted 2.6.24.2 #1
Feb 14 19:02:22 nike kernel: [  150.012465]
Feb 14 19:02:22 nike kernel: [  150.012466] Call Trace:
Feb 14 19:02:22 nike kernel: [  150.012536]  [<ffffffff802ea0db>] remove_proc_entry+0x198/0x1df
Feb 14 19:02:22 nike kernel: [  150.012587]  [<ffffffff8032a8de>] kobject_release+0x0/0xf
Feb 14 19:02:22 nike kernel: [  150.012619]  [<ffffffff8032a8eb>] kobject_release+0xd/0xf
Feb 14 19:02:22 nike kernel: [  150.012650]  [<ffffffff8032b906>] kref_put+0x5f/0x6b
Feb 14 19:02:22 nike kernel: [  150.012682]  [<ffffffff8032a844>] kobject_put+0x19/0x1b
Feb 14 19:02:22 nike kernel: [  150.012714]  [<ffffffff803988aa>] bus_put+0xd/0xf
Feb 14 19:02:22 nike kernel: [  150.012746]  [<ffffffff80398966>] bus_remove_driver+0xba/0xc3
Feb 14 19:02:22 nike kernel: [  150.012783]  [<ffffffff881e3367>] :fan:acpi_fan_exit+0x23/0x25
Feb 14 19:02:22 nike kernel: [  150.012815]  [<ffffffff80264c1d>] sys_delete_module+0x1b0/0x1e3
Feb 14 19:02:22 nike kernel: [  150.012851]  [<ffffffff8020f707>] syscall_trace_enter+0xb7/0xbb
Feb 14 19:02:22 nike kernel: [  150.012885]  [<ffffffff8020c21a>] tracesys+0xdc/0xe1
Feb 14 19:02:22 nike kernel: [  150.012920]

Also managed to get a nasty issue with rmmod 8250_pnp and agetty. I
have the machine boot up to use ttyS0 as the console. On removing 8250_pnp.ko
it threw the following oops and then promptly wrote thousands of lines of
errors, all saying:

[ 1193.307736] release_dev: ttyS0: read/write wait queue active!

Feb 14 18:53:01 nike kernel: [ 1114.912518]  at 0000000000000010 RIP:
Feb 14 18:53:01 nike kernel: [ 1114.913047] PGD 75552067 PUD 75074067 PMD 0
Feb 14 18:53:01 nike kernel: [ 1114.913653] CPU 0
Feb 14 18:53:01 nike kernel: [ 1114.913920] Modules linked in: ipv6 ipt_owner ipt_LOG xt_limit ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x
_tables binfmt_misc quota_v2 sbshc sbp2 firewire_sbp2 nvram ohci1394 8250_pnp ieee1394 firewire_ohci 8250 firewire_core serial_core crc_itu_t forcedeth sg unix dm_mod libusual sata_n
v libata sd_mod scsi_mod ext3 jbd mbcache ssb pcmcia pcmcia_core firmware_class usbcore
Feb 14 18:53:01 nike kernel: [ 1114.916274] Pid: 3320, comm: agetty Not tainted 2.6.24.2 #1
Feb 14 18:53:01 nike kernel: [ 1114.916525] RIP: 0010:[<ffffffff88240160>]  [<ffffffff88240160>] :serial_core:uart_chars_in_buffer+0xf/0x1c
Feb 14 18:53:01 nike kernel: [ 1114.917028] RSP: 0000:ffff8100754d7bf8  EFLAGS: 00010292
Feb 14 18:53:01 nike kernel: [ 1114.917279] RAX: ffff81007b1af9b0 RBX: 7fffffffffffffff RCX: 000000001d60dd26
Feb 14 18:53:01 nike kernel: [ 1114.917532] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff810075517090
Feb 14 18:53:01 nike kernel: [ 1114.917785] RBP: ffff8100754d7bf8 R08: ffff8100755173c8 R09: 00000000755173a8
Feb 14 18:53:01 nike kernel: [ 1114.918038] R10: ffffffff805a7f38 R11: 0000000000000001 R12: ffff810075517090
Feb 14 18:53:01 nike kernel: [ 1114.918298] R13: 7fffffffffffffff R14: 0000000000000000 R15: 0000000000005403
Feb 14 18:53:01 nike kernel: [ 1114.918554] FS:  00002b1ad993b6f0(0000) GS:ffffffff8057a000(0000) knlGS:0000000000000000
Feb 14 18:53:01 nike kernel: [ 1114.919031] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 14 18:53:01 nike kernel: [ 1114.919283] CR2: 0000000000000010 CR3: 0000000076568000 CR4: 00000000000006e0
Feb 14 18:53:01 nike kernel: [ 1114.919536] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 14 18:53:01 nike kernel: [ 1114.919789] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 14 18:53:01 nike kernel: [ 1114.920043] Process agetty (pid: 3320, threadinfo ffff8100754d6000, task ffff8100754d4000)
Feb 14 18:53:01 nike kernel: [ 1114.920519] Stack:  ffff8100754d7c58 ffffffff80384ff6 0000000000000000 ffff8100754d4000
Feb 14 18:53:01 nike kernel: [ 1114.921102]  ffffffff8024e355 ffff8100755173c8 ffff8100755173c8 0000000000000296
Feb 14 18:53:01 nike kernel: [ 1114.921663]  ffff8100754d7c58 ffff8100755170a8 ffff810075517090 0000000000000002
Feb 14 18:53:01 nike kernel: [ 1114.921981] Call Trace:
Feb 14 18:53:01 nike kernel: [ 1114.922486]  [<ffffffff80384ff6>] tty_wait_until_sent+0xa6/0x108
Feb 14 18:53:01 nike kernel: [ 1114.922741]  [<ffffffff8024e355>] autoremove_wake_function+0x0/0x38
Feb 14 18:53:01 nike kernel: [ 1114.922996]  [<ffffffff80385159>] set_termios+0x101/0x399
Feb 14 18:53:01 nike kernel: [ 1114.923249]  [<ffffffff8037ea9c>] tty_ldisc_try+0x40/0x47
Feb 14 18:53:01 nike kernel: [ 1114.923504]  [<ffffffff8042403b>] _spin_unlock_irqrestore+0x3f/0x47
Feb 14 18:53:01 nike kernel: [ 1114.923760]  [<ffffffff803854e8>] tty_mode_ioctl+0xf7/0x266
Feb 14 18:53:01 nike kernel: [ 1114.924014]  [<ffffffff80385867>] n_tty_ioctl+0x210/0x221
Feb 14 18:53:01 nike kernel: [ 1114.924268]  [<ffffffff803823a1>] tty_ioctl+0xc78/0xce2
Feb 14 18:53:01 nike kernel: [ 1114.924523]  [<ffffffff802d5547>] inotify_inode_queue_event+0x4f/0xe0
Feb 14 18:53:01 nike kernel: [ 1114.924779]  [<ffffffff80309ecc>] inode_has_perm+0x6b/0x7a
Feb 14 18:53:01 nike kernel: [ 1114.925034]  [<ffffffff802a53c0>] check_bytes_and_report+0x38/0xcb
Feb 14 18:53:01 nike kernel: [ 1114.925288]  [<ffffffff80309f82>] file_has_perm+0xa7/0xb6
Feb 14 18:53:01 nike kernel: [ 1114.925543]  [<ffffffff802b8d8a>] do_ioctl+0x5e/0x77
Feb 14 18:53:01 nike kernel: [ 1114.931362]  [<ffffffff802b8ff4>] vfs_ioctl+0x251/0x26e
Feb 14 18:53:01 nike kernel: [ 1114.931616]  [<ffffffff802b9068>] sys_ioctl+0x57/0x7b
Feb 14 18:53:01 nike kernel: [ 1114.931869]  [<ffffffff8020c21a>] tracesys+0xdc/0xe1
Feb 14 18:53:01 nike kernel: [ 1114.932123]
Feb 14 18:53:01 nike kernel: [ 1114.932368]
Feb 14 18:53:01 nike kernel: [ 1114.932369] Code: 8b 42 10 2b 42 14 c9 25 ff 0f 00 00 c3 48 8b 87 b0 00 00 00
Feb 14 18:53:01 nike kernel: [ 1114.934036]  RSP <ffff8100754d7bf8>
Feb 14 18:53:01 nike kernel: [ 1114.934554] ---[ end trace d01c9c9b8dd780f4 ]---

Agetty is spawned via:

S0:2345:respawn:/sbin/agetty -h -L ttyS0 115200 vt100


This kernel is 2.6.24.2 from kernel.org and configured only with
"make allmodconfig".

Colin.

-- 
 "Developers are like artists; they produce their best work if they
  have the freedom to do so" - Werner Vogels, CTO Amazon.com
