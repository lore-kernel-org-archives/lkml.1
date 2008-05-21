Return-Path: <linux-kernel-owner+w=401wt.eu-S935057AbYEUM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935057AbYEUM4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbYEUM4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:56:34 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:50896 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322AbYEUM4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:56:32 -0400
Date: Wed, 21 May 2008 14:55:46 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [BUG] cpu hotplug vs scheduler
Message-ID: <20080521125546.GE9441@osiris.boeblingen.de.ibm.com>
References: <4829A6A0.5040208@qumranet.com> <b647ffbd0805140113i4296076cna3f371c86c479653@mail.gmail.com> <482ADB69.8010305@qumranet.com> <b647ffbd0805140605j5ed43b73t557983ece879c552@mail.gmail.com> <482C0E35.9000708@qumranet.com> <20080521123116.GC9441@osiris.boeblingen.de.ibm.com> <483418CB.7070602@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483418CB.7070602@qumranet.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 03:42:51PM +0300, Avi Kivity wrote:
> Heiko Carstens wrote:
>> I think you fixed this specific bug. Does cpu hotplug stresstest now work
>> for you?
>
> Which bug, the order-2 allocs?  I certainly didn't fix it.
>
> Last I tried, cpu hotplug still failed, but it was some time ago as  
> patches flow.

Ah no. I thought "x86: fix crash on cpu hotplug on pat-incapable machines"
would have fixed the cpu hotplug bug for you.

I was actually talking of the pick_next_task_fair incarnation of one of
the cpu hotplug bugs.

s390 backtrace on 2.6.25 looks like this.

    <1>Unable to handle kernel pointer dereference at virtual kernel address 00000200000db000
    <4>Oops: 003b [#1] PREEMPT SMP 
    <4>Modules linked in: dm_multipath sunrpc qeth_l2 dm_mod cu3088 qeth ccwgroup
    <4>CPU: 0 Not tainted 2.6.25-27.x.20080422-s390xdefault #1
    <4>Process migration/0 (pid: 5806, task: 00000000aac3a838, ksp: 000000017a2f3dd0)
    <4>Krnl PSW : 0400200180000000 0000000000125f48 (pick_next_task_fair+0x34/0xd4)
    <4>           R:0 T:1 IO:0 EX:0 Key:0 M:0 W:0 P:0 AS:0 CC:2 PM:0 EA:3
    <4>Krnl GPRS: 0000079e029c6ecb 0000000000000000 000000008548ea60 000000008548d700
    <4>           00000000004526f8 0000000000000597 0000000000000000 0000000000000000
    <4>           0000000000672a00 0000000000000000 00000000aac3a838 000000017a2f3d10
    <4>           00000200000db85a 00000000004672a0 000000017a2f3d50 000000017a2f3d10
    <4>Krnl Code: 0000000000125f38: e3e0f0980024        stg     %r14,152(%r15)
    <4>           0000000000125f3e: d507d000c010        clc     0(8,%r13),16(%r12)
    <4>           0000000000125f44: a784004e            brc     8,125fe0
    <4>          >0000000000125f48: d507d000c030        clc     0(8,%r13),48(%r12)
    <4>           0000000000125f4e: b904002c            lgr     %r2,%r12
    <4>           0000000000125f52: a7990000            lghi    %r9,0
    <4>           0000000000125f56: a7840033            brc     8,125fbc
    <4>           0000000000125f5a: c0e5ffffee23        brasl   %r14,123ba0
    <4>Call Trace:
    <4>([<00000000aac3a838>] 0xaac3a838)
    <4> [<000000000045270c>] schedule+0x178/0x978
    <4> [<000000000012fe86>] migration_thread+0x1aa/0x30c
    <4> [<0000000000152ad8>] kthread+0x68/0xa0
    <4> [<000000000010a0be>] kernel_thread_starter+0x6/0xc
    <4> [<000000000010a0b8>] kernel_thread_starter+0x0/0xc
    <4>Last Breaking-Event-Address:
    <4> [<0000000000125fc6>] pick_next_task_fair+0xb2/0xd4
