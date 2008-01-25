Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbYAYGF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbYAYGF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 01:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYAYGFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 01:05:19 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:40863 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751295AbYAYGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 01:05:18 -0500
Message-ID: <47997C19.7080309@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2008 11:35:13 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24 Kernel oops will running kernbench regression from 2.6.24-rc8-mm1
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <479064F0.7040305@linux.vnet.ibm.com> <20080118004416.6a757169.akpm@linux-foundation.org> <18320.27372.202771.764301@cargo.ozlabs.ibm.com> <479072BC.3080908@linux.vnet.ibm.com> <18320.32464.634534.415458@cargo.ozlabs.ibm.com>
In-Reply-To: <18320.32464.634534.415458@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Kamalesh Babulal writes:
> 
>>>>> NIP: 0000000000004570 LR: 000000000fc42dc0 CTR: 0000000000000000
>>>>> REGS: c00000077b6bf8c0 TRAP: 0300   Not tainted  (2.6.24-rc8-mm1-autotest)
>>>>> MSR: 8000000000001000 <ME>  CR: 28022422  XER: 00000000
>>>>> DAR: c00000077b6bfce0, DSISR: 000000000a000000
> 
> Actually, how much RAM does this machine have?  If it has less than
> 32GB, then the problem is that the kernel stack pointer is bogus.
> (How it got to be bogus is the interesting question, of course. :)
> 
> Paul.
> 
Hi Paul,

This kernel oops in seen in 2.6.24-rc8-git(2,3,4,5,7,8) and the 2.6.24.

 Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: 0000000000004570 LR: 000000001030e594 CTR: 000000001012ddd0
REGS: c000000771f9f8c0 TRAP: 0300   Not tainted  (2.6.24-autotest)
MSR: 8000000000001000 <ME>  CR: 28000482  XER: 20000000
DAR: c000000771f9fce0, DSISR: 000000000a000000
TASK = c00000077b9c6000[19197] 'cc1' THREAD: c000000771f9c000 CPU: 2
GPR00: 0000000000000064 c000000771f9fb40 00000000f7fdb470 0000000000000000 
GPR04: 0000000000000002 0000000000000000 0000000000782498 00000000003ff3ff 
GPR08: 00000000aaaaaaab 0000000040000484 c000000771f9fe30 0000998be2321500 
GPR12: 8000000000003030 c0000000005c5680 0000000010030000 0000000010030000 
GPR16: 00000000105b0000 00000000105b0000 0000000010440000 00000000105b0000 
GPR20: 00000000105b0000 00000000105f0000 0000000000000000 00000000ffd00b44 
GPR24: 00000000105b0000 00000000105b0000 00000000105b0000 00000000105b0000 
GPR28: 00000000105b0000 0000000010604684 0000000000000100 00000000105f75a8 
NIP [0000000000004570] 0x4570
LR [000000001030e594] 0x1030e594
Call Trace:
[c000000771f9fb40] [c000000771f9fcf0] 0xc000000771f9fcf0 (unreliable)
Instruction dump:
48000000 XXXXXXXX XXXXXXXX XXXXXXXX 41820008 XXXXXXXX XXXXXXXX XXXXXXXX 
48000010 XXXXXXXX XXXXXXXX XXXXXXXX f92101a0 XXXXXXXX XXXXXXXX XXXXXXXX 
---[ end trace a8c779b801674eed ]---
-- 0:conmux-control -- time-stamp -- Jan/24/08 16:40:29 --
-- 0:conmux-control -- time-stamp -- Jan/24/08 16:47:56 --
Unable to handle kernel paging request for data at address 0xc00000077168f870
Faulting instruction address: 0x00004570
Oops: Kernel access of bad area, sig: 11 [#2]
SMP NR_CPUS=32 NUMA pSeries
Modules linked in:
NIP: 0000000000004570 LR: c00000000004a310 CTR: 0000000000000000
REGS: c00000077168f450 TRAP: 0300   Tainted: G      D  (2.6.24-autotest)
MSR: 8000000000001000 <ME>  CR: 28000242  XER: 00000000
DAR: c00000077168f870, DSISR: 000000000a000000
TASK = c000000771fdb170[24200] 'tbench' THREAD: c00000077168c000 CPU: 1
GPR00: 0000000000000000 c00000077168f6d0 c00000000068bc30 8000000000009032 
GPR04: 8000000000001030 000000000000025a 0000000042000222 c00000000000ee64 
GPR08: c00000077168fae0 0000000028000242 c00000077168f9c0 0000998be2321500 
GPR12: 8000000000001030 c0000000005c5480 0000000000000000 0000000000000000 
GPR16: 00000000100a0000 00000000100a8b10 00000000100a0000 0000000010000000 
GPR20: 0000000000005e84 c000000000008cd4 c00000077168c000 c000000771fdb390 
GPR24: 0000000000000001 00000000ff9ce668 00000000ff9cec5c c000000771fdb170 
GPR28: 0000000000000001 c00000077ca7cba0 c000000000615938 0000000000000000 
NIP [0000000000004570] 0x4570
LR [c00000000004a310] .finish_task_switch+0x54/0xe8
Call Trace:
[c00000077168f6d0] [c00000077168f790] 0xc00000077168f790 (unreliable)
Instruction dump:
48000000 XXXXXXXX XXXXXXXX XXXXXXXX 41820008 XXXXXXXX XXXXXXXX XXXXXXXX 
48000010 XXXXXXXX XXXXXXXX XXXXXXXX f92101a0 XXXXXXXX XXXXXXXX XXXXXXXX 

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
