Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbXI1Iap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbXI1Iap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXI1Iah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:30:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194AbXI1Iaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:30:35 -0400
Date: Fri, 28 Sep 2007 01:30:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.23-rc8-mm2 NULL dereference in __mnt_is_readonly in
 ftruncate
Message-Id: <20070928013024.c7522542.akpm@linux-foundation.org>
In-Reply-To: <1190930060.7667.5.camel@localhost>
References: <1190930060.7667.5.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 15:54:20 -0600 Zan Lynx <zlynx@acm.org> wrote:

> Kernel 2.6.23-rc8-mm2 on a AMD-64, filesystems mounted are reiserfs,
> reiser4 and tmpfs.
> netconsole dmesg output and .config are included below.

reiser3 has a known problem, but it oopses in a different place and a fix
is in the works.

> Near the end of my boot sequence, there is a kernel error.  I am not
> sure exactly what user-space is doing to make this happen, but I know
> that a simple shell and some filesystem operations do not cause it.
> 
> This error also occurred in 2.6.23-rc8-mm1 but I didn't have time to
> post it and hoped it would just go away.  I never tested 2.6.23-rc7-mm*,
> and the error did not happen in rc6-mm1.
> 
> console [netcon0] enabled
> netconsole: network logging started
> eth0: no IPv6 routers present
> Unable to handle kernel NULL pointer dereference at 0000000000000053 RIP: 
>  [<ffffffff802c96c0>] __mnt_is_readonly+0x0/0x20
> PGD 0 
> Oops: 0000 [1] SMP 
> last sysfs file: /block/sr0/size
> CPU 0 
> Modules linked in: netconsole configfs sg ipv6 evdev usbhid hid usb_storage libusual psmouse serio_raw ssb video output ehci_hcd ohci_hcd usbcore snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc
> Pid: 7291, comm: smbd Not tainted 2.6.23-rc8-mm2 #1
> RIP: 0010:[<ffffffff802c96c0>]  [<ffffffff802c96c0>] __mnt_is_readonly+0x0/0x20
> RSP: 0018:ffff8100068b1b60  EFLAGS: 00010296
> RAX: ffff810007108000 RBX: ffff81000261d8c0 RCX: ffffffff8093aca0
> RDX: 0000000000000004 RSI: ffffffff8092e950 RDI: 0000000000000003
> RBP: 0000000000000003 R08: 0000000000000003 R09: ffffffff8061f7cd
> R10: 00000000b256aacb R11: 0000000000000000 R12: 00000000ffffffe2
> R13: ffff8100068b1bd8 R14: ffff8100068b1ee8 R15: ffff81000655a910
> FS:  00007f6f0930c6f0(0000) GS:ffffffff806ce000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000053 CR3: 0000000007cb2000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process smbd (pid: 7291, threadinfo ffff8100068b0000, task ffff810007108000)
> last branch before last exception/interrupt
>  from  [<ffffffff802cc37a>] mnt_want_write+0x3a/0x90
>  to  [<ffffffff802c96c0>] __mnt_is_readonly+0x0/0x20
> Stack:  ffffffff802cc37f ffff8100078cd9a0 ffff8100068b1bd8 ffff8100078cd9a0
>  ffffffff802c82bc ffff8100078cd780 0000000000000000 ffff8100078cd9a0
>  ffff8100068b1bd8 ffff8100068b1ee8 0000000000003000 0000000000000000
> Call Trace:
>  [<ffffffff802cc37f>] mnt_want_write+0x3f/0x90
>  [<ffffffff802c82bc>] file_update_time+0x2c/0xe0
>  [<ffffffff803506a8>] truncate_file_body+0x148/0x3f0
>  [<ffffffff802647a3>] __lock_acquire+0x583/0x1180
>  [<ffffffff80537f17>] _spin_unlock+0x17/0x20
>  [<ffffffff80363822>] store_black_box+0x82/0x90
>  [<ffffffff8034a845>] safe_link_add+0x75/0xd0
>  [<ffffffff803521f7>] setattr_unix_file+0x207/0x220
>  [<ffffffff80538274>] _spin_unlock_irq+0x24/0x30
>  [<ffffffff805377f1>] __down_write_nested+0xa1/0xc0
>  [<ffffffff802c8857>] notify_change+0xf7/0x2c0
>  [<ffffffff802b051e>] do_truncate+0x5e/0x80
>  [<ffffffff802b0659>] sys_ftruncate+0x119/0x130
>  [<ffffffff8020c39e>] system_call+0x7e/0x83

But you oopsed in a different place, via resier4.  I don't know if Dave
considers that part of his mandate - he could reasonably ask the reiser4
guys to help fix things up.



