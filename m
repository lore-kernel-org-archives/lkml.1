Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYBQT30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYBQT30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYBQT3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:29:19 -0500
Received: from brick.kernel.dk ([87.55.233.238]:27304 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYBQT3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:29:18 -0500
Date: Sun, 17 Feb 2008 20:29:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1 softlockup  while bootup on powerpc
Message-ID: <20080217192913.GO23197@kernel.dk>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B67E5E.4010001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B67E5E.4010001@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16 2008, Kamalesh Babulal wrote:
> Hi,
> 
> The softlockup is seen from 2.6.25-rc1-git{1,3} and is visible in the 2.6.24-rc2 kernel,
> While booting up with the 2.6.25-rc1-git{1,3} and 2.6.25-rc2 kernel(s) on the powerbox
> 
> Loading st.ko module
> BUG: soft lockup - CPU#1 stuck for 61s! [insmod:379]
> NIP: c0000000001b0620 LR: c0000000001a5dcc CTR: 0000000000000040
> REGS: c00000077caab8a0 TRAP: 0901   Not tainted  (2.6.25-rc2-autotest)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 84004088  XER: 20000000
> TASK = c00000077cb450a0[379] 'insmod' THREAD: c00000077caa8000 CPU: 1
> GPR00: c00000077c9d4000 c00000077caabb20 c000000000538a40 000000000000000b 
> GPR04: ffc0000000000000 c00000077e0c0000 0000000000000036 000000000000000a 
> GPR08: 0040000000000000 c00000077c9d4250 c000000000000000 0000000000000000 
> GPR12: c00000077c9d4230 c000000000481d00 
> NIP [c0000000001b0620] .radix_tree_gang_lookup+0x100/0x1e4
> LR [c0000000001a5dcc] .call_for_each_cic+0x50/0x10c
> Call Trace:
> [c00000077caabb20] [c0000000001a5e2c] .call_for_each_cic+0xb0/0x10c (unreliable)
> [c00000077caabc60] [c00000000019dba4] .exit_io_context+0xf0/0x110
> [c00000077caabcf0] [c000000000061e38] .do_exit+0x820/0x850
> [c00000077caabda0] [c000000000061f34] .do_group_exit+0xcc/0xe8
> [c00000077caabe30] [c00000000000872c] syscall_exit+0x0/0x40
> Instruction dump:
> 7d296214 39290018 e8090000 7caa2038 39290008 2fa00000 409e0018 7caa4215 
> 396b0001 418200cc 424000b8 4bffffdc <79691f24> 7d296214 e9690018 2fab0000 

It's odd stuff. Could you perhaps try and add some printks to
block/cfq-iosched.c:call_for_each_cic(), like dumping the 'nr' return
from radix_tree_gang_lookup() and the pointer value of cics[i] in the
for() loop after the lookup?

How many SCSI devices are online?

-- 
Jens Axboe

