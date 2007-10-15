Return-Path: <linux-kernel-owner+w=401wt.eu-S935002AbXJOSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002AbXJOSrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934155AbXJOSid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:38:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51189 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764220AbXJOSib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:38:31 -0400
Date: Mon, 15 Oct 2007 14:38:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: bbpetkov@yahoo.de, Greg KH <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
In-Reply-To: <a8e1da0710142257g628d3d1bq635a5deefb5fb4cc@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0710151435070.3466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Dave Young wrote:

> On 10/14/07, Borislav Petkov <bbpetkov@yahoo.de> wrote:
> > Hi,
> >
> > i get the following warning on yesterday's git tree (v2.6.23-2840-g752097c):
> >
> > Oct 14 09:07:15 zmei kernel: [   49.368030] sysfs: duplicate filename 'bInterfaceNumber' can not be created
> > Oct 14 09:07:15 zmei kernel: [   49.368086] WARNING: at fs/sysfs/dir.c:425 sysfs_add_one()
> > Oct 14 09:07:15 zmei kernel: [   49.368134]  [<c010527c>] show_trace_log_lvl+0x1a/0x2f
> > Oct 14 09:07:15 zmei kernel: [   49.368220]  [<c0105da0>] show_trace+0x12/0x14
> > Oct 14 09:07:15 zmei kernel: [   49.368300]  [<c0105db8>] dump_stack+0x16/0x18
> > Oct 14 09:07:15 zmei kernel: [   49.368379]  [<c019f2ee>] sysfs_add_one+0x57/0xbc
> > Oct 14 09:07:15 zmei kernel: [   49.368461]  [<c019edeb>] sysfs_add_file+0x49/0x71
> > Oct 14 09:07:15 zmei kernel: [   49.368541]  [<c01a05c2>] sysfs_create_group+0x86/0xe8
> > Oct 14 09:07:15 zmei kernel: [   49.368621]  [<c024f5da>] usb_create_sysfs_intf_files+0x27/0x9b
> > Oct 14 09:07:15 zmei kernel: [   49.368704]  [<c024c28b>] usb_set_configuration+0x454/0x466
> > Oct 14 09:07:15 zmei kernel: [   49.368787]  [<c0252b97>] generic_probe+0x53/0x94
> > Oct 14 09:07:15 zmei kernel: [   49.368867]  [<c024d4f7>] usb_probe_device+0x35/0x3b
> > Oct 14 09:07:15 zmei kernel: [   49.368947]  [<c022a46c>] driver_probe_device+0xcb/0x14f
> > Oct 14 09:07:15 zmei kernel: [   49.369039]  [<c022a4f8>] __device_attach+0x8/0xa
> > Oct 14 09:07:15 zmei kernel: [   49.369119]  [<c02298d5>] bus_for_each_drv+0x3b/0x63
> > Oct 14 09:07:15 zmei kernel: [   49.369199]  [<c022a589>] device_attach+0x70/0x85
> > Oct 14 09:07:15 zmei kernel: [   49.369279]  [<c022984c>] bus_attach_device+0x29/0x77
> > Oct 14 09:07:15 zmei kernel: [   49.369359]  [<c0228abc>] device_add+0x28c/0x445
> > Oct 14 09:07:15 zmei kernel: [   49.369439]  [<c0247c7a>] usb_new_device+0x44/0x82
> > Oct 14 09:07:15 zmei kernel: [   49.369519]  [<c02486ec>] hub_thread+0x666/0x9c2
> > Oct 14 09:07:15 zmei kernel: [   49.369598]  [<c01370e9>] kthread+0x3b/0x62
> > Oct 14 09:07:15 zmei kernel: [   49.369679]  [<c0104eaf>] kernel_thread_helper+0x7/0x10
> > Oct 14 09:07:15 zmei kernel: [   49.369759]  =======================
> >
> > The usb hub in question is named 4-1:1.0 and it has an extension connected to it
> > which is used to activate the 2 usb connectors at the side of the pc's monitor.
> > Correct me if i'm wrong but from what i've understood so far from reading the code,
> > i think, it adds the bInterfaceNumber-file after calling usb_create_sysfs_intf_files(intf).
> > However, the currently active usbhost interface alternate setting is the only one active
> > so the bInterfaceNumber exists already and therefore the warning, but this is
> > just a guess since i'm not that fluent in the usb internals.
> Hi,
> I have encountered the same problem which was  reported in
> http://lkml.org/lkml/2007/9/29/45
> 
> For the first one "usbcore duplicated sysfs filename" , I have submit
> a patch to fix it.
> 
> For the "bInterfaceNumber" one, I have no idea, the same problem still
> exist in the latest 23-mm1 tree.

I have tried several times to duplicate this, most recently under 
2.6.23-mm1.  But nothing goes wrong; the error messages don't appear.

You may have to do your own debugging.  Try adding printk statements to
usb_create_sysfs_intf_files() and usb_remove_sysfs_intf_files() so you
can tell when they get called.

Alan Stern

