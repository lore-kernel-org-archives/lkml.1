Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXDCHkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXDCHkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 03:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbXDCHkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 03:40:32 -0400
Received: from adsl-699.flex.com ([206.126.3.186]:53874 "EHLO
	recluce.bingner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbXDCHkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 03:40:31 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 03:40:30 EDT
From: "Sam" <sam@bingner.com>
To: <linux-kernel@vger.kernel.org>
References: <522043.87100.qm@web26011.mail.ukl.yahoo.com> <loom.20070402T173848-402@post.gmane.org>
Subject: Adding support for IDE on nCS5 on an ARM7
Date: Mon, 2 Apr 2007 23:26:54 -1000
Message-ID: <039001c775d2$38536580$6501a8c0@vm09bbecf2d921>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <loom.20070402T173848-402@post.gmane.org>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-index: Acd1vGfajz5p09vfR9aJIA0Hbw5LfgAEueUA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	I'm working on getting the IDE subsystem to communicate with an IDE device wired to nCS5 on a CLEP7312 board.  I have
0x50000000 set to be remapped to 0xfe100000 but whenever I try to access the registers I get kernel crashes.  I'm sure I'm doing
something wrong, since this works on a 2.6 kernel... but I don't know where to find what I'm doing wrong.

Could somebody perhaps let me know if they know what I'm doing wrong, or point me in the right direction of the relevant
documentation?

The error below is from trying to access as 32-bit wide blocks, same thing happens if I try to read it as an 8-bit block...

It also does the same thing if I don't do the mapping and try to access at the physical base address... but of course I shouldn't be
doing that anyways right?

Thanks,
Sam

Segfault:
-------------------------------------------------------------------------
IO_SYSCON1 = 0x000401C0
IO_SYSCON2 = 0x00040100
IO_SYSCON3 = 0x00040026
IO_MEMCFG1 = 0x00000080
IO_MEMCFG2 = 0xFFFDBD00

inb_ide(0xfe100007)
Unable to handle kernel paging request at virtual address fe100004
pgd = c0024000
[fe100004] *pgd=00000000
Internal error: Oops: e3c11005 [#1]
CPU: 0
PC is at ide_inb+0x70/0xe0
LR is at _spin_unlock_irqrestore+0x14/0x1c
pc : [<c012e668>]    lr : [<c014da10>]    Not tainted
sp : c01e1ef8  ip : 00000000  fp : c01e1f10
r10: c0036848  r9 : 60000013  r8 : 00000000
r7 : c01bc6a8  r6 : fe100007  r5 : c01bc698  r4 : 000088b7
r3 : fe100004  r2 : c018517c  r1 : c0176bf4  r0 : 00000017
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  Segment kernel
Control: 217B
Table: C0024017  DAC: 00000017
Process swapper (pid: 1, stack limit = 0xc01e0250)
Stack: (0xc01e1ef8 to 0xc01e2000)
1ee0:                                                       000088b7 c01bc698
1f00: c01bc698 c01e1f28 c01e1f14 c012fec8 c012e608 c01bce9c 00000003 c01e1f60                                                1f20:
c01e1f2c c013133c c012fea8 c01e1f58 00000006 c00c062c c01bce9c 00000003
1f40: c01e1f78 c0036d64 00000000 00000000 c0036848 c01e1f90 c01e1f64 c01324f0                                                  1f60:
c0131258 00000001 00000001 00000001 00000001 00000000 c003682c c01e0000
1f80: c0036d64 c01e1fa0 c01e1f94 c0035d38 c0132488 c01e1ff4 c01e1fa4 c0039100                                                  1fa0:
c0035d38 00000001 c0039e44 c0042f20 00000000 00000000 c0039058 c0049a34
1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000                                                  1fe0:
00000000 00000000 00000000 c01e1ff8 c0049a34 c0039068 82504000 60208006
Backtrace:
[<c012e5f8>] (ide_inb+0x0/0xe0) from [<c012fec8>] (ide_wait_not_busy+0x30/0x74)
 r6 = C01BC698  r5 = C01BC698  r4 = 000088B7
[<c012fe98>] (ide_wait_not_busy+0x0/0x74) from [<c013133c>] (probe_hwif+0xf4/0x7c0)
 r5 = 00000003  r4 = C01BCE9C
[<c0131248>] (probe_hwif+0x0/0x7c0) from [<c01324f0>] (ideprobe_init+0x78/0x160)
[<c0132478>] (ideprobe_init+0x0/0x160) from [<c0035d38>] (ide_generic_init+0x10/0x1c)                                           r7 =
C0036D64  r6 = C01E0000  r5 = C003682C  r4 = 00000000
[<c0035d28>] (ide_generic_init+0x0/0x1c) from [<c0039100>] (init+0xa8/0x274)
[<c0039058>] (init+0x0/0x274) from [<c0049a34>] (do_exit+0x0/0x770)
Code: e1a01006 e59f006c ebfc66c7 e3c63003 (e5934000)
 <0>Kernel panic - not syncing: Attempted to kill init!
-------------------------------------------------------------------------
#define EP7312_PHYS_IDE         CS5_PHYS_BASE
#define EP7312_VIRT_IDE         (0xfe100000)
-------------------------------------------------------------------------
Mapping line:
static struct map_desc edb7211_io_desc[] __initdata = {
        {       /* Phatnoise IDE */
                .virtual        = EP7312_VIRT_IDE,
                .pfn            = __phys_to_pfn(EP7312_PHYS_IDE),
                .length         = SZ_1M,
                .type           = MT_DEVICE,
        },
};

Machine definition:
-------------------------------------------------------------------------
MACHINE_START(CLEP7212, "Cirrus Logic 7212/7312")
        /* Maintainer: Nobody */
        .phys_io        = 0x80000000,
        .io_pg_offst    = ((0xff000000) >> 18) & 0xfffc,
        .boot_params    = 0xc0000100,
        .fixup          = fixup_clep7312,
        .map_io         = clps711x_map_io,
        .init_irq       = clps711x_init_irq,
        .timer          = &clps711x_timer,
MACHINE_END


