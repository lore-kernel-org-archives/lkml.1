Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbXBSAZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbXBSAZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXBSAZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:25:19 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:39235 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXBSAZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:25:18 -0500
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702182216060.25686@twin.jikos.cz>
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>
	 <45D5C789.1090607@student.ltu.se>
	 <8E8F647D7835334B985D069AE964A4F7028FE550@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
	 <Pine.LNX.4.64.0702182216060.25686@twin.jikos.cz>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 01:25:33 +0100
Message-Id: <1171844733.2488.33.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> > I m using a Logitech MX 5000 keyboard with an included MX 1000 mouse,
> > both bluetooth using the same USB reciever.
> > When the USB reciever is already plugged-in at boot-time and the
> > Bluetooth service fires-up I get this message:
> >  =======================
> > BUG: warning: (value > m) at
> > drivers/usb/input/hid-core.c:793/implement() (Tainted: P     )
> >  [<c0405018>] dump_trace+0x69/0x1b6
> >  [<c040517d>] show_trace_log_lvl+0x18/0x2c
> >  [<c0405778>] show_trace+0xf/0x11
> >  [<c0405875>] dump_stack+0x15/0x17
> >  [<c05993c0>] hid_output_report+0x23c/0x2e7
> >  [<c05994b7>] hid_submit_ctrl+0x4c/0x1d9
> >  [<c05997fd>] hid_submit_report+0x134/0x15f
> >  [<c059bd09>] hiddev_ioctl+0x327/0x88a
> >  [<c04802c8>] do_ioctl+0x4c/0x62
> >  [<c0480528>] vfs_ioctl+0x24a/0x25c
> >  [<c0480586>] sys_ioctl+0x4c/0x66
> >  [<c040404b>] syscall_call+0x7/0xb
> >  [<005b5402>] 0x5b5402
> >  =======================
> 
> (added Marcel to CC)
> 
> This means that something (I guess that it's hid2hci command?) is trying 
> to pass through hiddev a value in a field that is greater than a given 
> bitmask (and is not going to fit into the bitfield).
> 
> Vincent, does the problem go away when you don't use bluetooth (both 
> keyboard and mouse is switched to HID mode, if they support it)?
> 
> Marcel, do you have any idea how this could happen?

we understand the original CSR HID proxy dongles, but for the Logitech
ones, it is wild guesses. The current support in hid2hci has been tested
on Logitech diNovo first generation and I have no other Logitech
hardware to verify it with. We might simply need the full HID report
descriptor to see who is at fault.

Regards

Marcel


