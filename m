Return-Path: <linux-kernel-owner+w=401wt.eu-S1751260AbXCYKSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbXCYKSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 06:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXCYKSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 06:18:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:47575 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXCYKSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 06:18:53 -0400
Date: Sun, 25 Mar 2007 12:18:49 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: CIJOML <cijoml@volny.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: HID OOPS running hid2hci on logitech diNovo dongle
In-Reply-To: <200703251027.41441.cijoml@volny.cz>
Message-ID: <Pine.LNX.4.64.0703251214421.29565@twin.jikos.cz>
References: <200703251027.41441.cijoml@volny.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, CIJOML wrote:

> in combination of kernel 2.6.20-mh1 and hid2hci from bluez-utils-3.9 I 
> am getting following OOPS:
> BUG: at drivers/hid/hid-core.c:785 implement()
>  [<c027a9c3>] hid_output_report+0x213/0x2be
>  [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
>  [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
>  [<fcaf7970>] usbhid_init_reports+0x60/0xbb [usbhid]
>  [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
>  [<c01b4dd1>] avc_has_perm+0x4e/0x58
>  [<c01b5595>] inode_has_perm+0x5b/0x63
>  [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
>  [<c01b5626>] file_has_perm+0x89/0x91
>  [<c0161158>] do_ioctl+0x4c/0x62
>  [<c01613aa>] vfs_ioctl+0x23c/0x24f
>  [<c0161409>] sys_ioctl+0x4c/0x67
>  [<c0102cc8>] syscall_call+0x7/0xb
>  [<c02d0033>] __sched_text_start+0x43/0x546

This is known bug that happens with recent Logitech dongles. Please see 
http://lkml.org/lkml/2007/2/16/215 and http://lkml.org/lkml/2007/3/5/274

The problem here is that Logitech probably changed the way how the dongle 
is switched from HID to HCI mode, and bluez-utils don't support it (and 
send report that is not compliant with report descriptor of the dongle, 
which triggers this warning).

Are you able to verify whether this could be possibly caused solely by 
newer versions of bluez-utils, as Amedee stated in some of the threads 
above?

-- 
Jiri Kosina
