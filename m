Return-Path: <linux-kernel-owner+w=401wt.eu-S1161173AbXCNLyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161173AbXCNLyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161176AbXCNLyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:54:22 -0400
Received: from bay0-omc1-s39.bay0.hotmail.com ([65.54.246.111]:65237 "EHLO
	bay0-omc1-s39.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161173AbXCNLyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:54:21 -0400
Message-ID: <BAY103-DAV1644D38E44649CAF3A2C74B2730@phx.gbl>
X-Originating-IP: [85.36.106.198]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/slab.c:610
Date: Wed, 14 Mar 2007 12:54:02 +0100
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 14 Mar 2007 11:54:21.0353 (UTC) FILETIME=[80C97190:01C7662F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Berizzi wrote:

> Pekka Enberg wrote:
>
> Hi Pekka,
>
> > So, can you please repost the original oops?
>
> Here is:
>
> Mar 14 03:42:25 Mimosa kernel: ------------[ cut here ]------------
> Mar 14 03:42:25 Mimosa kernel: kernel BUG at mm/slab.c:610!
> Mar 14 03:42:25 Mimosa kernel: invalid opcode: 0000 [#1]
> Mar 14 03:42:25 Mimosa kernel: Modules linked in: sch_sfq sch_htb
cls_fw
> nf_nat_pptp nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre
> nf_nat_ftp nf_conntrack_ftp 3c59x mii
> Mar 14 03:42:25 Mimosa kernel: CPU:    0
> Mar 14 03:42:25 Mimosa kernel: EIP:    0060:[<c014ca99>]    Not
tainted
> VLI
> Mar 14 03:42:25 Mimosa kernel: EFLAGS: 00010046   (2.6.20 #1)
> Mar 14 03:42:25 Mimosa kernel: EIP is at free_block+0xd9/0xf0
> Mar 14 03:42:25 Mimosa kernel: eax: 00080000   ebx: c1000000   ecx:
> c0e7d4e0   edx: c101cfa0
> Mar 14 03:42:25 Mimosa kernel: esi: c1210000   edi: c1176560   ebp:
> 00000000   esp: c119bef0
> Mar 14 03:42:25 Mimosa kernel: ds: 007b   es: 007b   ss: 0068
> Mar 14 03:42:25 Mimosa kernel: Process events/0 (pid: 3, ti=c119a000
> task=c118f030 task.ti=c119a000)
> Mar 14 03:42:25 Mimosa kernel: Stack: c1213a10 161c9ed5 c1210010
> c1210010 c1210000 161c9ed5 c1176560 c014d201
> Mar 14 03:42:25 Mimosa kernel:        00000000 c1180420 c1176560
> c1180d60 c014d220 c014d26b 00000000 00000000
> Mar 14 03:42:25 Mimosa kernel:        c03b7ae0 c03b7ae0 00000282
> c0123d37 00000000 c118f13c 0000007b 0000508b
> Mar 14 03:42:25 Mimosa kernel: Call Trace:
> Mar 14 03:42:25 Mimosa kernel:  [<c014d201>] drain_array+0x91/0xb0
> Mar 14 03:42:25 Mimosa kernel:  [<c014d220>] cache_reap+0x0/0xf0
> Mar 14 03:42:25 Mimosa kernel:  [<c014d26b>] cache_reap+0x4b/0xf0
> Mar 14 03:42:25 Mimosa kernel:  [<c0123d37>] run_workqueue+0x67/0x130
> Mar 14 03:42:25 Mimosa kernel:  [<c0123f3a>] worker_thread+0x13a/0x170
> Mar 14 03:42:25 Mimosa kernel:  [<c01123e0>]
> default_wake_function+0x0/0x10
> Mar 14 03:42:25 Mimosa kernel:  [<c0112427>]
__wake_up_common+0x37/0x70
> Mar 14 03:42:25 Mimosa kernel:  [<c01123e0>]
> default_wake_function+0x0/0x10
> Mar 14 03:42:25 Mimosa kernel:  [<c0123e00>] worker_thread+0x0/0x170
> Mar 14 03:42:25 Mimosa kernel:  [<c01271a6>] kthread+0xb6/0xc0
> Mar 14 03:42:25 Mimosa kernel:  [<c01270f0>] kthread+0x0/0xc0
> Mar 14 03:42:25 Mimosa kernel:  [<c01036a3>]
> kernel_thread_helper+0x7/0x14
> Mar 14 03:42:25 Mimosa kernel:  =======================
> Mar 14 03:42:25 Mimosa kernel: Code: ff 83 c4 0c 5b 5e 5f 5d c3 8b 57
20
> 29 d0 89 da 89 46 18 89 f8 e8 78 f1 ff ff eb da 89 33 8b 46 04 89 5e
04
> 89 18 89 43 04 eb cb <0f> 0b 90 8d 74 26 00 eb fe 8b 52 0c e9 57 ff ff
> ff 8d b6 00 00
> Mar 14 03:42:25 Mimosa kernel: EIP: [<c014ca99>] free_block+0xd9/0xf0
> SS:ESP 0068:c119bef0

Only to tell you, that on the console linux was printing
this message:

atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying
access hardware directly.


