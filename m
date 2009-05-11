Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZEKWNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZEKWNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbZEKWMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:12:52 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60840 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZEKWMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:12:51 -0400
Date: Mon, 11 May 2009 17:12:03 -0500
From: David Fries <david@fries.net>
To: David Griffith <dgriffi@cs.csubak.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, todd@fries.net
Subject: bad endpoint address, MOTU FastLane
Message-ID: <20090511221203.GB4300@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 11 May 2009 17:12:08 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a USB Midi device.  The device used to work, David Griffith
from a previous e-mail lists 2.6.17 works 2.6.18 doesn't.  The USB
midi driver talks to it using interrupt transfers, it doesn't need the
Isoc transfers.  usb_submit_urb returns -22 EINVAL invalid argument as
it is trying to submit an interrupt packet to what is registered as an
isoc endpoint.  The second interface has the same end point addresses
as the first.  Any suggestions on how to deal with this class of
broken hardware?

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 1.00 Cls=ff(vend.) Sub=02 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=07fd ProdID=0001 Rev= 1.01
S:  Product=FastLane
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=04 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=1ms
E:  Ad=02(O) Atr=03(Int.) MxPS=   4 Ivl=1ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   4 Ivl=1ms
E:  Ad=04(O) Atr=03(Int.) MxPS=   4 Ivl=1ms
I:* If#= 1 Alt= 0 #EPs= 4 Cls=ff(vend.) Sub=03 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=01(Isoc) MxPS=   4 Ivl=1ms
E:  Ad=02(O) Atr=01(Isoc) MxPS=   4 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   4 Ivl=1ms
E:  Ad=04(O) Atr=01(Isoc) MxPS=   4 Ivl=1ms

usb 1-2: new full speed USB device using uhci_hcd and address 2
usb 1-2: string descriptor 0 read error: -61
usb 1-2: configuration #1 chosen from 1 choice
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x85/0x99()
sysfs: cannot create duplicate filename '/class/usb_endpoint/usbdev1.2_ep81'
Modules linked in: uhci_hcd usbhid
Pid: 118, comm: khubd Not tainted 2.6.30-rc5 #1
Call Trace:
 [<ffffffff8022e2fa>] ? warn_slowpath_fmt+0xd9/0x10b
 [<ffffffff802f72ae>] ? number+0x122/0x209
 [<ffffffff802f2bf5>] ? idr_get_empty_slot+0x1bf/0x2c2
 [<ffffffff802f2de5>] ? ida_get_new_above+0xed/0x1d2
 [<ffffffff802b8102>] ? sysfs_pathname+0x35/0x3d
 [<ffffffff802b8102>] ? sysfs_pathname+0x35/0x3d
 [<ffffffff802b818f>] ? sysfs_add_one+0x85/0x99
 [<ffffffff802b8688>] ? create_dir+0x4f/0x86
 [<ffffffff802b86f4>] ? sysfs_create_dir+0x35/0x4a
 [<ffffffff802f395d>] ? kobject_get+0x12/0x17
 [<ffffffff802f3a73>] ? kobject_add_internal+0xb6/0x196
 [<ffffffff802f3d00>] ? kobject_add+0x74/0x7c
 [<ffffffff80357489>] ? dev_set_name+0x4d/0x55
 [<ffffffff802f2bf5>] ? idr_get_empty_slot+0x1bf/0x2c2
 [<ffffffff80397378>] ? usb_match_id+0x32/0x58
 [<ffffffff802f395d>] ? kobject_get+0x12/0x17
 [<ffffffff80357953>] ? get_device+0x14/0x1b
 [<ffffffff803580db>] ? device_add+0xe6/0x594
 [<ffffffff802f37da>] ? kobject_init+0x42/0x82
 [<ffffffff8039b0cd>] ? usb_create_ep_devs+0x236/0x2ca
 [<ffffffff803957e3>] ? create_intf_ep_devs+0x41/0x5a
 [<ffffffff80397048>] ? usb_set_configuration+0x52c/0x555
 [<ffffffff8039e1e3>] ? generic_probe+0x55/0x9e
 [<ffffffff8035a035>] ? driver_probe_device+0x8c/0x126
 [<ffffffff8035a13e>] ? __device_attach+0x0/0x39
 [<ffffffff80359737>] ? bus_for_each_drv+0x46/0x77
 [<ffffffff8035a1ec>] ? device_attach+0x52/0x63
 [<ffffffff80359577>] ? bus_attach_device+0x24/0x5b
 [<ffffffff80358447>] ? device_add+0x452/0x594
 [<ffffffff80396b14>] ? usb_cache_string+0x71/0x79
 [<ffffffff8039182d>] ? usb_new_device+0x60/0xbe
 [<ffffffff80392ca4>] ? hub_thread+0xad5/0x1005
 [<ffffffff8023e49b>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff803921cf>] ? hub_thread+0x0/0x1005
 [<ffffffff803921cf>] ? hub_thread+0x0/0x1005
 [<ffffffff8023e054>] ? kthread+0x4e/0x78
 [<ffffffff8020c78a>] ? child_rip+0xa/0x20
 [<ffffffff80210a78>] ? sched_clock+0x5/0x8
 [<ffffffff8023e006>] ? kthread+0x0/0x78
 [<ffffffff8020c780>] ? child_rip+0x0/0x20
