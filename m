Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0BWJSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:18:25 -0500
Received: from lo.gmane.org ([80.91.229.12]:34969 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0BWJSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:18:22 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jesper Krogh <jesper@krogh.cc>
Subject: Re: 2.6.32.2 - WARNING: at lib/kref.c:43 kref_get+0x,23/0x2b()
Date: Tue, 23 Feb 2010 10:17:58 +0100
Message-ID: <4B839D46.5080300@krogh.cc>
References: <4B4F5A00.4060604@atmos.washington.edu> <20100122150325.6ad12428.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-nfs@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 2605ds1-ynoe.0.fullrate.dk
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
In-Reply-To: <20100122150325.6ad12428.akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-nfs)

I seem to get this one this morning on a 2.6.32.8 kernel. 

Feb 23 06:14:04 hest kernel: [752226.892620] ------------[ cut here ]------------
Feb 23 06:14:14 hest kernel: [752226.892638] WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
Feb 23 06:14:14 hest kernel: [752226.892641] Hardware name: Sun Fire X4600 M2
Feb 23 06:14:24 hest kernel: [752226.892642] Modules linked in: ipmi_msghandler nfsd exportfs autofs4 nfs lockd auth_rpcgss sunrpc iptable_filter ip_tables x_tables ext4 jbd2 crc16 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi parport_pc lp parport loop ipv6 ixgbe mdio psmouse serio_raw i2c_nforce2 pcspkr shpchp k8temp pci_hotplug i2c_core button processor evdev joydev ext3 jbd mbcache sr_mod usb_storage usb_libusual usbhid hid sg sd_mod ide_cd_mod cdrom ata_generic libata ehci_hcd ohci_hcd mptsas mptscsih mptbase qla2xxx scsi_transport_sas scsi_transport_fc e1000 scsi_mod amd74xx usbcore dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal fan thermal_sys fuse
Feb 23 06:14:40 hest kernel: [752226.892694] Pid: 6785, comm: nfsd Not tainted 2.6.32.8 #3
Feb 23 06:14:40 hest kernel: [752226.892697] Call Trace:
Feb 23 06:14:40 hest kernel: [752226.892702]  [<ffffffff81199d80>] ? kref_get+0x20/0x30
Feb 23 06:14:40 hest kernel: [752226.892704]  [<ffffffff81199d80>] ? kref_get+0x20/0x30
Feb 23 06:14:40 hest kernel: [752226.892710]  [<ffffffff810455e5>] ? warn_slowpath_common+0x85/0xb0
Feb 23 06:14:40 hest kernel: [752226.892712]  [<ffffffff81199d80>] ? kref_get+0x20/0x30
Feb 23 06:14:40 hest kernel: [752226.892740]  [<ffffffffa047be34>] ? svc_recv+0x2c4/0x8d0 [sunrpc]
Feb 23 06:14:40 hest kernel: [752226.892746]  [<ffffffff8103b470>] ? default_wake_function+0x0/0x10
Feb 23 06:14:40 hest kernel: [752226.892752]  [<ffffffff812eaf92>] ? __down_read+0x12/0xad
Feb 23 06:14:40 hest kernel: [752226.892767]  [<ffffffffa05457e0>] ? nfsd+0x0/0x140 [nfsd]
Feb 23 06:14:40 hest kernel: [752226.892772]  [<ffffffffa0545870>] ? nfsd+0x90/0x140 [nfsd]
Feb 23 06:14:40 hest kernel: [752226.892776]  [<ffffffff81060626>] ? kthread+0x96/0xa0
Feb 23 06:14:40 hest kernel: [752226.892780]  [<ffffffff8100cc5a>] ? child_rip+0xa/0x20
Feb 23 06:14:40 hest kernel: [752226.892785]  [<ffffffff81025230>] ? physflat_send_IPI_mask+0x0/0x10
Feb 23 06:14:40 hest kernel: [752226.892787]  [<ffffffff81060590>] ? kthread+0x0/0xa0
Feb 23 06:14:40 hest kernel: [752226.892789]  [<ffffffff8100cc50>] ? child_rip+0x0/0x20
Feb 23 06:14:40 hest kernel: [752226.892792] ---[ end trace 439f632f874b545a ]---

Prior to that I have a few messages like this in the log:
Feb 23 06:10:40 hest kernel: [752026.605489] rpc-srv/tcp: nfsd: got error -32 when sending 1048708 bytes - shutting down socket
Feb 23 06:10:40 hest kernel: [752026.605772] rpc-srv/tcp: nfsd: got error -32 when sending 1048708 bytes - shutting down socket
Feb 23 06:10:40 hest kernel: [752026.605809] rpc-srv/tcp: nfsd: got error -32 when sending 1048708 bytes - shutting down socket
Feb 23 06:10:40 hest kernel: [752026.605844] rpc-srv/tcp: nfsd: got error -32 when sending 1048708 bytes - shutting down socket
Feb 23 06:10:40 hest kernel: [752026.605932] rpc-srv/tcp: nfsd: got error -32 when sending 1048708 bytes - shutting down socket


