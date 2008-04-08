Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYDHX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYDHX0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYDHX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 19:26:38 -0400
Received: from ozlabs.org ([203.10.76.45]:60794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbYDHX0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 19:26:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18427.65299.403151.344959@cargo.ozlabs.ibm.com>
Date: Wed, 9 Apr 2008 09:26:11 +1000
From: Paul Mackerras <paulus@samba.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, nacc@us.ibm.com
Subject: Re: [BUG] 2.6.25-rc2-git4 - Regression Kernel oops  while running
 kernbench and tbench on powerpc
In-Reply-To: <47FB5C5A.5020104@linux.vnet.ibm.com>
References: <47BC40BC.3040405@linux.vnet.ibm.com>
	<18427.11023.8067.795279@cargo.ozlabs.ibm.com>
	<47FB5C5A.5020104@linux.vnet.ibm.com>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal writes:

> The kernel oops after applying the patch. Some time it takes more than
> one run to reproduce it, it was reproducible in the second run this
> time.
> 
>  Unrecoverable exception 4100 at c000000000008c8c
> Oops: Unrecoverable exception, sig: 6 [#1]
> SMP NR_CPUS=128 NUMA pSeries
> Modules linked in:
> NIP: c000000000008c8c LR: 000000000ff0135c CTR: 000000000ff012f0
> REGS: c000000772343bb0 TRAP: 4100   Not tainted  (2.6.25-rc8-autotest)
> MSR: 8000000000001030 <ME,IR,DR>  CR: 44044228  XER: 00000000
> TASK = c00000077cfa0900[13437] 'cc1' THREAD: c000000772340000 CPU: 2
> GPR00: 0000000000004000 c000000772343e30 00000000000000bb 000000000000d032 
> GPR04: 00000000000000bb 0000000000000400 000000000000000a 0000000000000002 
> GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
> GPR12: 0000000000000000 c000000000734000 0000000000000064 00000000ffe6df08 
> GPR16: 00000000105b0000 00000000105b0000 0000000010440000 00000000105b0000 
> GPR20: 00000000ffe6e008 00000000105b0000 00000000105b0000 000000000000000a 
> GPR24: 000000000ffec408 0000000000000001 00000000ffe6ddca 0000000000000400 
> GPR28: 000000000ffec408 00000000f7ff8000 000000000ffebff4 0000000000000400 
> NIP [c000000000008c8c] restore+0x8c/0xc0
> LR [000000000ff0135c] 0xff0135c
> Call Trace:
> [c000000772343e30] [c000000000008cd4] do_work+0x14/0x2c (unreliable)
> Instruction dump:
> 7c840078 7c810164 70604000 41820028 60000000 7c4c42e6 e88d01f0 f84d01f0 
> 7c841050 e84d01e8 7c422214 f84d01e8 <e9a100d8> 7c7b03a6 e84101a0 7c4ff120 

That looks like the bug that was supposed to be fixed by commit
44387e9ff25267c78a99229aca55ed750e9174c7, which is in 2.6.25-rc7 and
later.  

What was the SHA1 ID of the head commit for the kernel source that
gave you this oops?  Did you have any other patches besides the one I
sent you applied?

Paul.
