Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZCMXvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZCMXvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 19:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZCMXvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 19:51:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845AbZCMXvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 19:51:11 -0400
Date: Fri, 13 Mar 2009 16:45:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: [stable] Li-nux 2.6.27.19  2.6.28.7
Message-Id: <20090313164509.64b45238.akpm@linux-foundation.org>
In-Reply-To: <20090313222044.GA18010@kroah.com>
References: <20090220225448.GA14122@kroah.com>
	<20090313151051.a9198384.akpm@linux-foundation.org>
	<20090313222044.GA18010@kroah.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 15:20:44 -0700 Greg KH <greg@kroah.com> wrote:

> On Fri, Mar 13, 2009 at 03:10:51PM -0700, Andrew Morton wrote:
> > 
> > I fired up this kernel up on my FC8 laptop and I see
> > http://userweb.kernel.org/~akpm/p3130212.jpg
> > 
> > On the next two boot attempts, the kernel came up OK.
> > 
> 
> That's wierd, it can't find the root filesystem?
> 
> What driver controls the disk for /dev/root?  It's not the USB
> controller, is it?  Is that normally sda?

The dmesg output is down there.

ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-7: HTS721010G9SA00, MCZIC14V, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9SA00  MCZI PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors: (100 GB/93.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors: (100 GB/93.1 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

> > Also, during boot the e1000e driver has conniptions:
> > 
> > ------------[ cut here ]------------
> > WARNING: at drivers/net/e1000e/ich8lan.c:408 e1000_acquire_swflag_ich8lan+0x51/0xf2()
> > e1000e mutex contention. Owned by pid 10
> > Modules linked in:
> > Pid: 9, comm: events/0 Not tainted 2.6.28.7 #1
> > Call Trace:
> >  [<ffffffff8103a810>] warn_slowpath+0xae/0xcd
> >  [<ffffffff8104394b>] ? lock_timer_base+0x26/0x4a
> >  [<ffffffff8104394b>] ? lock_timer_base+0x26/0x4a
> >  [<ffffffff8105d63f>] ? __lock_acquire+0x702/0x760
> >  [<ffffffff8105bfc6>] ? mark_held_locks+0x50/0x6d
> >  [<ffffffff812dd950>] ? mutex_trylock+0x104/0x118
> >  [<ffffffff8105c170>] ? trace_hardirqs_on_caller+0xf8/0x123
> >  [<ffffffff8105c1a8>] ? trace_hardirqs_on+0xd/0xf
> >  [<ffffffff811ed838>] e1000_acquire_swflag_ich8lan+0x51/0xf2
> >  [<ffffffff811f2fe9>] e1000e_read_kmrn_reg+0x1b/0x69
> >  [<ffffffff811f63c5>] ? e1000e_downshift_workaround+0x0/0x12
> >  [<ffffffff811ed1e9>] e1000e_gig_downshift_workaround_ich8lan+0x2c/0x71
> >  [<ffffffff811f63d5>] e1000e_downshift_workaround+0x10/0x12
> >  [<ffffffff8104a6ed>] run_workqueue+0xf5/0x1fd
> >  [<ffffffff8104a697>] ? run_workqueue+0x9f/0x1fd
> >  [<ffffffff8104a8f6>] ? worker_thread+0x0/0xe8
> >  [<ffffffff8104a9d1>] worker_thread+0xdb/0xe8
> >  [<ffffffff8104de14>] ? autoremove_wake_function+0x0/0x36
> >  [<ffffffff8104a8f6>] ? worker_thread+0x0/0xe8
> >  [<ffffffff8104db1a>] kthread+0x44/0x6b
> >  [<ffffffff8100cf59>] child_rip+0xa/0x11
> >  [<ffffffff8100c474>] ? restore_args+0x0/0x30
> >  [<ffffffff8104dad6>] ? kthread+0x0/0x6b
> >  [<ffffffff8100cf4f>] ? child_rip+0x0/0x11
> > ---[ end trace 09c88554f9900e8b ]---
> > 
> > Config: http://userweb.kernel.org/~akpm/config-t61p.txt
> > dmesg: http://userweb.kernel.org/~akpm/dmesg-t61p.txt
> 
> Wierd, I don't know.
> 

Also in dmesg:

0000:00:19.0: eth0: 10/100 speed: disabling TSO
0000:00:19.0: eth0: Detected Tx Unit Hang:
  TDH                  <7d>
  TDT                  <ec>
  next_to_use          <ec>
  next_to_clean        <41>
buffer_info[next_to_clean]:
  time_stamp           <fffb80d4>
  next_to_watch        <41>
  jiffies              <fffb86ed>
  next_to_watch.status <1>

