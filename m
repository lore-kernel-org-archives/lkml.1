Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZAHEvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZAHEvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZAHEvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:51:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:55080 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZAHEvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:51:00 -0500
Subject: Re: BUG in latest GIT 2.6.28-0658-g637b180
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
In-Reply-To: <1231360637.5586.27.camel@brick>
References: <49643869.8000500@lwfinger.net>
	 <200901072115.40148.bzolnier@gmail.com>  <1231360637.5586.27.camel@brick>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 15:50:50 +1100
Message-Id: <1231390250.2142.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 12:37 -0800, Harvey Harrison wrote:
> Ben,
> 
> Ben, Is this related to the IDE 'splat' you saw yesterday?

I doubt it but heh, with IDE you never know :-) I'll dig that, it could
even by that HW gone bad ... Finishing touches on my next pull request
and then I'll look at it.

Cheers,
Ben.

> Harvey
> 
> On Wed, 2009-01-07 at 21:15 +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 07 January 2009, Larry Finger wrote:
> > > The latest GIT generates the following BUG.
> > > 
> > > 
> > > BUG: sleeping function called from invalid context at mm/slab.c:3046
> > > in_atomic(): 0, irqs_disabled(): 1, pid: 523, name: modprobe
> > > no locks held by modprobe/523.
> > > irq event stamp: 17802
> > > hardirqs last  enabled at (17801): [<ffffffff8045dd99>]
> > > _spin_unlock_irqrestore+0x44/0x4c
> > > hardirqs last disabled at (17802): [<ffffffffa00a4792>]
> > > ide_probe_port+0x6c/0x469 [ide_core]
> > > softirqs last  enabled at (17796): [<ffffffff802431f3>]
> > > __do_softirq+0x159/0x166
> > > softirqs last disabled at (17789): [<ffffffff8020d4bc>]
> > > call_softirq+0x1c/0x28
> > > Pid: 523, comm: modprobe Not tainted 2.6.28-Linus-06858-g637b180 #31
> > > Call Trace:
> > >  [<ffffffff8025dbdd>] ? print_irqtrace_events+0xd0/0xd4
> > >  [<ffffffff80236bcd>] __might_sleep+0xf9/0xfb
> > >  [<ffffffff802b5469>] kmem_cache_alloc+0x2d/0x142
> > >  [<ffffffffa00a489b>] ide_probe_port+0x175/0x469 [ide_core]
> > >  [<ffffffffa00a5750>] ide_host_register+0x2b8/0x611 [ide_core]
> > >  [<ffffffffa00a8526>] ? do_ide_setup_pci_device+0x70/0xd3 [ide_core]
> > >  [<ffffffffa00a8f1d>] ide_pci_init_one+0xcc/0xee [ide_core]
> > >  [<ffffffff8025e852>] ? trace_hardirqs_off+0xd/0xf
> > >  [<ffffffff8045dd92>] ? _spin_unlock_irqrestore+0x3d/0x4c
> > >  [<ffffffff8023e3ec>] ? release_console_sem+0x1b0/0x1e5
> > >  [<ffffffff8045aac8>] ? printk+0x41/0x49
> > >  [<ffffffffa00bf604>] amd74xx_probe+0x13e/0x145 [amd74xx]
> > >  [<ffffffffa00bf340>] ? init_chipset_amd74xx+0x0/0x160 [amd74xx]
> > >  [<ffffffffa00bf4a0>] ? init_hwif_amd74xx+0x0/0x26 [amd74xx]
> > >  [<ffffffff80345fb6>] pci_device_probe+0xc6/0x11d
> > >  [<ffffffff803b7f1d>] driver_probe_device+0xc3/0x168
> > >  [<ffffffff803b801f>] __driver_attach+0x5d/0x80
> > >  [<ffffffff803b7fc2>] ? __driver_attach+0x0/0x80
> > >  [<ffffffff803b7794>] bus_for_each_dev+0x59/0x90
> > >  [<ffffffff803b7d60>] driver_attach+0x21/0x23
> > >  [<ffffffff803b703b>] bus_add_driver+0xbf/0x20c
> > >  [<ffffffff803b822e>] driver_register+0xb0/0x130
> > >  [<ffffffff8034628d>] __pci_register_driver+0x68/0xa3
> > >  [<ffffffffa0023000>] ? amd74xx_ide_init+0x0/0x20 [amd74xx]
> > >  [<ffffffffa002301e>] amd74xx_ide_init+0x1e/0x20 [amd74xx]
> > >  [<ffffffff8020905b>] _stext+0x5b/0x135
> > >  [<ffffffff802561b0>] ? __blocking_notifier_call_chain+0x5d/0x6f
> > >  [<ffffffff8026af0c>] sys_init_module+0xb0/0x1d3
> > >  [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
> > 
> > Fix below.  Thanks again Larry!
> > 
> > [ I now always run with LOCKDEP=y but the issue was probably hidden by the
> >   ide_probe_port() IRQ masking cleanup (http://lkml.org/lkml/2009/1/6/267)
> >   so I didn't catch it before push to Linus... ]
> > 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: fix accidental LOCKDEP breakage caused by local_irq_set() removal
> > 
> > commit 54cc1428cfa619e16d75baae8cb041a2eff015f0 ("ide: remove
> > local_irq_set() macro") accidentally replaced local_save_flags()
> > by local_irq_set() in ide_probe_port() and __ide_wait_stat()
> > which resulted in LOCKDEP breakage.
> > 
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-iops.c  |    2 +-
> >  drivers/ide/ide-probe.c |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: b/drivers/ide/ide-iops.c
> > ===================================================================
> > --- a/drivers/ide/ide-iops.c
> > +++ b/drivers/ide/ide-iops.c
> > @@ -493,7 +493,7 @@ static int __ide_wait_stat(ide_drive_t *
> >  	stat = tp_ops->read_status(hwif);
> >  
> >  	if (stat & ATA_BUSY) {
> > -		local_irq_save(flags);
> > +		local_save_flags(flags);
> >  		local_irq_enable_in_hardirq();
> >  		timeout += jiffies;
> >  		while ((stat = tp_ops->read_status(hwif)) & ATA_BUSY) {
> > Index: b/drivers/ide/ide-probe.c
> > ===================================================================
> > --- a/drivers/ide/ide-probe.c
> > +++ b/drivers/ide/ide-probe.c
> > @@ -796,7 +796,7 @@ static int ide_probe_port(ide_hwif_t *hw
> >  	if (irqd)
> >  		disable_irq(hwif->irq);
> >  
> > -	local_irq_save(flags);
> > +	local_save_flags(flags);
> >  	local_irq_enable_in_hardirq();
> >  
> >  	if (ide_port_wait_ready(hwif) == -EBUSY)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

