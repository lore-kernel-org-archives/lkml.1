Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083Ab0AFBDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0AFBDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921Ab0AFBDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:03:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab0AFBDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:03:41 -0500
Date: Tue, 5 Jan 2010 17:03:37 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: jeremy@goop.org
Subject: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
Message-ID: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/Ln3FtEGdUQ5xvunh9UIHvTdT2ICtnFuWiXq0
 o8/P/KLrVXFXKuKCRMHUlfCDQDwAFO1ONPhYe/DZ03caQyZkY3
 FhgbPNnXhHJ8ygE/lS0ig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

a bit late with the testing again, I just found out that my Xen 
DomU won't boot with 2.6.33-rc2. The last working one is 2.6.32, I'll try 
to bisect if needed.

The booting stops at:

[    0.010000] no hardware sampling interrupt available.
[    0.010000] Intel PMU driver.
[    0.010000] ... version:                2
[    0.010000] ... bit width:              40
[    0.010000] ... generic registers:      2
[    0.010000] ... value mask:             000000ffffffffff
[    0.010000] ... max period:             000000007fffffff
[    0.010000] ... fixed-purpose events:   3
[    0.010000] ... event mask:             0000000700000003
[    0.011314] Freeing SMP alternatives: 24k freed


And "xm dmesg" says:

xen# xm dmesg
(XEN) traps.c:244:d88 Guest switching to user mode with no user page tables
(XEN) traps.c:273:d88 Fatal error
(XEN) domain_crash called from traps.c:274
(XEN) Domain 88 (vcpu#0) crashed on cpu#0:
(XEN) ----[ Xen-3.2.1-rc1-pre  x86_64  debug=n  Not tainted ]----
(XEN) CPU:    0
(XEN) RIP:    e033:[<ffffffff810012eb>]
(XEN) RFLAGS: 0000000000240246   CONTEXT: guest
(XEN) rax: 0000000000000017   rbx: 0000000000000000   rcx: ffffffff810012eb
(XEN) rdx: 0000000000000000   rsi: ffffffff810488a0   rdi: 0000000000000000
(XEN) rbp: 0000000000000000   rsp: ffff88000f83df90   r8:  0000000000000000
(XEN) r9:  0000000000000000   r10: 0000000000000000   r11: 0000000000240246
(XEN) r12: 0000000000000000   r13: 0000000000000000   r14: 0000000000000000
(XEN) r15: 0000000000000000   cr0: 000000008005003b   cr4: 00000000000026b0
(XEN) cr3: 0000000096ba9000   cr2: 0000000000000000
(XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
(XEN) Guest stack trace from rsp=ffff88000f83df90:
(XEN)    0000000000000000 0000000000000202 ffffffff81009880 0000000000000100
(XEN)    ffffffff81009880 0000000000000033 0000000000000202 0000000000000000
(XEN)    000000000000002b ffffffff81009880 0000000000000011 0000000000000202
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000

xen# gdb vmlinux.2010-01-05.6451
(no debugging symbols found)
(gdb) x/i 0xffffffff810012eb
0xffffffff810012eb <hypercall_page+747>:        add    %al,(%rax)


The Dom0 is running a 2.6.24-24-xen Ubuntu kernel amd I'm kinda reluctant 
to upgrade, as I don't have a serial console to this MacMini, if things go 
wrong :-\

I've put the .config (make oldconfig from 2.6.32) and dmesg on:

  http://nerdbynature.de/bits/2.6.33-rc2/xen/

Any ideas?

Thanks,
Christian.
-- 
BOFH excuse #349:

Stray Alpha Particles from memory packaging caused Hard Memory Error on Server.
