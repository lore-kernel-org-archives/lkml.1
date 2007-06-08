Return-Path: <linux-kernel-owner+w=401wt.eu-S967814AbXFHI4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967814AbXFHI4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966265AbXFHI4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:56:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54395 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966257AbXFHI42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:56:28 -0400
Subject: Re: [usb-storage] 2.6.22-rc4-mm2 - usb-storage
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, mdharm-usb@one-eyed-alien.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0706071815270.2676-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0706071815270.2676-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 10:55:52 +0200
Message-Id: <1181292952.7348.276.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 18:20 -0400, Alan Stern wrote:
> On Thu, 7 Jun 2007, Peter Zijlstra wrote:
> 
> > My kernel went chatty when I tried to access my usb-stick; which it
> > didn't seem to find.
> 
> > WARNING: at /usr/src/linux-2.6/drivers/usb/core/urb.c:293
> > usb_submit_urb()
> > 
> > Call Trace:
> >  [<ffffffff8020d4c7>] show_trace+0x34/0x4f
> >  [<ffffffff8020d4f4>] dump_stack+0x12/0x17
> >  [<ffffffff803cac6a>] usb_submit_urb+0x9f/0x226
> >  [<ffffffff803cc4c7>] usb_sg_wait+0x56/0x132
> >  [<ffffffff8820519d>] :usb_storage:usb_stor_bulk_transfer_sg+0x9d/0xf3
> >  [<ffffffff88205313>] :usb_storage:usb_stor_Bulk_transport+0x120/0x244
> >  [<ffffffff8820577f>] :usb_storage:usb_stor_invoke_transport+0x25/0x2d2
> >  [<ffffffff882066c0>] :usb_storage:usb_stor_control_thread+0x14b/0x1e7
> >  [<ffffffff8024a7df>] kthread+0x47/0x74
> >  [<ffffffff8020cc28>] child_rip+0xa/0x12
> 
> This is false-alarm output from something intended to track down a 
> reported bug.  The patch responsible is this one: 

Right, well then I have another problem. Because it doesn't find my
usb-stick.

I noticed from D states (quite easy to reproduce, just modprobe
usb-storage):

scsi_eh_6     D ffff8100079ed640     0  3568      2 (L-TLB)
 ffff81000ac45e10 0000000000000046 0000000000000000 0000000180252936
 0000000000000002 0000000100000000 ffff81000ac42700 ffff8100043ca240
 ffff81000ac42978 ffffffff8024fc8d 00000000000000ff ffff81000ac42700
