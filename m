Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbYBTPBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbYBTPBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbYBTPB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:01:28 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37927 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379AbYBTPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:01:25 -0500
Message-ID: <47BC40BC.3040405@linux.vnet.ibm.com>
Date: Wed, 20 Feb 2008 20:31:16 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops  while running kernbench
 and tbench on powerpc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Kernel oopses is seen while running the kernbench followed by tbench with 2.6.25-rc2-git4 
kernel on powerpc, this oops was reported for the 2.6.24-rc8-mm1 kernel (http://lkml.org/lkml/2008/1/18/71)
and is visible with almost all of the main line ,rc(s) and their git(s) release from then.

This oops is visible in the linux-next-20080220 kernel also.The machine is power4+ box with four cpus and 
has 30 GB RAM.

oops while running kernbench
-----------------------------

 Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: 0000000000004570 LR: 000000000ff0135c CTR: 000000000ff012f0
REGS: c000000771a678c0 TRAP: 0300   Not tainted  (2.6.25-rc2-autotest-next-20080220)
MSR: 8000000000001000 <ME>  CR: 28000282  XER: 00000000
DAR: c000000771a67ce0, DSISR: 000000000a000000
TASK = c00000077b9d2c00[22046] 'cc1' THREAD: c000000771a64000 CPU: 3
GPR00: 0000000000004000 c000000771a67b40 0000000000000052 000000000000d032 
GPR04: 0000000000000052 0000000000000400 00000000106823e0 000000000000000e 
GPR08: 0000000000000000 0000000044000288 c000000771a67e30 0000998be2321500 
GPR12: 8000000000001030 c0000000005d7e00 0000000010030000 0000000010030000 
GPR16: 00000000105b0000 00000000105b0000 0000000010440000 00000000105b0000 
GPR20: 00000000105b0000 00000000105b0000 00000000105b0000 00000000105b0000 
GPR24: 00000000105b41e8 0000000000000020 00000000105b0000 0000000000000400 
GPR28: 000000000ffec408 00000000f7ff8000 000000000ffebff4 0000000000000400 
NIP [0000000000004570] 0x4570
LR [000000000ff0135c] 0xff0135c
Call Trace:
[c000000771a67b40] [c00000000062d558] 0xc00000000062d558 (unreliable)
[c000000771a67e08] [00000000f7ff8000] 0xf7ff8000
Instruction dump:
48000000 XXXXXXXX XXXXXXXX XXXXXXXX 41820008 XXXXXXXX XXXXXXXX XXXXXXXX 
48000010 XXXXXXXX XXXXXXXX XXXXXXXX f92101a0 XXXXXXXX XXXXXXXX XXXXXXXX 
---[ end trace 26a7439b76b3cbab ]---

oops while running tbench
--------------------------

Unable to handle kernel paging request for data at address 0xc00000077e2e3ce0
Faulting instruction address: 0x00004570
Oops: Kernel access of bad area, sig: 11 [#2]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: 0000000000004570 LR: c00000000000872c CTR: 0000000000000000
REGS: c00000077e2e38c0 TRAP: 0300   Tainted: G      D   (2.6.25-rc2-autotest-next-20080220)
MSR: 8000000000001000 <ME>  CR: 28022822  XER: 20000000
DAR: c00000077e2e3ce0, DSISR: 000000000a000000
TASK = c00000077cb55800[3900] 'zmd' THREAD: c00000077e2e0000 CPU: 3
GPR00: 0000000000000000 c00000077e2e3b40 c0000000006a29b8 000000000000006e 
GPR04: 000000000fe7bac8 0000000054022888 0000000000004000 000000000fe7bae4 
GPR08: 000000000000d032 0000000044022824 c00000077e2e3e30 0000998be2321500 
GPR12: 8000000000001030 c0000000005d7e00 0000000000000001 0000000000000000 
GPR16: 0000000000000000 00000000f7c16708 00000000f7fa0800 00000000100e0040 
GPR20: 00000000f7ffe018 0000000000000001 00000000f5397550 00000000f5397548 
GPR24: 0000000000000000 0000000000004a19 00000000f7d66474 00000000f53975a8 
GPR28: 0000000000000000 0000000000009433 000000000fe94ff4 00000000f7d66490 
NIP [0000000000004570] 0x4570
LR [c00000000000872c] syscall_exit+0x0/0x40
Call Trace:
[c00000077e2e3b40] [00000496000729b8] 0x496000729b8 (unreliable)
Instruction dump:
48000000 XXXXXXXX XXXXXXXX XXXXXXXX 41820008 XXXXXXXX XXXXXXXX XXXXXXXX 
48000010 XXXXXXXX XXXXXXXX XXXXXXXX f92101a0 XXXXXXXX XXXXXXXX XXXXXXXX 

The machine 
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
