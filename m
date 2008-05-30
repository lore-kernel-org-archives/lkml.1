Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYE3Gyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYE3Gyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYE3Gyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:54:36 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:49264 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYE3Gyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:54:35 -0400
Date: Thu, 29 May 2008 23:54:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
Message-ID: <20080530065427.GC4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080505055940.GA4950@martell.zuzino.mipt.ru> <20080505065830.GA539@linux.vnet.ibm.com> <20080509092247.GA10927@martell.zuzino.mipt.ru> <20080509101238.GC29205@linux.vnet.ibm.com> <20080530055406.GA774@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530055406.GA774@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 09:54:06AM +0400, Alexey Dobriyan wrote:
> On Fri, May 09, 2008 at 03:12:38AM -0700, Paul E. McKenney wrote:
> > On Fri, May 09, 2008 at 01:22:47PM +0400, Alexey Dobriyan wrote:
> > > On Sun, May 04, 2008 at 11:58:30PM -0700, Paul E. McKenney wrote:
> > > > On Mon, May 05, 2008 at 09:59:40AM +0400, Alexey Dobriyan wrote:
> > > > > Workload is build all arm defconfigs and all powerpc defconfigs and
> > > > > something else in parallel from one source tree using O= and with
> > > > > empty .ccache on ext2/noatime partition.
> > > > > 
> > > > > PREEMPT_RCU was again in use to do final check of Jens's patch (see URL)
> > > > > 
> > > > > Kernel is afa26be86b65a7183ceac29bdf1f51d6fc6932f0 + CFQ fixlet
> > > > > http://marc.info/?l=linux-kernel&m=120946003120291&w=2 .
> > > > > 
> > > > > Oops, disassembly and .config (DEBUG_INFO was turned off) below.
> > > > > 
> > > > > Should we add PREEMPT_RCU to oops reports, BTW?
> > > > 
> > > > Given that you see it with PREEMPT_RCU, but not classic RCU, that would
> > > > make sense...
> > > > 
> > > > I presume that this version of the kernel has the fixes from this thread
> > > > applied?
> > > > 
> > > > 	http://lkml.org/lkml/2008/4/19/85
> > > 
> > > I recall two fixes from this thread: list.h one and text_poke() one. And
> > > they were applied before 2.6.26-rc1. Were there anything else?
> > 
> > Those are the two I am aware of.
> 
> Triggered second time with 2.6.24-rc4.
> 
> FWIW, workload was LTP in infinite loop + parallel compiling on 170 configs
> with make O=../ on ext2
> Core 2 Duo, 4G RAM, PREEMPT/PREEMPT_RCU, HZ=1000

Thank you for the info!

So you have 170 concurrent "make O=../" builds running, with them all
putting their .o files in a common directory?  Are you using 170
specific configurations, or are the all running randconfig?

							Thanx, Paul

> > > > > [12617.678557] general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
> > > > > [12617.678646] CPU 1 
> > > > > [12617.678695] Modules linked in: ext2 nf_conntrack_irc xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables usblp uhci_hcd ehci_hcd usbcore sr_mod cdrom
> > > > > [12617.678953] Pid: 15988, comm: cc1 Not tainted 2.6.26-rc1-afa26be86b65a7183ceac29bdf1f51d6fc6932f0 #3
> > > > > [12617.679064] RIP: 0010:[<ffffffff802a3cdc>]  [<ffffffff802a3cdc>] __d_lookup+0x8c/0x160
> > > > > [12617.679171] RSP: 0018:ffff810072f3fbc8  EFLAGS: 00010202
> > > > > [12617.679372] RAX: 6b6b6b6b6b6b6b6b RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000013
> > > > > [12617.679441] RDX: ffff81000100c128 RSI: 0000000000000000 RDI: ffff8101233c1140
> > > > > [12617.679511] RBP: ffff810072f3fc18 R08: 0000000000000000 R09: ffff8100695cc200
> > > > > [12617.679581] R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b2b
> > > > > [12617.679650] R13: 0000000071bf92cd R14: ffff810129d4a138 R15: ffff810072f3fcc8
> > > > > [12617.679720] FS:  00002ab45130a6f0(0000) GS:ffff81017fc44320(0000) knlGS:0000000000000000
> > > > > [12617.679827] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > > [12617.679890] CR2: 00002b3818aba000 CR3: 000000005d00d000 CR4: 0000000000000660
> > > > > [12617.679961] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > [12617.680030] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > [12617.680100] Process cc1 (pid: 15988, threadinfo ffff810072f3e000, task ffff8101233c1140)
> > > > > [12617.680206] Stack:  ffff81000100d218 0000000000000000 0000000000000007 00000007233c16e0
> > > > > [12617.680322]  ffff8100695cc200 ffff8100695cc208 ffff810072f3fcc8 ffff810072f3fe48
> > > > > [12617.680460]  ffff810072f3fcc8 ffff810072f3fcd8 ffff810072f3fc68 ffffffff802994f5
> > > > > [12617.680536] Call Trace:
> > > > > [12617.680626]  [<ffffffff802994f5>] do_lookup+0x35/0x200
> > > > > [12617.680690]  [<ffffffff8029a6e3>] __link_path_walk+0x163/0xe90
> > > > > [12617.680756]  [<ffffffff80255d85>] ? __lock_acquire+0x9c5/0x1080
> > > > > [12617.680824]  [<ffffffff8029b472>] path_walk+0x62/0xd0
> > > > > [12617.680886]  [<ffffffff8029b70d>] do_path_lookup+0x8d/0x1d0
> > > > > [12617.680950]  [<ffffffff8029c647>] __path_lookup_intent_open+0x67/0xc0
> > > > > [12617.681019]  [<ffffffff8029c72c>] path_lookup_open+0xc/0x10
> > > > > [12617.681083]  [<ffffffff8029ca48>] do_filp_open+0x98/0x8d0
> > > > > [12617.681147]  [<ffffffff80255d85>] ? __lock_acquire+0x9c5/0x1080
> > > > > [12617.681215]  [<ffffffff8028eaa3>] ? get_unused_fd_flags+0x103/0x130
> > > > > [12617.681283]  [<ffffffff8028eb28>] do_sys_open+0x58/0xb0
> > > > > [12617.681346]  [<ffffffff8028ebab>] sys_open+0x1b/0x20
> > > > > [12617.681407]  [<ffffffff8020b5fb>] system_call_after_swapgs+0x7b/0x80
> > > > > [12617.681474] 
> > > > > [12617.681519] 
> > > > > [12617.681563] Code: 4d 33 00 e8 37 18 fc ff 48 8b 03 48 89 c3 8b 45 cc 48 85 db 48 89 45 c0 75 0d eb 4c 0f 1f 00 48 8b 1b 48 85 db 74 41 4c 8d 63 c0 <48> 8b 03 45 3b 6c 24 58 0f 18 08 75 e7 4d 3b 74 24 50 75 e0 49 
> > > > > [12617.682111] RIP  [<ffffffff802a3cdc>] __d_lookup+0x8c/0x160
> > > > > [12617.682176]  RSP <ffff810072f3fbc8>
> > > > > [12617.682493] ---[ end trace 0b3e824669c14a48 ]---
> > > 
> 
