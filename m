Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbYHUSHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbYHUSHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760515AbYHUSGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:06:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760603AbYHUSGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:06:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: suspend: unable to handle kernel paging request (was Re: no_console_suspend doesn't work?)
Date: Thu, 21 Aug 2008 20:10:05 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com>
In-Reply-To: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808212010.06043.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 21 of August 2008, Vegard Nossum wrote:
> On Thu, Aug 21, 2008 at 6:49 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > But I think it would be a lot more useful to see _everything_. Why
> > doesn't output to ttyS0 work? It works with tty0... I have tried
> > various combinations (leaving out console=tty0, leaving out
> > earlyprintk, using netconsole, kexec crashdump), but nothing seems to
> > be able to help. Do you have any suggestions?
> 
> I did it!
> 
> With a little debug patch, I got the oops to ttyS0,

What exactly did you do to achieve that?

> but with each printk() duplicated (I removed some of them). This is from resume:
> 
> BUG: unable to handle kernel BUG: unable to handle kernel paging
> requestpaging request at 00200200
>  at 00200200
> IP:IP: [<c038accc>] list_del+0xc/0x90
>  [<c038accc>] list_del+0xc/0x90
> *pdpt = 00000000331a0001 *pde = 0000000000000000
> Oops: 0000 [#1] Oops: 0000 [#1] PREEMPT PREEMPT SMP SMP
> DEBUG_PAGEALLOCDEBUG_PAGEALLOC
> Pid: 3473, comm: bash Not tainted (2.6.27-rc4-00003-ga798564-dirty #30)
> EIP: 0060:[<c038accc>] EFLAGS: 00210082 CPU: 0
> EIP is at list_del+0xc/0x90
> EAX: 00200200 EBX: f77fcc00 ECX: 00000001 EDX: f31a6000
> ESI: c088e814 EDI: c088e83c EBP: f31a7be8 ESP: f31a7bd0
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process bash (pid: 3473, ti=f31a6000 task=f30ea700 task.ti=f31a6000)
> Stack: Stack: 00000000 00000000 00000002 00000002 00000000 00000000
> c01b39be c01b39be f77cefa0 f77cefa0 f77fcbd0 f77fcbd0 f31a7bfc
> f31a7bfc c01b39ef c01b39ef
>               f77cefa0 f77cefa0 00000000 00000000 c1133598 c1133598
> f31a7c3c f31a7c3c c01b3ebc c01b3ebc c0b530c0 c0b530c0 f31a7c18
> f31a7c18 c015b60e c015b60e
>               f31a7c18 f31a7c18 ffffffff ffffffff 00000020 00000020
> c088e800 c088e800 00200046 00200046 00000000 00000000 00000000
> 00000000 00000000 00000000
> Call Trace:
>  [<c01b39be>]  [<c01b39be>] ? ? get_partial_node+0x3e/0xc0
>  [<c01b39ef>]  [<c01b39ef>] ? ? get_partial_node+0x6f/0xc0
>  [<c01b3ebc>]  [<c01b3ebc>] ? ? __slab_alloc+0x11c/0x4e0
>  [<c015b60e>]  [<c015b60e>] ? ? get_lock_stats+0x1e/0x50
>  [<c01b5ffc>]  [<c01b5ffc>] ? ? __kmalloc+0x11c/0x130
>  [<c03ceeb2>]  [<c03ceeb2>] ? ? tty_buffer_request_room+0xe2/0x130
>  [<c03ceeb2>]  [<c03ceeb2>] ? ? tty_buffer_request_room+0xe2/0x130
>  [<c03ceeb2>]  [<c03ceeb2>] ? ? tty_buffer_request_room+0xe2/0x130
>  [<c03d131d>]  [<c03d131d>] ? ? tty_insert_flip_string_flags+0x2d/0xa0
>  [<c03efcf1>]  [<c03efcf1>] ? ? receive_chars+0x161/0x290
>  [<c03f0d24>]  [<c03f0d24>] ? ? serial8250_interrupt+0x134/0x150
>  [<c017db28>]  [<c017db28>] ? ? handle_IRQ_event+0x28/0x70
>  [<c017f0ef>]  [<c017f0ef>] ? ? handle_edge_irq+0xaf/0x140
>  [<c0108138>]  [<c0108138>] ? ? do_IRQ+0x48/0xa0
>  [<c037b7a4>]  [<c037b7a4>] ? ? trace_hardirqs_off_thunk+0xc/0x18
>  [<c0105a3c>]  [<c0105a3c>] ? ? common_interrupt+0x28/0x30
>  [<c013b2d1>]  [<c013b2d1>] ? ? vprintk+0x151/0x3c0
>  [<c015e884>]  [<c015e884>] ? ? trace_hardirqs_on_caller+0xd4/0x160
>  [<c015e91b>]  [<c015e91b>] ? ? trace_hardirqs_on+0xb/0x10
>  [<c0687983>]  [<c0687983>] ? ? _spin_unlock_irqrestore+0x43/0x70
>  [<c038ef8b>]  [<c038ef8b>] ? ? pci_bus_read_config_byte+0x5b/0x70
>  [<c013b55b>]  [<c013b55b>] ? ? printk+0x1b/0x20
>  [<c059a748>]  [<c059a748>] ? ? pcibios_set_master+0x68/0xa0
>  [<c03925c4>]  [<c03925c4>] ? ? pci_set_master+0x54/0x60
>  [<c0513d9c>]  [<c0513d9c>] ? ? usb_hcd_pci_resume+0x4c/0xf0
>  [<c015e91b>]  [<c015e91b>] ? ? trace_hardirqs_on+0xb/0x10
>  [<c0393cf6>]  [<c0393cf6>] ? ? pci_legacy_resume+0x16/0x30
>  [<c0393d5a>]  [<c0393d5a>] ? ? pci_pm_restore+0x4a/0x60
>  [<c03f83e5>]  [<c03f83e5>] ? ? pm_op+0x115/0x130
>  [<c03f8986>]  [<c03f8986>] ? ? device_resume+0xd6/0x380
>  [<c0168791>]  [<c0168791>] ? ? hibernation_snapshot+0xa1/0x220
>  [<c013b55b>]  [<c013b55b>] ? ? printk+0x1b/0x20
>  [<c01689f0>]  [<c01689f0>] ? ? hibernate+0xe0/0x180
>  [<c01674a0>]  [<c01674a0>] ? ? state_store+0x0/0xd0
>  [<c016755f>]  [<c016755f>] ? ? state_store+0xbf/0xd0
>  [<c01674a0>]  [<c01674a0>] ? ? state_store+0x0/0xd0
>  [<c0375ef4>]  [<c0375ef4>] ? ? kobj_attr_store+0x24/0x30
>  [<c01fa432>]  [<c01fa432>] ? ? sysfs_write_file+0xa2/0x100
>  [<c01bbf06>]  [<c01bbf06>] ? ? vfs_write+0x96/0x130
>  [<c01fa390>]  [<c01fa390>] ? ? sysfs_write_file+0x0/0x100
>  [<c01bc44d>]  [<c01bc44d>] ? ? sys_write+0x3d/0x70
>  [<c0104f3b>]  [<c0104f3b>] ? ? sysenter_do_call+0x12/0x3f
>  =======================
> Code: Code: e8 e8 01 01 89 89 44 44 24 24 04 04 e8 e8 94 94 08 08 db
> db ff ff 8b 8b 55 55 04 04 b8 b8 80 80 45 45 7a 7a c0 c0 e8 e8 e7 e7
> c2 c2 dd dd ff ff e8 e8
>  a2 a2 c7 c7 d7 d7 ff ff eb eb a9 a9 55 55 89 89 e5 e5 53 53 89 89 c3
> c3 83 83 ec ec 14 14 8b 8b 40 40 04 04 <8b> <8b> 00 00 39 39 d8 d8 75
> 75 24 24 8b 8b 13 13
> 8b 8b 42 42 04 04 39 39 d8 d8 75 75 41 41 8b 8b 43 43 04 04 89 89 42 42 04 04
> EIP: [<c038accc>] EIP: [<c038accc>] list_del+0xc/0x90list_del+0xc/0x90
> SS:ESP 0068:f31a7bd0
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> The EIP corresponds to the first line of list_del, lib/list_debug.c:46:
> 
> void list_del(struct list_head *entry)
> {
>         WARN(entry->prev->next != entry,
> 
> I actually have one theory: Data arrives on the serial port at the
> wrong moment, so interrupt happens before everything is
> restored/resumed. You can see the interrupt in the stack trace. Does
> this seem possible?

To me, it does, but the question is if that's not caused by the serial console
itself ...

Thanks,
Rafael

