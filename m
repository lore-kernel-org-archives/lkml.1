Return-Path: <linux-kernel-owner+w=401wt.eu-S1764777AbYFFIZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764777AbYFFIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYFFIZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:25:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55598 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbYFFIZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:25:07 -0400
X-Sasl-enc: BRFrgTEbNmXMlXTm6C2TEuoq3uKzeyvwGKuo88XpGr+c 1212740705
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <4848D7E7.60203@krogh.cc>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212651099.3047.44.camel@raven.themaw.net>  <4848D7E7.60203@krogh.cc>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 16:21:25 +0800
Message-Id: <1212740486.3035.41.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-06 at 08:23 +0200, Jesper Krogh wrote:
> Hi.
> 
> This isn't a test of the proposed patch. I just got another variatioin 
> of the problem in the log. (I've tried running the automount daemon both 
> with and without the --ghost option) that is the only change I can see. 
> Still 2.6.26-rc4..

Right.

Whether that would make a difference depends largely on your map
configuration. If you have simple indirect or direct maps then then
using the --ghost option (or just adding the "browse" option if you're
using version 5) should prevent the code that turns the dentry negative
from being executed at all. If you're using submounts in your map, or
the "hosts" map or you have multi-mount entries in the maps then that
code could still be executed.

> 
> Jun  5 16:13:15 node37 kernel: [17388710.169561] BUG: unable to handle 
> kernel NULL pointer dereference at 00000000000000b2
> Jun  5 16:13:15 node37 automount[28691]: mount(nfs): nfs: mount failure 
> hest.nzcorp.net:/z/fx1200 on /nfs/fx1200
> Jun  5 16:13:15 node37 automount[28691]: failed to mount /nfs/fx1200
> Jun  5 16:13:15 node37 kernel: [17388710.217273] IP: [graft_tree+77/288] 
> graft_tree+0x4d/0x120
> Jun  5 16:13:15 node37 kernel: [17388710.217273] PGD f9e75067 PUD 
> f681e067 PMD 0
> Jun  5 16:13:15 node37 kernel: [17388710.217273] Oops: 0000 [1] SMP
> Jun  5 16:13:15 node37 kernel: [17388710.217273] CPU 1
> Jun  5 16:13:15 node37 kernel: [17388710.217273] Modules linked in: nfs 
> lockd sunrpc autofs4 ipv6 af_packet usbhid hid uhci_hcd ehci_hcd usbkbd 
> fuse parport_pc lp parport i2c_amd756 serio_raw psmouse pcspkr container 
> i2c_core shpchp k8temp button amd_rng evdev pci_hotplug ext3 jbd mbcache 
> sg sd_mod ide_cd_mod cdrom floppy mptspi mptscsih mptbase 
> scsi_transport_spi ohci_hcd tg3 usbcore amd74xx ide_core ata_generic 
> libata scsi_mod dock thermal processor fan thermal_sys
> Jun  5 16:13:15 node37 kernel: [17388710.217273] Pid: 28693, comm: 
> mount.nfs Not tainted 2.6.26-rc4 #1
> Jun  5 16:13:15 node37 kernel: [17388710.993688] RIP: 
> 0010:[graft_tree+77/288]  [graft_tree+77/288] graft_tree+0x4d/0x120
> Jun  5 16:13:15 node37 kernel: [17388710.993688] RSP: 
> 0000:ffff8100f9c85e08  EFLAGS: 00010246
> Jun  5 16:13:15 node37 kernel: [17388710.993688] RAX: ffff8100bfbc0270 
> RBX: 00000000ffffffec RCX: 0000000000000000
> Jun  5 16:13:15 node37 kernel: [17388711.245666] RDX: ffff8100f9ec5900 
> RSI: ffff8100f9c85e68 RDI: ffff8100bae1f800
> Jun  5 16:13:15 node37 kernel: [17388711.245666] RBP: ffff8100bae1f800 
> R08: 0000000000000000 R09: 0000000000000001
> Jun  5 16:13:15 node37 kernel: [17388711.245666] R10: 0000000000000001 
> R11: ffffffff803011c0 R12: ffff8100f9c85e68
> Jun  5 16:13:15 node37 kernel: [17388711.513641] R13: 0000000000000000 
> R14: 000000000000000b R15: 000000000000000b
> Jun  5 16:13:15 node37 kernel: [17388711.513641] FS: 
> 00007fd02f2cf6e0(0000) GS:ffff8100fbb0e280(0000) knlGS:00000000557fc6b0
> Jun  5 16:13:15 node37 kernel: [17388711.701623] CS:  0010 DS: 0000 ES: 
> 0000 CR0: 000000008005003b
> Jun  5 16:13:15 node37 kernel: [17388711.701623] CR2: 00000000000000b2 
> CR3: 00000000f9f49000 CR4: 00000000000006e0
> Jun  5 16:13:15 node37 kernel: [17388711.701623] DR0: 0000000000000000 
> DR1: 0000000000000000 DR2: 0000000000000000
> Jun  5 16:13:15 node37 kernel: [17388711.701623] DR3: 0000000000000000 
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jun  5 16:13:15 node37 kernel: [17388711.701623] Process mount.nfs (pid: 
> 28693, threadinfo ffff8100f9c84000, task ffff8100f6815640)
> Jun  5 16:13:15 node37 kernel: [17388712.145575] Stack: 
> ffff8100f9c85e68 ffff8100f9c85e70 ffff8100bae1f800 ffffffff802b2622
> Jun  5 16:13:15 node37 kernel: [17388712.145575]  0000000000000006 
> 0000000000000000 ffff8100f695f000 ffff8100f695e000
> Jun  5 16:13:15 node37 kernel: [17388712.145575]  ffff8100f695d000 
> ffffffff802b49e9 000000004847f4ef 0000000000000000
> Jun  5 16:13:15 node37 kernel: [17388712.145575] Call Trace:
> Jun  5 16:13:15 node37 kernel: [17388712.145575]  [do_add_mount+162/320] 
> ? do_add_mount+0xa2/0x140
> Jun  5 16:13:15 node37 kernel: [17388712.145575]  [do_mount+505/592] ? 
> do_mount+0x1f9/0x250
> Jun  5 16:13:15 node37 kernel: [17388712.145575] 
> [copy_mount_options+269/384] ? copy_mount_options+0x10d/0x180
> Jun  5 16:13:15 node37 kernel: [17388712.145575]  [sys_mount+155/256] ? 
> sys_mount+0x9b/0x100
> Jun  5 16:13:15 node37 kernel: [17388712.145575] 
> [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x80
> Jun  5 16:13:15 node37 kernel: [17388712.145575]
> Jun  5 16:13:15 node37 kernel: [17388712.145575]
> Jun  5 16:13:15 node37 kernel: [17388712.145575] Code: f7 40 58 00 00 00 
> 80 74 15 89 d8 48 8b 6c 24 08 48 8b 1c 24 4c 8b 64 24 10 48 83 c4 18 c3 
> 48 8b 46 08 bb ec ff ff ff 48 8b 48 10 <0f> b7 81 b2 00 00 00 25 00 f0 
> 00 00 3d 00 40 00 00 48 8b 47 20
> Jun  5 16:13:15 node37 kernel: [17388712.145575] RIP 
> [graft_tree+77/288] graft_tree+0x4d/0x120
> Jun  5 16:13:15 node37 kernel: [17388712.145575]  RSP <ffff8100f9c85e08>
> Jun  5 16:13:15 node37 kernel: [17388712.145575] CR2: 00000000000000b2
> Jun  5 16:13:15 node37 kernel: [17388715.129847] ---[ end trace 
> f3c4579f529c23bf ]---
> 
> I'll apply the patch today and get some nodes booted up on it.
> 

