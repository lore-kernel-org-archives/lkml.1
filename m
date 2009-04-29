Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbZD2Q0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbZD2Q0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZD2Q0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:26:23 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49398 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZD2Q0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:26:20 -0400
Message-ID: <49F87FAB.9050408@in.ibm.com>
Date: Wed, 29 Apr 2009 21:56:19 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com> <20090429113604.GE3398@wotan.suse.de>
In-Reply-To: <20090429113604.GE3398@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Does this help?
> ---
With the patch the machine boots past the failure point, but panics
immediately with the following trace...

Unable to handle kernel paging request for data at address 0x00000010
Faulting instruction address: 0xc0000000007d03ec
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 DEBUG_PAGEALLOC NUMA pSeries
Modules linked in:
NIP: c0000000007d03ec LR: c0000000007b0bbc CTR: 0000000000136f8c
REGS: c000000000a23bd0 TRAP: 0300   Not tainted  (2.6.30-rc3-next-20090429)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28000084  XER: 00000010
DAR: 0000000000000010, DSISR: 0000000040000000
TASK = c000000000955fc0[0] 'swapper' THREAD: c000000000a20000 CPU: 0
GPR00: 0000000000000001 c000000000a23e50 c000000000a17650 000000000000001f
GPR04: 0000000000000000 ffffffffffffffff 000000000077a4b9 800000000c9b2cc0
GPR08: 0000000000000000 0000000000000010 0000000000000000 c00000000095b0f8
GPR12: 0000000028000082 c000000000af2400 c0000000007f3200 c000000000705c32
GPR16: 00000000014f3138 0000000000000000 c0000000007f3138 0000000002f1fc90
GPR20: c0000000007f3150 c000000000725d11 00000000007bb8e4 0000000002f1fc90
GPR24: 0000000002f1fc90 c0000000007f31f0 0000000000d00000 c000000000b73b10
GPR28: c0000000007f0440 c00000000095db00 c00000000098d5f0 0000000003c90000
NIP [c0000000007d03ec] .pidmap_init+0x28/0x88
LR [c0000000007b0bbc] .start_kernel+0x458/0x51c
Call Trace:
[c000000000a23e50] [c000000000a23ee0] init_thread_union+0x3ee0/0x4000 
(unreliable)
[c000000000a23ee0] [c0000000007b0bbc] .start_kernel+0x458/0x51c
[c000000000a23f90] [c0000000000083d8] .start_here_common+0x1c/0x44
Instruction dump:
ebc1fff0 4e800020 fbc1fff0 ebc2b1a8 39200010 7c0802a6 fba1ffe8 f8010010
38000001 ebbe8008 f821ff71 f93d0010 <7d6048a8> 7d6b0378 7d6049ad 40c2fff4
---[ end trace 31fd0ba7d8756001 ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Call Trace:
[c000000000a23820] [c000000000011700] .show_stack+0x6c/0x16c (unreliable)
[c000000000a238d0] [c000000000561f1c] .panic+0x80/0x1a8
[c000000000a23960] [c00000000008dfa4] .do_exit+0x98/0x73c
[c000000000a23a40] [c0000000000293f4] .die+0x280/0x284
[c000000000a23ae0] [c000000000032700] .bad_page_fault+0xb8/0xd4
[c000000000a23b60] [c000000000005798] handle_page_fault+0x3c/0x5c
--- Exception: 300 at .pidmap_init+0x28/0x88
    LR = .start_kernel+0x458/0x51c
[c000000000a23e50] [c000000000a23ee0] init_thread_union+0x3ee0/0x4000 
(unreliable)
[c000000000a23ee0] [c0000000007b0bbc] .start_kernel+0x458/0x51c
[c000000000a23f90] [c0000000000083d8] .start_here_common+0x1c/0x44
Rebooting in 180 seconds..

The page size is 64K. Config DEBUG_PAGEALLOC is enabled. Let me know
if i can provide any more information.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

