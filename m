Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZD2HYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZD2HYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZD2HYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:24:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbZD2HYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:24:11 -0400
Date: Wed, 29 Apr 2009 00:22:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in try_to_del_timer_sync()
Message-Id: <20090429002204.2374a4bf.akpm@linux-foundation.org>
In-Reply-To: <20090429070344.GA3019@buzzloop.caiaq.de>
References: <20090428081416.GA22269@buzzloop.caiaq.de>
	<20090428235551.862ee0d1.akpm@linux-foundation.org>
	<20090429070344.GA3019@buzzloop.caiaq.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 09:03:44 +0200 Daniel Mack <daniel@caiaq.de> wrote:

> On Tue, Apr 28, 2009 at 11:55:51PM -0700, Andrew Morton wrote:
> > > [10982.240507] Call Trace:
> > > [10982.240510]  [<c022f0b6>] ? try_to_del_timer_sync+0x15/0x4f
> > > [10982.240516]  [<c022f515>] ? del_timer_sync+0x5c/0x6c
> > > [10982.240521]  [<f86930c6>] ? ftdi_close+0xc5/0xe9 [ftdi_sio]
> > > [10982.240540]  [<f85c0a32>] ? serial_close+0x86/0x12d [usbserial]
> > > [10982.240553]  [<c03cb413>] ? tty_release_dev+0x176/0x3fa
> > > [10982.240561]  [<c023aefb>] ? lock_hrtimer_base+0x18/0x33
> > > [10982.240568]  [<c0244ca4>] ? trace_hardirqs_off+0xb/0xd
> > > [10982.240576]  [<c051feed>] ? _spin_unlock_irqrestore+0x42/0x58
> > > [10982.240582]  [<c028e4ff>] ? vfs_ioctl+0x22/0x69
> > > [10982.240589]  [<c028e998>] ? do_vfs_ioctl+0x452/0x48b
> > > [10982.240594]  [<c03cb6a9>] ? tty_release+0x12/0x1c
> > > [10982.240598]  [<c02843ab>] ? __fput+0xca/0x175
> > > [10982.240604]  [<c028446f>] ? fput+0x19/0x1b
> > > [10982.240608]  [<c0281b1d>] ? filp_close+0x51/0x5b
> > > [10982.240612]  [<c0281b91>] ? sys_close+0x6a/0xa4
> > > [10982.240616]  [<c02029c8>] ? sysenter_do_call+0x12/0x36
> > > [10982.240623] Code: 40 f7 d0 83 e0 f2 5b c9 c3 55 31 c9 31 d2 64 a1 00 f0 73 c0 89 e5 e8 05 6f 00 00 c9 c3 55 89 e5 57 89 c7 56 53 83 ec 04 89 55 f0 <8b> 5f 14 89 de 83 e6 fe 74 22 89 f0 e8 8b 11 2f 00 8b 55 f0 89 
> > > [10982.240675] EIP: [<c022eefd>] lock_timer_base+0xe/0x3e SS:ESP 0068:ea10fe44
> > > [10982.240681] CR2: 0000000000000090
> > > [10982.240685] ---[ end trace ca8d2f0f6a72aeeb ]---
> > 
> > usb-serial went splat.
> > 
> > Do you think that this is a post-2.6.29 regression?
> 
> Yes, I think so. usb-serial is used here very often for development, and
> I never saw this particular problem.
> 

OK, thanks, I'll ask Rafael to add it to the list.
