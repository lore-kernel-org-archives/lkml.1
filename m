Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYDZODV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYDZODV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYDZODO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:03:14 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:39453 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYDZODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:03:13 -0400
Date: Sat, 26 Apr 2008 16:02:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: mainline boot failures I: qemu
Message-ID: <20080426140210.GA13365@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Apr 2008 13:55:19.0626 (UTC) FILETIME=[2A01C2A0:01C8A7A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI

I see lots of boot failures on various setups with current mainline
(git8, b1721d0da266b4af8cb4419473b4ca36206ab200). Unfortunately 
they are all different. 

All with a defconfig kernel. Haven't investigated closely yet:

The only strange thing is that qemu says "Parsing ELF file". I assume
that's related to the new updated bzImage format? Perhaps it is related?

Here's the qemu failure:

xterm -e qemu-system-x86_64 -hda ... -kernel arch/x86/boot/bzImage -append "console=ttyS0 earlyprintk=serial"  -m 512 -nographic

...
ACPI: APIC 1FFF0938, 0040 (r0 QEMU   QEMUAPIC        1 QEMU        1)
No NUMA configuration found
Faking a node at 0000000000000000-000000001fff0000
Bootmem setup node 0 0000000000000000-000000001fff0000
  NODE_DATA [000000000000b000 - 0000000000011fff]
  bootmap [0000000000012000 -  0000000000015fff] pages 4
early res: 0 [0-fff] BIOS data page
PANIC: early exception 06 rip 10:ffffffff8083b23e error 0 cr2 0
Pid: 0, comm: swapper Not tainted 2.6.25-git8 #41

Call Trace:
 [<ffffffff8082c195>] early_idt_handler+0x55/0x69
 [<ffffffff8083b23e>] reserve_bootmem_generic+0x31/0xcc
 [<ffffffff80845194>] acpi_table_parse+0x4c/0x66
 [<ffffffff80833edb>] early_res_to_bootmem+0x43/0x52
 [<ffffffff80832816>] setup_arch+0x306/0x418
 [<ffffffff8082caa3>] start_kernel+0x6e/0x309
 [<ffffffff8082c3cf>] x86_64_start_kernel+0x1de/0x1e5

RIP 0x10


-Andi
