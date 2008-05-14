Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbYENLYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbYENLYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbYENLYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:24:35 -0400
Received: from xi.wantstofly.org ([83.160.184.112]:53493 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649AbYENLYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:24:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:user-agent;
	b=Ry/7X/TTF3Kj58Lvt1ay1QwOhFG5u/cNfGRscrGJ/OWJykqMt0GRyeowfWjQi
	DHfvPoh6Ckb6spryDI0kLFuLQ==
Date: Wed, 14 May 2008 13:24:29 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>, Nicolas Pitre <nico@cam.org>,
       Sylver Bruneau <sylver.bruneau@googlemail.com>,
       Byron Bradley <byron.bbradley@gmail.com>,
       Martin Michlmayr <tbm@cyrius.com>
Subject: ehci splatter in 2.6.26-rc2
Message-ID: <20080514112429.GA25926@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.26-rc2, plugging in a certain USB device (haven't tested yet
with other devices) gives me (on two different ARM boards) the oops
below.

Anyone else seeing the same?


usb 1-1: new low speed USB device using orion-ehci and address 2
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 17 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.26-rc2 #340)
PC is at qh_append_tds+0x24c/0x44c
LR is at ehci_qtd_alloc+0x30/0x5c
pc : [<c02238b4>]    lr : [<c02235a8>]    psr: 00000093
sp : c7c3bcb0  ip : c7dd86c0  fp : c7c3bcfc
r10: ffc42080  r9 : 00000008  r8 : c7fec820
r7 : 80000080  r6 : 00000080  r5 : 00000000  r4 : 00000002
r3 : c7d69c00  r2 : 00000000  r1 : 40800000  r0 : 08085000
Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: a005317f  Table: 06a1c000  DAC: 00000017
Process khubd (pid: 72, stack limit = 0xc7c3a268)
Stack: (0xc7c3bcb0 to 0xc7c3c000)
[...]
Backtrace: 
[<c0223668>] (qh_append_tds+0x0/0x44c) from [<c0225470>] (ehci_urb_enqueue+0x100
/0xfb8)
[<c0225370>] (ehci_urb_enqueue+0x0/0xfb8) from [<c02163e8>] (usb_hcd_submit_urb+
0x824/0x91c)
[<c0215bc4>] (usb_hcd_submit_urb+0x0/0x91c) from [<c0216850>] (usb_submit_urb+0x
224/0x260)
[<c021662c>] (usb_submit_urb+0x0/0x260) from [<c02172e8>] (usb_start_wait_urb+0x
44/0xac)
 r6:c7fec820 r5:c7c3be80 r4:00000000
[<c02172a4>] (usb_start_wait_urb+0x0/0xac) from [<c0217538>] (usb_control_msg+0x
c8/0xec)
 r8:00000000 r7:00000100 r6:fffffff4 r5:00000040 r4:c7df4540
[<c0217470>] (usb_control_msg+0x0/0xec) from [<c021206c>] (hub_port_init+0x274/0
x5e4)
[<c0211df8>] (hub_port_init+0x0/0x5e4) from [<c0213408>] (hub_thread+0x60c/0xc1c
)
[<c0212dfc>] (hub_thread+0x0/0xc1c) from [<c0058844>] (kthread+0x5c/0x94)
[<c00587e8>] (kthread+0x0/0x94) from [<c0046484>] (do_exit+0x0/0x72c)
 r6:00000000 r5:00000000 r4:00000000
Code: e51bc040 e5932000 e51c309c e1520003 (15923000)
---[ end trace e1e1758047d6bb3f ]---
note: khubd[72] exited with preempt_count 1
