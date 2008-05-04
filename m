Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYEDEig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYEDEig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 00:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYEDEiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 00:38:25 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48324 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYEDEiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 00:38:24 -0400
Date: Sun, 4 May 2008 10:08:08 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Guillaume Chazarain <guichaz@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
       jens.axboe@oracle.com
Subject: Re: [RFC][PATCH] sched_clock_cpu()
Message-ID: <20080504043808.GB21789@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1209832169.6929.42.camel@lappy> <20080503165511.GA21967@elte.hu> <20080503173023.GA2394@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503173023.GA2394@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:00:23PM +0530, Dhaval Giani wrote:
> On Sat, May 03, 2008 at 06:55:11PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > it _DOESN'T_ boot ;-/ [...]
> > 
> > FYI, the merged version against sched-devel.git does boot fine here and 
> > the clock does seem to advance as expected.
> > 
> 
> boots here against linus as well.
> 

Unrelated, it hits this as well,


   21.964266] ------------[ cut here ]------------
[   21.978124] WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0x114/0x158()
[   22.013319] Modules linked in:
[   22.022518] Pid: 1, comm: swapper Not tainted 2.6.25 #1
[   22.042741]  [<c012601f>] warn_on_slowpath+0x41/0x5f
[   22.057667]  [<c012e2dc>] ? run_timer_softirq+0x158/0x160
[   22.073948]  [<c017ade7>] ? cache_alloc_refill+0x17f/0x1de
[   22.090485]  [<c014119a>] ? __lock_release+0x1e/0x51
[   22.105463]  [<c0179c47>] ? check_poison_obj+0x2a/0x17b
[   22.121219]  [<c017ade7>] ? cache_alloc_refill+0x17f/0x1de
[   22.137760]  [<c0179aa4>] ? poison_obj+0x1e/0x3b
[   22.151698]  [<c0179650>] ? dbg_redzone1+0x15/0x1c
[   22.166157]  [<c017af76>] ? cache_alloc_debugcheck_after+0x130/0x150
[   22.187398]  [<c017b3c5>] ? __kmalloc+0x100/0x122
[   22.201595]  [<c023b103>] ? init_tag_map+0x64/0x8b
[   22.216055]  [<c023b103>] ? init_tag_map+0x64/0x8b
[   22.230510]  [<c023b154>] ? __blk_queue_init_tags+0x2a/0x4e
[   22.247311]  [<c023b29a>] blk_queue_init_tags+0x114/0x158
[   22.263537]  [<c032d6eb>] ahc_platform_set_tags+0x130/0x17e
[   22.280284]  [<c032d82d>] ahc_linux_device_queue_depth+0x7f/0xdf
[   22.300205]  [<c0315d41>] ? scsi_add_lun+0x1f8/0x326
[   22.316370]  [<c032cb2b>] ahc_linux_slave_configure+0x36/0x53
[   22.335450]  [<c0315e24>] scsi_add_lun+0x2db/0x326
[   22.349856]  [<c0315fe1>] scsi_probe_and_add_lun+0x172/0x204
[   22.367268]  [<c03166e0>] __scsi_scan_target+0x86/0xcc
[   22.382713]  [<c03167f9>] scsi_scan_channel+0x3f/0x5e
[   22.397898]  [<c0316890>] scsi_scan_host_selected+0x78/0xa9
[   22.414645]  [<c0316b5c>] do_scsi_scan_host+0x5a/0x63
[   22.429830]  [<c0316bb2>] scsi_scan_host+0x33/0x75
[   22.444235]  [<c032d298>] ahc_linux_register_host+0x190/0x19a
[   22.461503]  [<c0253982>] ? pci_get_slot+0x61/0x68
[   22.475961]  [<c0245a56>] ? kobject_put+0x3c/0x41
[   22.490158]  [<c02c388f>] ? put_device+0x11/0x13
[   22.504095]  [<c025377d>] ? pci_dev_put+0xf/0x12
[   22.518034]  [<c032f9d1>] ahc_linux_pci_dev_probe+0x15a/0x164
[   22.536537]  [<c025349f>] ? pci_match_device+0x8c/0x9b
[   22.552702]  [<c014119a>] ? __lock_release+0x1e/0x51
[   22.569672]  [<c025349f>] ? pci_match_device+0x8c/0x9b
[   22.584871]  [<c0412ec8>] ? _spin_unlock+0x27/0x3c
[   22.599306]  [<c02534bb>] pci_call_probe+0xd/0x10
[   22.613429]  [<c02534ef>] __pci_device_probe+0x31/0x43
[   22.628848]  [<c0253522>] pci_device_probe+0x21/0x34
[   22.643750]  [<c02c53cc>] really_probe+0x74/0xf2
[   22.657634]  [<c02c5494>] driver_probe_device+0x37/0x40
[   22.673340]  [<c02c5549>] __driver_attach+0x3d/0x5f
[   22.688007]  [<c02c47f5>] bus_for_each_dev+0x38/0x5d
[   22.702933]  [<c0245795>] ? kobject_init_and_add+0x20/0x22
[   22.723240]  [<c02c557f>] driver_attach+0x14/0x16
[   22.737433]  [<c02c550c>] ? __driver_attach+0x0/0x5f
[   22.752410]  [<c02c4dc0>] bus_add_driver+0x99/0x149
[   22.767077]  [<c02c5912>] driver_register+0x69/0x8d
[   22.781955]  [<c02536d0>] __pci_register_driver+0x40/0x61
[   22.798179]  [<c05d485e>] ? kernel_init+0x0/0x93
[   22.812119]  [<c032fac0>] ahc_linux_pci_init+0x14/0x16
[   22.827565]  [<c05ef704>] ahc_linux_init+0x58/0x5c
[   22.841982]  [<c05d4737>] do_initcalls+0x59/0x131
[   22.856142]  [<c01af795>] ? create_proc_entry+0x67/0x7b
[   22.871900]  [<c0159447>] ? register_irq_proc+0xa4/0xba
[   22.887656]  [<c01a0000>] ? bio_copy_kern_endio+0x6c/0xa1
[   22.903935]  [<c05d485e>] ? kernel_init+0x0/0x93
[   22.917872]  [<c05d482b>] do_basic_setup+0x1c/0x1e
[   22.932275]  [<c05d48b6>] kernel_init+0x58/0x93
[   22.945902]  [<c010463f>] kernel_thread_helper+0x7/0x10
[   22.961606]  =======================
[   22.973591] ---[ end trace 441bd607bde65755 ]---

-- 
regards,
Dhaval
