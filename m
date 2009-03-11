Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZCKEQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZCKEQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZCKEQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:16:31 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55648 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZCKEQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:16:30 -0400
Message-ID: <49B73B15.3040101@in.ibm.com>
Date: Wed, 11 Mar 2009 09:46:21 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-next@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, tj@kernel.org
Subject: Re: Next 10: Badness at mm/allocpercpu.c:123
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au> <49B67552.5070307@in.ibm.com>
In-Reply-To: <49B67552.5070307@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin P. Sant wrote:
> While booting Next 20090310 on a powerpc box (Power6 9117-MMA)
> i observed the following badness :
>
> [    0.339662] ------------[ cut here ]------------
> [    0.339666] Badness at mm/allocpercpu.c:123
> [    0.339670] NIP: c0000000001129dc LR: c0000000001129b8 CTR: 
> 0000000000000000
> [    0.339676] REGS: c0000000fe1efa10 TRAP: 0700   Not tainted  
> (2.6.29-rc7-next-20090310)
> [    0.339681] MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000024  
> XER: 20000002
> [    0.339695] TASK = c0000000fe1dd3d0[1] 'swapper' THREAD: 
> c0000000fe1ec000 CPU: 0
> [    0.339701] GPR00: 0000000000000001 c0000000fe1efc90 
> c000000000948660 c0000000fe019000
> [    0.339711] GPR04: 0000000000000000 0000000000000000 
> c0000000fe019080 c00000000122e980
> [    0.339721] GPR08: 0000000000000000 c000000001467dec 
> c0000000fe0e2610 c0000000fe1dd3d0
> [    0.339732] GPR12: 0000000044000022 c000000000a22300 
> c000000000733ad0 c00000000065e0c5
> [    0.339742] GPR16: 0000000003c33a08 0000000000000000 
> c000000000733a08 0000000002f1fc90
> [    0.339752] GPR20: c000000000733a20 c000000000679b30 
> 0000000000000000 0000000002f1fc90
> [    0.339763] GPR24: 0000000000000000 0000000000000000 
> c000000000670ccd 0000000000000001
> [    0.339773] GPR28: c0000000fe019000 0000000000000080 
> c0000000008cb908 0000000000000100
> [    0.339788] NIP [c0000000001129dc] .__alloc_percpu+0x7c/0x244
> [    0.339793] LR [c0000000001129b8] .__alloc_percpu+0x58/0x244
> [    0.339798] Call Trace:
> [    0.339801] [c0000000fe1efc90] [c0000000001129b8] 
> .__alloc_percpu+0x58/0x244 (unreliable)
> [    0.339810] [c0000000fe1efdc0] [c00000000007ce84] 
> .__create_workqueue_key+0x74/0x2a0
> [    0.339819] [c0000000fe1efe70] [c000000000716990] 
> .cpuset_init_smp+0x78/0xa4
> [    0.339827] [c0000000fe1eff00] [c000000000700334] 
> .kernel_init+0x16c/0x224
> [    0.339834] [c0000000fe1eff90] [c00000000002adc8] 
> .kernel_thread+0x54/0x70
> [    0.339839] Instruction dump:
> [    0.339843] 3863007f 78630624 4bffb94d 60000000 2bbd0008 7c7c1b78 
> 40fd0030 e93e8010
> [    0.339856] 80090000 7c000034 5400d97e 78000020 <0b000000> 2fa00000 
> 41fe0010 e93e8010
>
> I have attached the dmesg log here.
>
> Next 20090306 had the same problem, while 20090305 did not.
I see that this WARN_ON was introduced by the following patch from Tejun.

http://lkml.org/lkml/2009/2/18/56

Should i be worried about this warning ?

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

