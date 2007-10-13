Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbXJNAQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbXJNAQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 20:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbXJNAQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 20:16:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbXJNAQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 20:16:47 -0400
Date: Sat, 13 Oct 2007 14:39:01 -0400
From: Jeff Garzik <jgarzik@redhat.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.23-git3 jfs/bio bug
Message-ID: <20071013183901.GA1216@devserv.devel.redhat.com>
References: <4710FFA3.5080309@oracle.com> <1192298280.6166.21.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192298280.6166.21.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2007 at 12:58:00PM -0500, Dave Kleikamp wrote:
> On Sat, 2007-10-13 at 10:25 -0700, Randy Dunlap wrote:
> > [ 9158.155844] JFS: nTxBlock = 8192, nTxLock = 65536
> > [ 9159.199567] BUG at fs/jfs/jfs_logmgr.c:2333 assert(bp->l_flag & lbmRELEASE)
> > [ 9159.206566] ------------[ cut here ]------------
> > [ 9159.211189] kernel BUG at fs/jfs/jfs_logmgr.c:2333!
> > [ 9159.216066] invalid opcode: 0000 [1] SMP 
> > [ 9159.220108] CPU 2 
> > [ 9159.222144] Modules linked in: jfs loop
> > [ 9159.226034] Pid: 0, comm: swapper Not tainted 2.6.23-git3 #1
> > [ 9159.231688] RIP: 0010:[<ffffffff8801e39c>]  [<ffffffff8801e39c>] :jfs:lbmIODone+0x317/0x367
> > [ 9159.240063] RSP: 0018:ffff81011fcefc90  EFLAGS: 00010286
> > [ 9159.245372] RAX: 0000000000000052 RBX: ffff81011fcfe800 RCX: 0000000000000000
> > [ 9159.252499] RDX: 0000000100000000 RSI: 0000000000000082 RDI: 0000000100000000
> > [ 9159.259626] RBP: ffff81011fcefcc0 R08: ffffffff806e43b8 R09: 0000000000000086
> > [ 9159.266754] R10: 0000000000000082 R11: ffffffff8073d000 R12: 0000000000000282
> > [ 9159.273881] R13: ffff81011d451740 R14: 0000000000000000 R15: 0000000000001000
> > [ 9159.281009] FS:  0000000000000000(0000) GS:ffff81011fc75840(0000) knlGS:0000000000000000
> > [ 9159.289089] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > [ 9159.294830] CR2: 00002adf5b051180 CR3: 000000010416b000 CR4: 00000000000006e0
> > [ 9159.301959] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [ 9159.309087] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> > [ 9159.316215] Process swapper (pid: 0, threadinfo ffff81011fce8000, task ffff81011fca3820)
> > [ 9159.324293] Stack:  ffff81011fcefca0 ffff81010f51e800 0000000000000000 ffff8101061b7728
> > [ 9159.332374]  0000000000000000 0000000000001000 ffff81011fcefcd0 ffffffff802ac695
> > [ 9159.339830]  ffff81011fcefcf0 ffffffff803404a6 0000000000001000 ffff81010f51e800
> > [ 9159.347096] Call Trace:
> > [ 9159.349738]  <IRQ>  [<ffffffff802ac695>] bio_endio+0x28/0x2a
> > [ 9159.355423]  [<ffffffff803404a6>] req_bio_endio+0x79/0x93
> > [ 9159.360817]  [<ffffffff803405c1>] __end_that_request_first+0x101/0x2cb
> > [ 9159.367339]  [<ffffffff80340794>] end_that_request_chunk+0x9/0xb
> > [ 9159.373341]  [<ffffffff8043af50>] scsi_end_request+0x30/0xd5
> > [ 9159.378995]  [<ffffffff8043b1b1>] scsi_io_completion+0x15a/0x390
> > [ 9159.384998]  [<ffffffff8048b154>] sd_rw_intr+0x2d1/0x305
> > [ 9159.390307]  [<ffffffff80436078>] scsi_finish_command+0x98/0xa1
> > [ 9159.396220]  [<ffffffff8043bab1>] scsi_softirq_done+0xf1/0xfa
> > [ 9159.401963]  [<ffffffff8034323c>] blk_done_softirq+0x63/0x72
> > [ 9159.407619]  [<ffffffff8023e06f>] __do_softirq+0x57/0xc7
> > [ 9159.412927]  [<ffffffff8020c67c>] call_softirq+0x1c/0x28
> > [ 9159.418235]  [<ffffffff8020d9a4>] do_softirq+0x34/0x87
> > [ 9159.423370]  [<ffffffff8023e016>] irq_exit+0x3f/0x41
> > [ 9159.428333]  [<ffffffff8020db3b>] do_IRQ+0x144/0x169
> > [ 9159.433296]  [<ffffffff8020a7f2>] mwait_idle+0x0/0x4e
> > [ 9159.438344]  [<ffffffff8020ba01>] ret_from_intr+0x0/0xa
> > [ 9159.443566]  <EOI>  [<ffffffff8020a838>] mwait_idle+0x46/0x4e
> > [ 9159.449335]  [<ffffffff8020a0b0>] enter_idle+0x22/0x24
> > [ 9159.454470]  [<ffffffff8020a785>] cpu_idle+0x93/0xb6
> > [ 9159.459434]  [<ffffffff8021bca0>] start_secondary+0x2b7/0x2c6
> > [ 9159.465173] 
> > [ 9159.466670] 
> > [ 9159.466671] Code: 0f 0b eb fe a8 10 75 25 48 c7 c1 6e 6b 02 88 ba 1e 09 00 00 
> > [ 9159.475739] RIP  [<ffffffff8801e39c>] :jfs:lbmIODone+0x317/0x367
> > [ 9159.481775]  RSP <ffff81011fcefc90>
> > [ 9159.485552] Kernel panic - not syncing: Fatal exception
> > [ 9159.490780] Rebooting in 30 seconds..
> 
> I don't have time to test this now, but the bio_endio patches ended up
> removing some return statements that need to stay.  I think this should
> fix it.
> 
> JFS: Bio cleanup: Replace missing return statements
> 
> commit 6712ecf8f648118c3363c142196418f89a510b90 removed some "return 0;"
> statements, rather than changing them to null returns.
> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Ouch, yes indeed.

	Jeff