Call Trace:
 [<ffffffff804775a9>] wait_for_completion+0x82/0xc1
 [<ffffffff88201673>] :usb_storage:command_abort+0x7c/0x86
 [<ffffffff8805f54f>] :scsi_mod:scsi_error_handler+0x28e/0x4cc
 [<ffffffff8024a7ff>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12

usb-storage   D ffff8100079ed640     0  3570      2 (L-TLB)
 ffff81000ac4dd30 0000000000000046 0000000000000000 0000000100000046
 0000000000000002 0000000100000000 ffff81000ac4a780 ffff8100043ca240
 ffff81000ac4a9f8 ffffffff802518f5 00000000000000ff ffff81000ac4a780
Call Trace:
 [<ffffffff804775a9>] wait_for_completion+0x82/0xc1
 [<ffffffff803cc896>] usb_sg_wait+0x115/0x132
 [<ffffffff8820219d>] :usb_storage:usb_stor_bulk_transfer_sg+0x9d/0xf3
 [<ffffffff88202313>] :usb_storage:usb_stor_Bulk_transport+0x120/0x244
 [<ffffffff8820277f>] :usb_storage:usb_stor_invoke_transport+0x25/0x2d2
 [<ffffffff882036c0>] :usb_storage:usb_stor_control_thread+0x14b/0x1e7
 [<ffffffff8024a7ff>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12

scsi_eh_7     D ffff8100079ed640     0  3574      2 (L-TLB)
 ffff81000ac39e10 0000000000000046 0000000000000000 0000000100000046
 0000000000000002 0000000100000000 ffff81000ac16640 ffff8100043ca240
 ffff81000ac168b8 ffffffff8024fc8d 00000000000000ff ffff81000ac16640
Call Trace:
 [<ffffffff804775a9>] wait_for_completion+0x82/0xc1
 [<ffffffff88201673>] :usb_storage:command_abort+0x7c/0x86
 [<ffffffff8805f54f>] :scsi_mod:scsi_error_handler+0x28e/0x4cc
 [<ffffffff8024a7ff>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12

usb-storage   D ffff81000773f140     0  3575      2 (L-TLB)
 ffff81000ac5fd30 0000000000000046 0000000000000000 0000000000000001
 ffffffff8020c310 0000000100000001 ffff81000ac5c880 ffff8100043ca240
 ffff81000ac5caf8 ffff81000ac2f8e8 00000000000000ff ffffffff80840f30
Call Trace:
 [<ffffffff804775a9>] wait_for_completion+0x82/0xc1
 [<ffffffff803cc896>] usb_sg_wait+0x115/0x132
 [<ffffffff8820219d>] :usb_storage:usb_stor_bulk_transfer_sg+0x9d/0xf3
 [<ffffffff88202313>] :usb_storage:usb_stor_Bulk_transport+0x120/0x244
 [<ffffffff8820277f>] :usb_storage:usb_stor_invoke_transport+0x25/0x2d2
 [<ffffffff882036c0>] :usb_storage:usb_stor_control_thread+0x14b/0x1e7
 [<ffffffff8024a7ff>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12

scsi_scan_6   D ffff8100079ed640     0  3579      2 (L-TLB)
 ffff81000ac4fa90 0000000000000046 0000000000000000 000000010ac46740
 0000000000000002 0000000100000000 ffff81000ac46740 ffff8100043ca240
 ffff81000ac469b8 ffffffff802518f5 00000000000000ff ffff81000ac46740
Call Trace:
 [<ffffffff804775a9>] wait_for_completion+0x82/0xc1
 [<ffffffff803439e6>] blk_execute_rq+0xb3/0xd3
 [<ffffffff88061074>] :scsi_mod:scsi_execute+0xca/0xe6
 [<ffffffff88061149>] :scsi_mod:scsi_execute_req+0xb9/0xde
 [<ffffffff880622d2>] :scsi_mod:scsi_probe_and_add_lun+0x241/0xa8b
 [<ffffffff880630f3>] :scsi_mod:__scsi_scan_target+0xb5/0x5df
 [<ffffffff88063662>] :scsi_mod:scsi_scan_channel+0x45/0x70
 [<ffffffff8806375c>] :scsi_mod:scsi_scan_host_selected+0xcf/0x10a
 [<ffffffff88063979>] :scsi_mod:do_scan_async+0x16/0x12c
 [<ffffffff8024a7ff>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12

scsi_scan_7   D ffff81000773f140     0  3580      2 (L-TLB)
 ffff81000ac53a90 0000000000000046 0000000000000000 000000010ac507c0
 0000000000000002 0000000100000000 ffff81000ac507c0 ffff8100043ca240
 ffff81000ac50a38 ffffffff802518f5 00000000000000ff ffff81000ac507c0
Call Trace:
 [<ffffffff804775a9>] wait_for_completion+0x82/0xc1
 [<ffffffff803439e6>] blk_execute_rq+0xb3/0xd3
 [<ffffffff88061074>] :scsi_mod:scsi_execute+0xca/0xe6
 [<ffffffff88061149>] :scsi_mod:scsi_execute_req+0xb9/0xde
 [<ffffffff880622d2>] :scsi_mod:scsi_probe_and_add_lun+0x241/0xa8b
 [<ffffffff880630f3>] :scsi_mod:__scsi_scan_target+0xb5/0x5df
 [<ffffffff88063662>] :scsi_mod:scsi_scan_channel+0x45/0x70
 [<ffffffff8806375c>] :scsi_mod:scsi_scan_host_selected+0xcf/0x10a
 [<ffffffff88063979>] :scsi_mod:do_scan_async+0x16/0x12c
 [<ffffffff8024a7ff>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12

lsusb         D ffff810006ace0c0     0  4515   4472 (NOTLB)
 ffff81000ad65c58 0000000000000046 ffff81000ad65ea8 00000001045e51c0
 ffff81000d01cb48 000000018024fbf1 ffff81000d01c380 ffff81000685a200
 ffff81000d01c5f8 ffff81000d01c380 ffffffff8047a54b 0000000000000292
Call Trace:
 [<ffffffff80479b65>] __down+0xe8/0x100
 [<ffffffff80479768>] __down_failed+0x35/0x3a
 [<ffffffff803d1b24>] usbdev_ioctl+0x4f/0x1333
 [<ffffffff802ad2bd>] do_ioctl+0x9d/0xb6
 [<ffffffff802ad523>] vfs_ioctl+0x24d/0x266
 [<ffffffff802ad595>] sys_ioctl+0x59/0x7c
 [<ffffffff8020bd6e>] system_call+0x7e/0x83
 [<0000003b834c9367>]



