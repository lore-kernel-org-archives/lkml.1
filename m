Return-Path: <linux-kernel-owner+w=401wt.eu-S933557AbXHFPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbXHFPBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764288AbXHFPB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:01:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53217 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764289AbXHFPB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:01:26 -0400
Date: Mon, 6 Aug 2007 16:01:04 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: WARNING: check_irq_resend()
Message-ID: <20070806150104.GB3360@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While testing the latest kernel, I'm seeing the following warning.  Do
we really need this to WARN_ON_ONCE ?

scsi0 : PowerTec SCSI (QLogic FAS216) in slot 1 v1.10 (19/01/2003 2.5.59) terminators on
WARNING: at /home/rmk/git/linux-2.6-rmk/kernel/irq/resend.c:70 check_irq_resend()
[<c002b320>] (dump_stack+0x0/0x14) from [<c0061700>] (check_irq_resend+0x68/0x114)
[<c0061698>] (check_irq_resend+0x0/0x114) from [<c0060e54>] (enable_irq+0x88/0xc0)
 r6:00000062 r5:80000093 r4:c02a92f0
[<c0060dcc>] (enable_irq+0x0/0xc0) from [<c0031ad4>] (iomd_enable_dma+0xa8/0xb0) r5:c02bc5b8 r4:c04205ec
[<c0031a2c>] (iomd_enable_dma+0x0/0xb0) from [<c002bf64>] (enable_dma+0x4c/0x78) r7:00000001 r6:c04205dc r5:00000000 r4:c04205ec
[<c002bf18>] (enable_dma+0x0/0x78) from [<c016ecd0>] (powertecscsi_dma_setup+0x148/0x160)
[<c016eb88>] (powertecscsi_dma_setup+0x0/0x160) from [<c016fb38>] (fas216_transfer+0xc4/0x2d4)
[<c016fa74>] (fas216_transfer+0x0/0x2d4) from [<c0170ff0>] (fas216_intr+0x788/0x1018)
 r6:c042028c r5:c02cd138 r4:00000000
[<c0170868>] (fas216_intr+0x0/0x1018) from [<c016eb84>] (powertecscsi_intr+0x14/0x18)
[<c016eb70>] (powertecscsi_intr+0x0/0x18) from [<c0060b24>] (handle_IRQ_event+0x44/0x80)
[<c0060ae0>] (handle_IRQ_event+0x0/0x80) from [<c0061f28>] (handle_level_irq+0xac/0x100)
 r7:0000000d r6:00000001 r5:00000021 r4:c02a9600
[<c0061e7c>] (handle_level_irq+0x0/0x100) from [<c002cbf0>] (ecard_irq_handler+0xb8/0x190)
 r5:c02a91a0 r4:c02f6400
[<c002cb38>] (ecard_irq_handler+0x0/0x190) from [<c0026044>] (asm_do_IRQ+0x44/0x5c)
 r7:00000000 r6:c02c5a64 r5:0000000d r4:c02a91a0
[<c0026000>] (asm_do_IRQ+0x0/0x5c) from [<c0026d4c>] (__irq_svc+0x2c/0x80)
Exception stack(0xc02a3f5c to 0xc02a3fa4)
3f40:                                                                c03c4d40
3f60: 00746165 00000000 60000013 c0027ea8 c02a2000 c02a6d78 c0020f3c c02a6d7c
3f80: 4401a102 00000000 c02a3fb8 c02a3fa4 c02a3fa4 c0027ef0 c0027f50 60000013
3fa0: ffffffff
 r7:c0020f3c r6:00000020 r5:e0200000 r4:ffffffff
[<c0027f08>] (cpu_idle+0x0/0x64) from [<c0213c30>] (rest_init+0x58/0x68)
 r5:c02bbf08 r4:c02c40ac
[<c0213bd8>] (rest_init+0x0/0x68) from [<c0008afc>] (start_kernel+0x284/0x2ec)
[<c0008878>] (start_kernel+0x0/0x2ec) from [<10008034>] (0x10008034)
 r8:1001f00c r7:c02a5b3c r6:c0020f38 r5:c02bc3cc r4:1000517d

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
