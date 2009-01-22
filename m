Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZAVJAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZAVJAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZAVJAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:00:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:62660 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZAVJAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:00:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tbR7w3MAeD1RgsOIIiUYDOECwsiwgD2ftJlHENjYVKYmeGgt7rMkop+e9TpHvup4wU
         tjTduj1BdHtOAtZjySFZ6lofq7CH80dCFEQp5FjcjxvZX2WNGKYEiE/j22X2mnCEFL8i
         jwA5f4aJcrJH67NJKe/aevmhkwv4hVbSQ2gjI=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0901181217340.9999-100000@netrider.rowland.org>
References: <20090118043119.GA6715@kroah.com>
	 <Pine.LNX.4.44L0.0901181217340.9999-100000@netrider.rowland.org>
Date: Thu, 22 Jan 2009 17:00:39 +0800
Message-ID: <a8e1da0901220100te99cf1x12049efcf32c6bc9@mail.gmail.com>
Subject: Re: WARNING: at drivers/usb/storage/transport.c:584
From: Dave Young <hidave.darkstar@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Grissiom <chaos.proton@gmail.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 1:25 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 17 Jan 2009, Greg KH wrote:
>
>> On Sun, Jan 18, 2009 at 11:58:16AM +0800, Grissiom wrote:
>> > On Fri, Jan 16, 2009 at 09:17, Grissiom <chaos.proton@gmail.com> wrote:
>> > >
>> > > In the last git version of kernel, when I copy some data to a USB disk
>> > > I got this WARNING:
>> > >
>> > > [ 6394.109641] ------------[ cut here ]------------
>> > > [ 6394.109655] WARNING: at drivers/usb/storage/transport.c:584
>> > > last_sector_hacks+0x139/0x190()
>> > > [ 6394.109662] Hardware name: Inspiron 1501
>> > > [ 6394.109670] sdb: Successful last sector success at 1993648, device
>> > > 10d6:1101:0100
>> > > [ 6394.109676] Modules linked in: fuse ricoh_mmc b43
>> > > [ 6394.109693] Pid: 6937, comm: usb-storage Not tainted
>> > > 2.6.29-rc1-g14-rfkill-nophy-ledon-00224-ga652504 #68
>> > > [ 6394.109700] Call Trace:
>> > > [ 6394.109715]  [<c012a099>] warn_slowpath+0x99/0xc0
>> > > [ 6394.109727]  [<c014e3c7>] mark_held_locks+0x67/0x80
>> > > [ 6394.109738]  [<c04dc560>] _spin_unlock_irq+0x20/0x40
>> > > [ 6394.109746]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
>> > > [ 6394.109754]  [<c04dc500>] _spin_unlock_irqrestore+0x20/0x60
>> > > [ 6394.109763]  [<c04d9101>] wait_for_common+0xf1/0x120
>> > > [ 6394.109775]  [<c0125c20>] default_wake_function+0x0/0x10
>> > > [ 6394.109783]  [<c0381e9e>] usb_stor_msg_common+0xde/0x140
>> > > [ 6394.109792]  [<c0381d69>] last_sector_hacks+0x139/0x190
>> > > [ 6394.109802]  [<c0382d95>] usb_stor_invoke_transport+0x1f5/0x2a0
>> > > [ 6394.109810]  [<c014e3c7>] mark_held_locks+0x67/0x80
>> > > [ 6394.109818]  [<c04dc560>] _spin_unlock_irq+0x20/0x40
>> > > [ 6394.109826]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
>> > > [ 6394.109834]  [<c0383474>] usb_stor_control_thread+0x154/0x1d0
>> > > [ 6394.109843]  [<c04dc1cb>] _spin_lock_irqsave+0x4b/0x60
>> > > [ 6394.109851]  [<c04dc52c>] _spin_unlock_irqrestore+0x4c/0x60
>> > > [ 6394.109860]  [<c0383320>] usb_stor_control_thread+0x0/0x1d0
>> > > [ 6394.109868]  [<c014e5d9>] trace_hardirqs_on_caller+0x149/0x1a0
>> > > [ 6394.109876]  [<c0383320>] usb_stor_control_thread+0x0/0x1d0
>> > > [ 6394.109885]  [<c013def2>] kthread+0x42/0x70
>> > > [ 6394.109893]  [<c013deb0>] kthread+0x0/0x70
>> > > [ 6394.109902]  [<c0103c03>] kernel_thread_helper+0x7/0x14
>> > > [ 6394.109909] ---[ end trace fd10fd16313bc8b9 ]---
>> > >
>> > > Since there is no change in drivers/usb/storage/transport.c in the
>> > > newest git, I think the problem is still there. Have some one any
>> > > advise? Thanks
>> > >
>> > > --
>> > > Cheers,
>> > > Grissiom
>> >
>> > The same problem still happen in rc2. Here is the new dmesg:
>> >
>> > [  746.620234] ------------[ cut here ]------------
>> > [  746.620245] WARNING: at drivers/usb/storage/transport.c:584
>> > last_sector_hacks+0x139/0x190()
>> > [  746.620252] Hardware name: Inspiron 1501
>> > [  746.620259] sdb: Successful last sector success at 15701758, device
>> > 0781:5151:0200
>> > [  746.620265] Modules linked in: fuse ricoh_mmc b43
>> > [  746.620283] Pid: 2064, comm: usb-storage Not tainted
>> > 2.6.29-rc2-g14-rfkill-nophy-ledon #69
>> > [  746.620289] Call Trace:
>> > [  746.620302]  [<c012a079>] warn_slowpath+0x99/0xc0
>> > [  746.620313]  [<c014e3a7>] mark_held_locks+0x67/0x80
>> > [  746.620325]  [<c04dcaa0>] _spin_unlock_irq+0x20/0x40
>> > [  746.620333]  [<c014e5b9>] trace_hardirqs_on_caller+0x149/0x1a0
>> > [  746.620342]  [<c04dca00>] _read_unlock+0x20/0x40
>> > [  746.620350]  [<c04d9641>] wait_for_common+0xf1/0x120
>> > [  746.620361]  [<c0125bd0>] default_wake_function+0x0/0x10
>> > [  746.620370]  [<c0381ede>] usb_stor_msg_common+0xde/0x140
>> > [  746.620379]  [<c0381da9>] last_sector_hacks+0x139/0x190
>> > [  746.620389]  [<c0382dd5>] usb_stor_invoke_transport+0x1f5/0x2a0
>> > [  746.620398]  [<c014e3a7>] mark_held_locks+0x67/0x80
>> > [  746.620406]  [<c04dcaa0>] _spin_unlock_irq+0x20/0x40
>> > [  746.620414]  [<c014e5b9>] trace_hardirqs_on_caller+0x149/0x1a0
>> > [  746.620423]  [<c03834b4>] usb_stor_control_thread+0x154/0x1d0
>> > [  746.620432]  [<c04dca6c>] _spin_unlock_irqrestore+0x4c/0x60
>> > [  746.620441]  [<c0383360>] usb_stor_control_thread+0x0/0x1d0
>> > [  746.620450]  [<c014e5b9>] trace_hardirqs_on_caller+0x149/0x1a0
>> > [  746.620458]  [<c0383360>] usb_stor_control_thread+0x0/0x1d0
>> > [  746.620468]  [<c013ded2>] kthread+0x42/0x70
>> > [  746.620475]  [<c013de90>] kthread+0x0/0x70
>> > [  746.620485]  [<c0103c03>] kernel_thread_helper+0x7/0x14
>> > [  746.620492] ---[ end trace 61eaa6579ab68377 ]---
>> >
>> > This happens exactly when the USB disk plugged in. Can someone fix this?
>
> There's nothing to fix, because nothing is wrong; the warning message
> is purely informational.  The reason for making it a warning was so
> that it would show up in the kerneloops project's records.  The warning
> itself will be removed before 2.6.29 is released.
>
> Just out of curiousity, what sort of USB disk (vendor and product) are
> your 10d6:1101 and 0781:5151 devices?

I have same problem, ids are:

  idVendor           0x08ec M-Systems Flash Disk Pioneers
  idProduct          0x0020 TravelDrive


>
> If you want to get rid of the warning in your own kernel, you can do it
> easily enough by removing the WARN() in last_sector_hacks() in
> drivers/usb/storage/transport.c.
>
>> Alan, this is for you :)
>
> In fact, Greg, it was _you_ who first suggested making this a WARN!  :-)
>
> Never mind.  I'll send in a patch to get rid of the warning in a week
> or two.  Unless people start getting really upset and demand it
> sooner...
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
dave
