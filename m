Return-Path: <linux-kernel-owner+w=401wt.eu-S934485AbZARR0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485AbZARR0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 12:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934229AbZARRZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 12:25:54 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3236 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761044AbZARRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 12:25:52 -0500
Date: Sun, 18 Jan 2009 12:25:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Grissiom <chaos.proton@gmail.com>, Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/storage/transport.c:584
In-Reply-To: <20090118043119.GA6715@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0901181217340.9999-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2009, Greg KH wrote:

> On Sun, Jan 18, 2009 at 11:58:16AM +0800, Grissiom wrote:
> > On Fri, Jan 16, 2009 at 09:17, Grissiom <chaos.proton@gmail.com> wrote:
> > >
> > > In the last git version of kernel, when I copy some data to a USB disk
> > > I got this WARNING:
> > >
> > > [ 6394.109641] ------------[ cut here ]------------
> > > [ 6394.109655] WARNING: at drivers/usb/storage/transport.c:584
> > > last_sector_hacks+0x139/0x190()
> > > [ 6394.109662] Hardware name: Inspiron 1501
> > > [ 6394.109670] sdb: Successful last sector success at 1993648, device
> > > 10d6:1101:0100
> > > [ 6394.109676] Modules linked in: fuse ricoh_mmc b43
> > > [ 6394.109693] Pid: 6937, comm: usb-storage Not tainted
> > > 2.6.29-rc1-g14-rfkill-nophy-ledon-00224-ga652504 #68
> > > [ 6394.109700] Call Trace:
> > > [ 6394.109715]  [<c012a099>] warn_slowpath+0x99/0xc0
> > > [ 6394.109727]  [<c014e3c7>] mark_held_locks+0x67/0x80
> > > [ 6394.109738]  [<c04dc560>] _spin_unlock_irq+0x20/0x40
> > > [ 6394.109746]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
> > > [ 6394.109754]  [<c04dc500>] _spin_unlock_irqrestore+0x20/0x60
> > > [ 6394.109763]  [<c04d9101>] wait_for_common+0xf1/0x120
> > > [ 6394.109775]  [<c0125c20>] default_wake_function+0x0/0x10
> > > [ 6394.109783]  [<c0381e9e>] usb_stor_msg_common+0xde/0x140
> > > [ 6394.109792]  [<c0381d69>] last_sector_hacks+0x139/0x190
> > > [ 6394.109802]  [<c0382d95>] usb_stor_invoke_transport+0x1f5/0x2a0
> > > [ 6394.109810]  [<c014e3c7>] mark_held_locks+0x67/0x80
> > > [ 6394.109818]  [<c04dc560>] _spin_unlock_irq+0x20/0x40
> > > [ 6394.109826]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
> > > [ 6394.109834]  [<c0383474>] usb_stor_control_thread+0x154/0x1d0
> > > [ 6394.109843]  [<c04dc1cb>] _spin_lock_irqsave+0x4b/0x60
> > > [ 6394.109851]  [<c04dc52c>] _spin_unlock_irqrestore+0x4c/0x60
> > > [ 6394.109860]  [<c0383320>] usb_stor_control_thread+0x0/0x1d0
> > > [ 6394.109868]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
> > > [ 6394.109876]  [<c0383320>] usb_stor_control_thread+0x0/0x1d0
> > > [ 6394.109885]  [<c013def2>] kthread+0x42/0x70
> > > [ 6394.109893]  [<c013deb0>] kthread+0x0/0x70
> > > [ 6394.109902]  [<c0103c03>] kernel_thread_helper+0x7/0x14
> > > [ 6394.109909] ---[ end trace fd10fd16313bc8b9 ]---
> > >
> > > Since there is no change in drivers/usb/storage/transport.c in the
> > > newest git, I think the problem is still there. Have some one any
> > > advise? Thanks
> > >
> > > --
> > > Cheers,
> > > Grissiom
> > 
> > The same problem still happen in rc2. Here is the new dmesg:
> > 
> > [  746.620234] ------------[ cut here ]------------
> > [  746.620245] WARNING: at drivers/usb/storage/transport.c:584
> > last_sector_hacks+0x139/0x190()
> > [  746.620252] Hardware name: Inspiron 1501
> > [  746.620259] sdb: Successful last sector success at 15701758, device
> > 0781:5151:0200
> > [  746.620265] Modules linked in: fuse ricoh_mmc b43
> > [  746.620283] Pid: 2064, comm: usb-storage Not tainted
> > 2.6.29-rc2-g14-rfkill-nophy-ledon #69
> > [  746.620289] Call Trace:
> > [  746.620302]  [<c012a079>] warn_slowpath+0x99/0xc0
> > [  746.620313]  [<c014e3a7>] mark_held_locks+0x67/0x80
> > [  746.620325]  [<c04dcaa0>] _spin_unlock_irq+0x20/0x40
> > [  746.620333]  [<c014e5b9>] trace_hardirqs_on_caller+0x149/0x1a0
> > [  746.620342]  [<c04dca00>] _read_unlock+0x20/0x40
> > [  746.620350]  [<c04d9641>] wait_for_common+0xf1/0x120
> > [  746.620361]  [<c0125bd0>] default_wake_function+0x0/0x10
> > [  746.620370]  [<c0381ede>] usb_stor_msg_common+0xde/0x140
> > [  746.620379]  [<c0381da9>] last_sector_hacks+0x139/0x190
> > [  746.620389]  [<c0382dd5>] usb_stor_invoke_transport+0x1f5/0x2a0
> > [  746.620398]  [<c014e3a7>] mark_held_locks+0x67/0x80
> > [  746.620406]  [<c04dcaa0>] _spin_unlock_irq+0x20/0x40
> > [  746.620414]  [<c014e5b9>] trace_hardirqs_on_caller+0x149/0x1a0
> > [  746.620423]  [<c03834b4>] usb_stor_control_thread+0x154/0x1d0
> > [  746.620432]  [<c04dca6c>] _spin_unlock_irqrestore+0x4c/0x60
> > [  746.620441]  [<c0383360>] usb_stor_control_thread+0x0/0x1d0
> > [  746.620450]  [<c014e5b9>] trace_hardirqs_on_caller+0x149/0x1a0
> > [  746.620458]  [<c0383360>] usb_stor_control_thread+0x0/0x1d0
> > [  746.620468]  [<c013ded2>] kthread+0x42/0x70
> > [  746.620475]  [<c013de90>] kthread+0x0/0x70
> > [  746.620485]  [<c0103c03>] kernel_thread_helper+0x7/0x14
> > [  746.620492] ---[ end trace 61eaa6579ab68377 ]---
> > 
> > This happens exactly when the USB disk plugged in. Can someone fix this?

There's nothing to fix, because nothing is wrong; the warning message
is purely informational.  The reason for making it a warning was so
that it would show up in the kerneloops project's records.  The warning
itself will be removed before 2.6.29 is released.

Just out of curiousity, what sort of USB disk (vendor and product) are 
your 10d6:1101 and 0781:5151 devices?

If you want to get rid of the warning in your own kernel, you can do it 
easily enough by removing the WARN() in last_sector_hacks() in 
drivers/usb/storage/transport.c.

> Alan, this is for you :)

In fact, Greg, it was _you_ who first suggested making this a WARN!  :-)

Never mind.  I'll send in a patch to get rid of the warning in a week 
or two.  Unless people start getting really upset and demand it 
sooner...

Alan Stern