And afterwards this pops up:

Feb 23 06:14:40 hest kernel: [752226.893163] PGD efdfaf067 PUD efdf5e067 PMD 0 
Feb 23 06:14:58 hest kernel: [752226.893163] CPU 10 
Feb 23 06:14:58 hest kernel: [752226.893163] Modules linked in: ipmi_msghandler nfsd exportfs autofs4 nfs lockd auth_rpcgss sunrpc iptable_filter ip_tables x_tables ext4 jbd2 crc16 ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi parport_pc lp parport loop ipv6 ixgbe mdio psmouse serio_raw i2c_nforce2 pcspkr shpchp k8temp pci_hotplug i2c_core button processor evdev joydev ext3 jbd mbcache sr_mod usb_storage usb_libusual usbhid hid sg sd_mod ide_cd_mod cdrom ata_generic libata ehci_hcd ohci_hcd mptsas mptscsih mptbase qla2xxx scsi_transport_sas scsi_transport_fc e1000 scsi_mod amd74xx usbcore dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal fan thermal_sys fuse
Feb 23 06:14:58 hest kernel: [752226.893163] Pid: 6785, comm: nfsd Tainted: G        W  2.6.32.8 #3 Sun Fire X4600 M2
Feb 23 06:14:58 hest kernel: [752226.893163] RIP: 0010:[<ffffffffa047af9a>]  [<ffffffffa047af9a>] svc_xprt_free+0x1a/0x60 [sunrpc]
Feb 23 06:14:58 hest kernel: [752226.893163] RSP: 0018:ffff8804fdfa1e00  EFLAGS: 00010202
Feb 23 06:14:58 hest kernel: [752226.893163] RAX: 0000000000000000 RBX: ffff881df5945800 RCX: 000000000001ffff
Feb 23 06:14:58 hest kernel: [752226.893163] RDX: 0000000000000000 RSI: ffffffffa047af80 RDI: ffff881df5945810
Feb 23 06:14:58 hest kernel: [752226.893163] RBP: ffffffffa047af80 R08: 00000000ffffffff R09: 0000000000000000
Feb 23 06:14:58 hest kernel: [752226.893163] R10: 0000000000000000 R11: 0000000000000000 R12: ffff881ff419c000
Feb 23 06:14:58 hest kernel: [752226.893163] R13: ffff881df5945800 R14: 0000000000000001 R15: 0000000000000102
Feb 23 06:14:58 hest kernel: [752226.893163] FS:  00007f018d8786e0(0000) GS:ffff88170ac00000(0000) knlGS:00000000f75aa6b0
Feb 23 06:14:58 hest kernel: [752226.893163] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Feb 23 06:14:58 hest kernel: [752226.893163] CR2: 0000000000000008 CR3: 0000000efdf11000 CR4: 00000000000006e0
Feb 23 06:14:58 hest kernel: [752226.893163] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 23 06:14:58 hest kernel: [752226.893163] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 23 06:14:58 hest kernel: [752226.893163] Process nfsd (pid: 6785, threadinfo ffff8804fdfa0000, task ffff8804fcbb54e0)
Feb 23 06:14:58 hest kernel: [752226.893163]  ffff881df5945800 ffff881df5945810 ffffffffa047af80 ffffffff81199d23
Feb 23 06:14:58 hest kernel: [752226.893163] <0> 0000000000000000 0000000000000000 00000000fffffff5 ffffffffa047be9c
Feb 23 06:14:58 hest kernel: [752226.893163] <0> 00000000000dbba0 ffff881ffdff7900 ffff881ffdcca300 00000102d8dd7018
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffffa047af80>] ? svc_xprt_free+0x0/0x60 [sunrpc]
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff81199d23>] ? kref_put+0x33/0x70
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffffa047be9c>] ? svc_recv+0x32c/0x8d0 [sunrpc]
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff8103b470>] ? default_wake_function+0x0/0x10
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff812eaf92>] ? __down_read+0x12/0xad
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffffa05457e0>] ? nfsd+0x0/0x140 [nfsd]
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffffa0545870>] ? nfsd+0x90/0x140 [nfsd]
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff81060626>] ? kthread+0x96/0xa0
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff8100cc5a>] ? child_rip+0xa/0x20
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff81025230>] ? physflat_send_IPI_mask+0x0/0x10
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff81060590>] ? kthread+0x0/0xa0
Feb 23 06:14:58 hest kernel: [752226.893163]  [<ffffffff8100cc50>] ? child_rip+0x0/0x20
Feb 23 06:14:58 hest kernel: [752226.893163]  RSP <ffff8804fdfa1e00>
Feb 23 06:14:58 hest kernel: [752230.770846] ---[ end trace 439f632f874b545b ]---

dmidecode output: http://shrek.krogh.cc/~jesper/dmidecode.txt

It is a Sun X4600 with 8 x dual-core Opterons CPU's and 128GB of memory, running as NFS server 
with a mixture of ext3 and ext4 filesystems attached. 

-- 
Jesper



