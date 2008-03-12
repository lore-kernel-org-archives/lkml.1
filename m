Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbYCLKLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbYCLKLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYCLKLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:11:36 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:40139 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYCLKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:11:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=Ky3Raa8rG41Myh0RPt2fympnHMteiQ1rElZMOpA5100UKo131rqdu5KIYJVh9
	7Ky05lJgPnT7CgfLt4E7mzcAg==
Date: Wed, 12 Mar 2008 11:11:31 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>,
       Rabeeh Khoury <rabeeh@marvell.com>
Subject: Re: ehci watchdog-related splatter in 2.6.25-rc4
Message-ID: <20080312101131.GC24017@xi.wantstofly.org>
References: <20080312093045.GA24017@xi.wantstofly.org> <200803120238.49050.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120238.49050.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 01:38:48AM -0800, David Brownell wrote:

> > Seems like EHCI IRQ firing while ehci_iaa_watchdog() is running.
> 
> Does RC5 resolve this?

Nope.

e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 (post -rc5) looks like it
might fix it -- I'll re-test with that applied as well.


[root@mv78100 tmp]# yumdownloader --source kde-i18n
Enabling f8-source repository
Enabling f8-updates-source repository
kde-i18n-3.5.9-4.fc8.src.  58% |==============           | 149 MB    00:22 ETA
pgd = ef6c0000
[00000060] *pgd=2f41a031, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.25-rc5 #349)
PC is at end_unlink_async+0x1c/0x13c
LR is at end_unlink_async+0x1c/0x13c
pc : [<c0284520>]    lr : [<c0284520>]    psr: 60000093
sp : ef529e08  ip : ef529e08  fp : ef529e24
r10: efe72800  r9 : ef528000  r8 : 00000021
r7 : 00000010  r6 : 00000000  r5 : efe728c0  r4 : 00000000
r3 : 00000000  r2 : ef528000  r1 : efe72800  r0 : 00000000
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005317f  Table: 2f6c0000  DAC: 00000015
Process yumdownloader (pid: 1027, stack limit = 0xef528268)
Stack: (0xef529e08 to 0xef52a000)
9e00:                   000080a9 efe728c0 00000000 00000010 ef529e4c ef529e28
9e20: c0288364 c0284514 efe72800 00000000 00000000 00000010 00000103 4015e200
9e40: ef529e64 ef529e50 c02765c8 c02882f0 055d4a80 efe75860 ef529e84 ef529e68
9e60: c0065fa4 c027659c ef528000 c0401b90 00000010 efe75860 ef529ea4 ef529e88
9e80: c0067df8 c0065f70 00000010 c0401b90 ef529fb0 00000104 ef529ec4 ef529ea8
9ea0: c0022048 c0067d38 ffd3a1cc ffffffff fe400200 0000000f ef529f24 ef529ec8
9ec0: c0022668 c0022010 00000000 ffd3a180 ffd3a1cc ef528010 efe728c0 60000013
9ee0: ef528000 c02881cc 00000000 ef528000 4015e200 ef529f24 ef529ef0 ef529f10
9f00: c0284564 c0288254 60000013 ffffffff 00000102 c041f2c0 ef529f54 ef529f28
9f20: c0048a00 c02881dc ef529f28 ef529f28 ef529f54 00000005 c041f0e4 00000009
9f40: 00000001 00000000 ef529f74 ef529f58 c0043f98 c004889c ef528000 ef528000
9f60: c0401b90 00000000 ef529f8c ef529f78 c00443d8 c0043f48 00000000 00000010
9f80: ef529fac ef529f90 c002204c c0044398 00000000 ffffffff fe400200 0000000f
9fa0: 00000000 ef529fb0 c0022890 c0022010 00000004 0179c000 40168734 0000a534
9fc0: 01560968 000111c0 015609b8 00000000 0138d870 40c4fb3d 4015e200 000111c0
9fe0: 01560000 bee148d0 012832e0 400a3ac4 20000010 ffffffff 00000000 00000000
Backtrace:
[<c0284504>] (end_unlink_async+0x0/0x13c) from [<c0288364>] (ehci_irq+0x84/0x1b
 r7:00000010 r6:00000000 r5:efe728c0 r4:000080a9
[<c02882e0>] (ehci_irq+0x0/0x1b0) from [<c02765c8>] (usb_hcd_irq+0x3c/0x8c)
[<c027658c>] (usb_hcd_irq+0x0/0x8c) from [<c0065fa4>] (handle_IRQ_event+0x44/0x
 r4:efe75860
[<c0065f60>] (handle_IRQ_event+0x0/0x84) from [<c0067df8>] (handle_level_irq+0x
 r7:efe75860 r6:00000010 r5:c0401b90 r4:ef528000
[<c0067d28>] (handle_level_irq+0x0/0x158) from [<c0022048>] (__exception_text_s
 r7:00000104 r6:ef529fb0 r5:c0401b90 r4:00000010
[<c0022000>] (__exception_text_start+0x0/0x64) from [<c0022668>] (__irq_svc+0x4
Exception stack(0xef529ec8 to 0xef529f10)
9ec0:                   00000000 ffd3a180 ffd3a1cc ef528010 efe728c0 60000013
9ee0: ef528000 c02881cc 00000000 ef528000 4015e200 ef529f24 ef529ef0 ef529f10
9f00: c0284564 c0288254 60000013 ffffffff
 r6:0000000f r5:fe400200 r4:ffffffff
[<c02881cc>] (ehci_iaa_watchdog+0x0/0xb4) from [<c0048a00>] (run_timer_softirq+
 r5:c041f2c0 r4:00000102
[<c004888c>] (run_timer_softirq+0x0/0x220) from [<c0043f98>] (__do_softirq+0x60
 r8:00000000 r7:00000001 r6:00000009 r5:c041f0e4 r4:00000005
[<c0043f38>] (__do_softirq+0x0/0xd4) from [<c00443d8>] (irq_exit+0x50/0x9c)
 r6:00000000 r5:c0401b90 r4:ef528000
[<c0044388>] (irq_exit+0x0/0x9c) from [<c002204c>] (__exception_text_start+0x4c
 r4:00000010
[<c0022000>] (__exception_text_start+0x0/0x64) from [<c0022890>] (__irq_usr+0x5
Exception stack(0xef529fb0 to 0xef529ff8)
9fa0:                                     00000004 0179c000 40168734 0000a534
9fc0: 01560968 000111c0 015609b8 00000000 0138d870 40c4fb3d 4015e200 000111c0
9fe0: 01560000 bee148d0 012832e0 400a3ac4 20000010 ffffffff
 r6:0000000f r5:fe400200 r4:ffffffff
Code: e5904014 e1a05000 e2800090 ebf71060 (e5942060)
Kernel panic - not syncing: Fatal exception in interrupt
