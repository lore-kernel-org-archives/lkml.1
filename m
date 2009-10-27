Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZJ0B1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZJ0B1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 21:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZJ0B1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 21:27:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZJ0B1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 21:27:05 -0400
Date: Mon, 26 Oct 2009 18:26:21 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
In-Reply-To: <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.0910261820050.9408@bogon.housecafe.de>
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org> <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/+efJr+xwQIyfThjVWb3fJKAF5yYy0wZpMwyE
 L6pSYelU1SD3m6ZkhV8xj1CAUczXgtTI1Dflw7P8XT75UvYzYf
 EvHVi6Tk/iGKQxwaIgmVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 at 18:14, Christian Kujau wrote:
> Oh, I totally forgot about "xm dmesg", it's on the URL above too. I don't 
> see any timestamps in "xm dmesg", so I guess I'll have to try again with 
> "xm dmesg --clear" inbetween boots.

Did that - when I boot a working kernel (2.6.31), "xm dmesg" prints 
nothing but a newline. When I boot 2.6.31-rc1, this happens:

$ xm create sid.cfg -c
Using config file "/etc/xen/sid.cfg".
Started domain sid

$ xm dmesg
(XEN) mm.c:665:d889 Error getting mfn 127f (pfn 7403) from L1 entry 801000000127f065 for dom889
(XEN) traps.c:413:d889 Unhandled invalid opcode fault/trap [#6] on VCPU 0 [ec=0000]
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 889 (vcpu#0) crashed on cpu#0:
(XEN) ----[ Xen-3.2.1-rc1-pre  x86_64  debug=n  Not tainted ]----
(XEN) CPU:    0
(XEN) RIP:    e033:[<ffffffff812c50ad>]
(XEN) RFLAGS: 0000000000000282   CONTEXT: guest
(XEN) rax: 00000000ffffffea   rbx: 800000000127f061   rcx: 000000000008885a
(XEN) rdx: 0000000000000000   rsi: 800000000127f061   rdi: ffffffff8127f000
(XEN) rbp: ffffffff81279fb8   rsp: ffffffff81279f18   r8:  0000000000000000
(XEN) r9:  0000000000000000   r10: 0000000000000000   r11: 0000000000000000
(XEN) r12: ffffffff8127f000   r13: 0000000000000000   r14: 0000000000000080
(XEN) r15: ffffffff81279fc8   cr0: 000000008005003b   cr4: 00000000000026b0
(XEN) cr3: 00000000aa991000   cr2: 0000000000000000
(XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
(XEN) Guest stack trace from rsp=ffffffff81279f18:
(XEN)    000000000008885a 0000000000000000 ffffffff812c50ad 000000010000e030
(XEN)    0000000000010082 ffffffff81279f58 000000000000e02b ffffffff812c504c
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 ffffffff81279f60 0000008000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 ffffffff810197bd ffff8127f000007f 000000000000ffff
(XEN)    0000000000000000 ffffffff812c4d19 0000000000000000 0000000000000000
(XEN)    0000000000000000 ffffffff81385000 ffffffff81386000 ffffffff81387000
(XEN)    ffffffff81388000 ffffffff81389000 ffffffff8138a000 ffffffff8138b000
(XEN)    ffffffff8138c000 ffffffff8138d000 ffffffff8138e000 ffffffff8138f000
(XEN)    ffffffff81390000 ffffffff81391000 ffffffff81392000 ffffffff81393000
(XEN)    ffffffff81394000 ffffffff81395000 ffffffff81396000 ffffffff81397000
(XEN)    ffffffff81398000 ffffffff81399000 ffffffff8139a000 ffffffff8139b000
(XEN)    ffffffff8139c000 ffffffff8139d000 ffffffff8139e000 ffffffff8139f000
(XEN)    ffffffff813a0000 ffffffff813a1000 ffffffff813a2000 ffffffff813a3000
(XEN)    ffffffff813a4000 ffffffff813a5000 ffffffff813a6000 ffffffff813a7000
(XEN)    ffffffff813a8000 ffffffff813a9000 ffffffff813aa000 ffffffff813ab000
(XEN)    ffffffff813ac000 ffffffff813ad000 ffffffff813ae000 ffffffff813af000
(XEN)    ffffffff813b0000 ffffffff813b1000 ffffffff813b2000 ffffffff813b3000
(XEN)    ffffffff813b4000 ffffffff813b5000 ffffffff813b6000 ffffffff813b7000


Also, "xm list" takes very long to complete now:

$ time xm list sid
Name                  ID   Mem VCPUs      State   Time(s)
sid                  906   512     1     --p---     0.0
real    0m10.677s user    0m0.108s sys     0m0.028s


HTH,
Christian.
-- 
BOFH excuse #43:

boss forgot system password
