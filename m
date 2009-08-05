Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbZHEIzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbZHEIzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbZHEIzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:55:45 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55571 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571AbZHEIzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vmZ5jkucjchaIPMwK5qSdrMbFJrll9MpeJaic9UtronKL+qkRkJj9ahS6Qr4ajgnzR
         ebs+ByhwY06GoCdBe8hxbYiGYTrwmW/MPATBR4WvZM+qe2onXWp47ad7T47BbQ69lnea
         UVAgbgwPpAVBuvbcVnDo4xZ0wb6epXpQ2SZJg=
MIME-Version: 1.0
Date: Wed, 5 Aug 2009 10:55:43 +0200
Message-ID: <c4e36d110908050155y59fd528et35a9a2ac22638307@mail.gmail.com>
Subject: INFO: trying to register non-static key
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

After update to current git vanilla head
90bc1a658a53f8832ee799685703977a450e5af9
(building x86_64 kernel)  I've got attached INFO message.

Probably a result of some commit between 31-rc5-00000  & 31-rc5-00246

PCI: Using ACPI for IRQ routing
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 1, comm: swapper Not tainted 2.6.31-rc5-00248-g804067f #80
Call Trace:
 [<ffffffff810775a2>] register_lock_class+0x202/0x440
 [<ffffffff8137eb90>] ? _write_unlock_irqrestore+0x40/0x70
 [<ffffffff8107a86d>] ? trace_hardirqs_on_caller+0x15d/0x1a0
 [<ffffffff8107a8bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8107b353>] __lock_acquire+0x83/0x1090
 [<ffffffff810fd015>] ? kmem_cache_alloc_notrace+0xe5/0x140
 [<ffffffff8107c3f8>] lock_acquire+0x98/0x140
 [<ffffffff812f9c99>] ? alloc_netdev_mq+0x139/0x220
 [<ffffffff8137f04b>] _spin_lock_bh+0x3b/0x70
 [<ffffffff812f9c99>] ? alloc_netdev_mq+0x139/0x220
 [<ffffffff812f9c99>] alloc_netdev_mq+0x139/0x220
 [<ffffffff812b71c0>] ? loopback_setup+0x0/0x80
 [<ffffffff815b25b0>] loopback_net_init+0x28/0x78
 [<ffffffff812f200d>] register_pernet_operations+0x1d/0x20
 [<ffffffff812f20c6>] register_pernet_device+0x36/0x80
 [<ffffffff815b733c>] net_dev_init+0x154/0x1b1
 [<ffffffff815b71e8>] ? net_dev_init+0x0/0x1b1
 [<ffffffff8100904f>] do_one_initcall+0x3f/0x1b0
 [<ffffffff811d600e>] ? ida_get_new_above+0x13e/0x200
 [<ffffffff8107a577>] ? mark_held_locks+0x67/0x90
 [<ffffffff8107a8bd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81079fa5>] ? lock_release_holdtime+0x35/0x1b0
 [<ffffffff8137ee0b>] ? _spin_unlock+0x2b/0x40
 [<ffffffff81159797>] ? proc_register+0x127/0x210
 [<ffffffff81159e7e>] ? create_proc_entry+0x5e/0xb0
 [<ffffffff810a25c4>] ? register_irq_proc+0xc4/0xe0
 [<ffffffff8158e4e8>] kernel_init+0x152/0x1a8
 [<ffffffff8100d1da>] child_rip+0xa/0x20
 [<ffffffff8100cb7c>] ? restore_args+0x0/0x30
 [<ffffffff8158e396>] ? kernel_init+0x0/0x1a8
 [<ffffffff8100d1d0>] ? child_rip+0x0/0x20
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1

Zdenek
