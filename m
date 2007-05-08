Return-Path: <linux-kernel-owner+w=401wt.eu-S934744AbXEHJOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744AbXEHJOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934565AbXEHJOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:14:35 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934546AbXEHJOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:14:34 -0400
Date: Tue, 8 May 2007 02:11:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.21-mm1 hwsusp: BUG at workqueue.c:106
Message-Id: <20070508021131.438cee31.akpm@linux-foundation.org>
In-Reply-To: <46403B7F.1050009@gmail.com>
References: <46403B7F.1050009@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2007 10:57:35 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> 
> this occured in dmesg during resuming from hwsusp in 2.6.21-mm1 (captured
> through netconsole). Perfectly reproducible, it simply happens each time I
> try it.

Let's cc Oleg.

> usb_endpoint usbdev5.1_ep00: PM: resume from 0, parent usb5 still 2
> ------------[ cut here ]------------
> kernel BUG at /home/l/latest/xxx/kernel/workqueue.c:106!
> invalid opcode: 0000 [#1]
> SMP
> Modules linked in: ipv6 floppy ohci1394 ieee1394 parport_pc parport usbhid
> ehci_hcd pata_acpi ff_memless sr_mod cdrom
> CPU:    1
> EIP:    0060:[<c0132161>]    Not tainted VLI
> EFLAGS: 00010046   (2.6.21-mm1 #272)
> EIP is at insert_work+0x6d/0x71
> eax: c1c3b3c0   ebx: c1814aa0   ecx: 00000001   edx: c1814aa0
> esi: c1c3b340   edi: 00000282   ebp: c04d2f68   esp: c04d2f50
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process swapper (pid: 0, ti=c04d2000 task=c1c26030 task.ti=c1c20000)
> Stack: c4685f54 c18148ac c04d2f98 c013816f c1c3b340 c1814aa0 c04d2f88 c013256c
>        00000066 c1814880 c1c5e000 c04d2fc4 c01325a1
> c1c5e000 00000100 c012ba35 00000000 c04d2fb8 c01333f4 Call Trace:
>  [<c0104f27>]  [<c0104fe2>] show_stack_log_lvl+0xa5/0xca
> show_registers+0x1e2/0x2da
>  [<c01053f5>]  [<c010559a>] do_trap+0x84/0xaa
> do_invalid_op+0x88/0x92
>  [<c0378662>]  [<c013256c>] __queue_work+0x22/0x33
> delayed_work_timer_fn+0x24/0x2a
>  [<c012ba35>]  [<c01288a9>] __do_softirq+0x75/0xe6
> do_softirq+0x63/0xac
>  [<c0128713>]  [<c0116d7e>] smp_apic_timer_interrupt+0x5c/0x88
> apic_timer_interrupt+0x28/0x30
>  [<c010238d>]  [<c0115ad0>] start_secondary+0x25e/0x37a
> 0x0
>  =======================
> 00 00 ba 03 00 00 40 a3 ff 83 10 5b 5d c3 4e 04 56 04 43 04 42 04 53 04 48
> 04 46 04 c9 <0f> eb fe 89 e5 ec 0c
> 

hm, how come it's so messy?
