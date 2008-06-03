Return-Path: <linux-kernel-owner+w=401wt.eu-S1757487AbYFCLvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbYFCLvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYFCLvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:51:24 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39832 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbYFCLvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:51:23 -0400
Date: Tue, 3 Jun 2008 13:51:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 pm-suspend/17334
In-Reply-To: <c4e36d110806030142j379f5a63xfba7c3bbb9df602a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0806031350330.1716@twin.jikos.cz>
References: <c4e36d110806030142j379f5a63xfba7c3bbb9df602a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Zdenek Kabelac wrote:

> Another backtrace from suspend code path:
> (T61, 2GB, C2D, no SD card)
> kernel from git 20080603, commit 1beee8dc8cf58e3f605bd7b34d7a39939be7d8d2
> ----
> agpgart-intel 0000:00:00.0: LATE suspend
> platform bay.0: LATE suspend
> platform dock.0: LATE suspend
> Extended CMOS year: 2000
>  hwsleep-0324 [00] enter_sleep_state     : Entering sleep state [S3]
> Back to C!
> BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/17334
> caller is do_machine_check+0xa9/0x500
> Pid: 17334, comm: pm-suspend Not tainted 2.6.26-rc4 #31
> Call Trace:
>  [<ffffffff8118347c>] debug_smp_processor_id+0xcc/0xd0
>  [<ffffffff810184d9>] do_machine_check+0xa9/0x500
>  [<ffffffff81010e7b>] ? init_8259A+0x1b/0x120
>  [<ffffffff810189d6>] mce_init+0x56/0xf0
>  [<ffffffff81018a7b>] mce_resume+0xb/0x10
>  [<ffffffff81204fd0>] __sysdev_resume+0x20/0x60
>  [<ffffffff81205068>] sysdev_resume+0x58/0x90
>  [<ffffffff8120aac9>] device_power_up+0x9/0x10
>  [<ffffffff8106f4f7>] suspend_devices_and_enter+0x147/0x1a0
>  [<ffffffff8106f6c6>] enter_state+0x146/0x1d0
>  [<ffffffff8106f80a>] state_store+0xba/0x100
>  [<ffffffff81177ae7>] kobj_attr_store+0x17/0x20
>  [<ffffffff81110fea>] sysfs_write_file+0xca/0x140
>  [<ffffffff810ba00b>] vfs_write+0xcb/0x190
>  [<ffffffff810ba1c0>] sys_write+0x50/0x90
>  [<ffffffff8100c4fb>] system_call_after_swapgs+0x7b/0x80

This looks very much like the oops you reported here: 
http://lkml.org/lkml/2008/4/7/130

Is this also a virtual machine run under KVM, as it has been in the 
aforementioned thread?

Thanks,

-- 
Jiri Kosina
SUSE Labs

