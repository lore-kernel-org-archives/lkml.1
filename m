Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXCGQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXCGQch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXCGQch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:32:37 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:62172 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965104AbXCGQcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:32:35 -0500
Date: Wed, 07 Mar 2007 11:32:30 -0500
From: "Eric Buddington,,," 
	<eric@pool-71-123-121-36.spfdma.east.verizon.net>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4 +
 USB HD
In-reply-to: <Pine.LNX.4.44L0.0703071058480.6624-100000@iolanthe.rowland.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ebuddington@wesleyan.edu, Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070307163220.GC889@pool-71-123-121-36.spfdma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
dmesgFrom: Eric Buddington <ebuddington@verizon.net>
References: <20070306190552.GA21166@pool-71-123-121-36.spfdma.east.verizon.net>
 <Pine.LNX.4.44L0.0703071058480.6624-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:03:21AM -0500, Alan Stern wrote:
> On Tue, 6 Mar 2007, Eric Buddington wrote:
> 
> > On Tue, Mar 06, 2007 at 01:34:41PM -0500, Alan Stern wrote:
> > > The stack trace didn't include the khubd process at all.  Probably that 
> > > means it had already died.
> > 
> > No, it's still there. I ran 'echo t >/proc/sysrq-trigger' again, and
> > khubd did not show up in dmesg:
> > 
> > -bash-2.05b# echo t >/proc/sysrq-trigger
> > -bash-2.05b# dmesg | grep khub
> > -bash-2.05b# dmesg | grep SysRq
> > SysRq : Show State
> > SysRq : Show State
> > -bash-2.05b# ps ax | grep khubd
> >   163 ?        R<   633:41 [khubd]
> > -bash-2.05b# echo p >/proc/sysrq-trigger
> > -bash-2.05b# dmesg | tail -2
> >  =======================
> > SysRq : Show Regs
> > -bash-2.05b#
> > 
> > So SysRq-t doesn't show anything about khubd, and SysRq-p doesn't give
> > me anything at all. What else can I try?
> 
> I'm baffled.  khubd should have shown up as the process with ID 163.  Is 
> that process listed under a different name?

It does show up under /proc/163, for whatever that's worth.

Going through the list of processes dumped by SysRq-t, here are the
ones I didn't knowingly start myself:

aio/0
ata/0
ata_aux
ent:md1.
events/0
ib_addr
ib_cm/0
ib_mcast
iw_cm_wq
kacpid
kblockd/0
kcryptd/0
khelper
khpsbpkt
kmirrord
kmpathd/0
kprefetchd
kpsmoused
kseriod
ksnapd
ksuspend_usbd
kswapd0
kthread
ktxnmgrd:md1:
ktxnmgrd:sda1
md2_raid1
pdflush
rdma_cm
reiserfs/0
scsi_eh_0 
watchdog/0

And khubd is still showing up as a major CPU consumer.  Interestingly,
ent:sda1! is also absent from the SysRq-t listing, though present (and
using lost of CPU) according to 'top' (ps, oddly, hangs in 'D' state
after listing some processes).

-Eric
