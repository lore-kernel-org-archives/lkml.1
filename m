Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbYAYBpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbYAYBpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYAYBpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:45:01 -0500
Received: from gw.goop.org ([64.81.55.164]:43466 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYAYBpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:45:00 -0500
Message-ID: <47993F1A.5070408@goop.org>
Date: Thu, 24 Jan 2008 17:44:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86.git: mtrr trimming removes all memory under kvm
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting a current x86.git kernel under kvm, I get this:

(qemu) Linux version 2.6.24-rc8 (jeremy@ezr) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1928 SMP PREEMPT Thu Jan 24 17:09:04 PST 2008
early_ioremap_init()
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
console [earlyser0] enabled
0MB HIGHMEM available.
511MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
Scan SMP from c009fc00 for 1024 bytes.
***************
**** WARNING: likely BIOS bug
**** MTRRs don't cover all of memory, trimmed 131056 pages
***************
update e820 for mtrr
modified physical RAM map:
 modified: 0000000000000000 - 000000001fff0000 (reserved)
 modified: 000000001fff0000 - 0000000020000000 (ACPI data)
 modified: 00000000fffc0000 - 0000000100000000 (reserved)
highmem size specified (0MB) is bigger than pages available (0MB)!.
0MB HIGHMEM available.
0MB LOWMEM available.
BUG: Int 6: CR2 00000000
     EDI c055de40  ESI c04f7bec  EBP c04cff68  ESP c04cff4c
     EBX 00100000  EDX 00000006  ECX 0047efff  EAX 00000100
     err 00000000  EIP c04e5c7d   CS 00000060  flg 00010006
Stack: 00000000 c04f7bec c051eb0c c04cff70 c04e5cd1 c04cff80 c04da360 00000010
       c04f7bec c04cff98 c04da4e5 c042ac8d 00000000 c042ac70 00000000 c04cffd0
       c04da7c0 c04cffe8 c04cb680 c051e920 c051e8e0 00000800 00099800 c04c1000
��Pid: 0, comm: swapper Not tainted 2.6.24-rc8 #1928
 [<c04e5c7d>] ? reserve_bootmem_core+0x1e/0x61
 [<c04e5cd1>] ? reserve_bootmem+0x11/0x13
 [<c04da360>] ? setup_bootmem_allocator+0x42/0x141
 [<c04da4e5>] ? setup_memory+0x86/0x8d
 [<c04da7c0>] ? setup_arch+0x28c/0x3c2
 [<c0128f4a>] ? printk+0x15/0x17
 [<c04d4689>] ? start_kernel+0x60/0x311
 =======================



I can well believe this is a qemu bug, but it used to work fine, so this 
is a regression.

    J
