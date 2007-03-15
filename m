Return-Path: <linux-kernel-owner+w=401wt.eu-S1030396AbXCOPmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396AbXCOPmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030459AbXCOPmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:42:24 -0400
Received: from rosi.naasa.net ([212.8.0.13]:39236 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030396AbXCOPmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:42:23 -0400
X-Greylist: delayed 1139 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 11:42:22 EDT
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: linux-kernel@vger.kernel.org
Subject: AMD64 kernel oops
Date: Thu, 15 Mar 2007 16:23:18 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200703151623.19439.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On our file server we have the following problem (the full dmesg output is 
available at http://www-ds.e-technik.uni-dortmund.de/~jplatte/dmesg.txt ):

Unable to handle kernel paging request at 0000000000100108 RIP:
 [<ffffffff802ec036>] keyring_destroy+0x32/0x96
PGD 195d33067 PUD 193202067 PMD 0
Oops: 0002 [1] SMP
CPU 0
Modules linked in: ppdev lp nfs nfsd exportfs lockd nfs_acl sunrpc button ac 
battery ipv6 quota_v1 dm_snapshot dm_mirror dm_mod loop tsdev parport_pc 
parport floppy psmouse pcspkr serio_raw i2c_i801 i2c_core shpchp pci_hotplug 
e752x_edac edac_mc evdev sg ext3 jbd mbcache ide_cd cdrom sd_mod piix 
megaraid_mbox scsi_mod megaraid_mm generic ide_core ehci_hcd uhci_hcd tg3 
thermal processor fan
Pid: 14, comm: events/0 Not tainted 2.6.18-4-amd64 #1
RIP: 0010:[<ffffffff802ec036>]  [<ffffffff802ec036>] keyring_destroy+0x32/0x96
RSP: 0018:ffff8101f7cd7e30  EFLAGS: 00010217
RAX: 0000000000200200 RBX: ffff81009c324200 RCX: ffff81009c324278
RDX: 0000000000100100 RSI: ffffffffffffffff RDI: ffffffff804629e0
RBP: ffff81009c324208 R08: 00000000ffffffff R09: ffff8101f4a55040
R10: ffff8101f7cce830 R11: 000000000000561c R12: ffff8101f8cad8c0
R13: 0000000000000282 R14: 0000000000000000 R15: ffffffff802eb97d
FS:  0000000000000000(0000) GS:ffffffff80521000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000100108 CR3: 00000001e0027000 CR4: 00000000000006e0
Process events/0 (pid: 14, threadinfo ffff8101f7cd6000, task ffff8101f7cce830)
Stack:  ffff81009c324200 ffff81009c324208 ffff8101f8cad8c0 ffffffff802eba52
 0000000000000000 ffffffff80462920 ffffffff80462928 ffffffff8024947a
 ffffffffffffff56 ffff8101f8cad8c0 ffffffff80245e7b ffff8101f8c7dd40
Call Trace:
 [<ffffffff802eba52>] key_cleanup+0xd5/0xf2
 [<ffffffff8024947a>] run_workqueue+0x94/0xe5
 [<ffffffff80245e7b>] worker_thread+0x0/0x122
 [<ffffffff80245f6b>] worker_thread+0xf0/0x122
 [<ffffffff8027d27d>] default_wake_function+0x0/0xe
 [<ffffffff8023055a>] kthread+0xd4/0x107
 [<ffffffff80259360>] child_rip+0xa/0x12
 [<ffffffff80230486>] kthread+0x0/0x107
 [<ffffffff80259356>] child_rip+0x0/0x12


Code: 48 89 42 08 48 89 10 48 c7 41 08 00 02 20 00 48 c7 43 78 00
RIP  [<ffffffff802ec036>] keyring_destroy+0x32/0x96
 RSP <ffff8101f7cd7e30>
CR2: 0000000000100108
 <3>BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ> [<ffffffff802a3fec>] softlockup_tick+0xdb/0xed
 [<ffffffff802881df>] update_process_times+0x42/0x68
 [<ffffffff8026cbd8>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff8026d2cc>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff8025904a>] apic_timer_interrupt+0x66/0x6c
 <EOI> [<ffffffff8025c11d>] __write_lock_failed+0x9/0x20
 [<ffffffff8025e244>] __down_write_nested+0x12/0x9a
 [<ffffffff8025e915>] .text.lock.spinlock+0x11/0x8a
 [<ffffffff802ebf3a>] keyring_publish_name+0x38/0x92
 [<ffffffff802ebfa7>] keyring_instantiate+0x13/0x18
 [<ffffffff802eb1f2>] __key_instantiate_and_link+0x46/0xc5
 [<ffffffff802ec7c2>] keyring_alloc+0x46/0x5e
 [<ffffffff802ede3d>] alloc_uid_keyring+0x3d/0xa6
 [<ffffffff8025cc4e>] thread_return+0x0/0xe7
 [<ffffffff80288581>] alloc_uid+0xd7/0x17e
 [<ffffffff8028ae65>] set_user+0xf/0x97
 [<ffffffff8028c985>] sys_setresuid+0x15e/0x23b
 [<ffffffff802584d6>] system_call+0x7e/0x83

The server is a Fujitsu-Siemens RX-300 S2 with 8 GB RAM and this is the second 
kernel oops this week. We are using the current stable debian kernel (Linux 
2.6.18-4-amd64 #1 SMP Wed Feb 21 14:29:38 UTC 2007 x86_64). Currently, I 
don't know how to reproduce the oops and compiling and testing a newer kernel 
is currently not possible. Can this oops be caused by a known and already 
fixed problem in a newer kernel versions? In this case I would submit a bug 
to the Debian BTS. Otherwise what can I do to further reproduce and debug 
this oops?

regards,
Jörg