---[ end trace 3c3f00ed226fbe6a ]---
kobject_add_internal failed for usbdev1.2_ep81 with -EEXIST, don't try to register things with the same name in the same directory.
Pid: 118, comm: khubd Tainted: G        W  2.6.30-rc5 #1
Call Trace:
 [<ffffffff802f3b40>] ? kobject_add_internal+0x183/0x196
 [<ffffffff802f3d00>] ? kobject_add+0x74/0x7c
 [<ffffffff80357489>] ? dev_set_name+0x4d/0x55
 [<ffffffff802f2bf5>] ? idr_get_empty_slot+0x1bf/0x2c2
 [<ffffffff80397378>] ? usb_match_id+0x32/0x58
 [<ffffffff802f395d>] ? kobject_get+0x12/0x17
 [<ffffffff80357953>] ? get_device+0x14/0x1b
 [<ffffffff803580db>] ? device_add+0xe6/0x594
 [<ffffffff802f37da>] ? kobject_init+0x42/0x82
 [<ffffffff8039b0cd>] ? usb_create_ep_devs+0x236/0x2ca
 [<ffffffff803957e3>] ? create_intf_ep_devs+0x41/0x5a
 [<ffffffff80397048>] ? usb_set_configuration+0x52c/0x555
 [<ffffffff8039e1e3>] ? generic_probe+0x55/0x9e
 [<ffffffff8035a035>] ? driver_probe_device+0x8c/0x126
 [<ffffffff8035a13e>] ? __device_attach+0x0/0x39
 [<ffffffff80359737>] ? bus_for_each_drv+0x46/0x77
 [<ffffffff8035a1ec>] ? device_attach+0x52/0x63
 [<ffffffff80359577>] ? bus_attach_device+0x24/0x5b
 [<ffffffff80358447>] ? device_add+0x452/0x594
 [<ffffffff80396b14>] ? usb_cache_string+0x71/0x79
 [<ffffffff8039182d>] ? usb_new_device+0x60/0xbe
 [<ffffffff80392ca4>] ? hub_thread+0xad5/0x1005
 [<ffffffff8023e49b>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff803921cf>] ? hub_thread+0x0/0x1005
 [<ffffffff803921cf>] ? hub_thread+0x0/0x1005
 [<ffffffff8023e054>] ? kthread+0x4e/0x78
 [<ffffffff8020c78a>] ? child_rip+0xa/0x20
 [<ffffffff80210a78>] ? sched_clock+0x5/0x8
 [<ffffffff8023e006>] ? kthread+0x0/0x78
 [<ffffffff8020c780>] ? child_rip+0x0/0x20
------------[ cut here ]------------

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
