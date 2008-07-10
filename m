Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYGJMu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYGJMu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYGJMuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:50:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:54908 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYGJMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=adQhggVwWB9U8PqTG1EBNrnWExxIHig7NX0i9Lf2t96wXnlDKIOZ8dBcT3TcwhSNFm
         vaVvqyV+CowvA4bS/hU68s7Y5SLxATKTEhuYfLUbucfHzkPkVcGtPflLVYemrNWFdJ/f
         52ccV46jpWRdUXIM9DeLO36Xi4LFwWsHV7Mus=
Message-ID: <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
Date: Thu, 10 Jul 2008 14:50:11 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/10 Vegard Nossum <vegard.nossum@gmail.com>:
> On Thu, Jul 10, 2008 at 1:59 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Hi,
>>
>> Looks like CPU hotplug still has some problems. Just got this on
>> latest mainline, and I couldn't find the exact same report on LKML
>> or kerneloops, maybe it can be helpful for debugging the existing
>> problem(s)?
>>
>> lockdep: fixing up alternatives.
>> ------------[ cut here ]------------
>> kernel BUG at kernel/sched.c:5858!
>> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>> Pid: 3934, comm: bash Not tainted (2.6.26-rc9-00057-g60d678c #3)
>> EIP: 0060:[<c057f7c5>] EFLAGS: 00210046 CPU: 0
>> EIP is at migration_call+0x495/0x4d0
>> EAX: 00000000 EBX: c0803f00 ECX: f6bd0000 EDX: 017b0000
>> ESI: e7d24fb0 EDI: c1fb3f00 EBP: f62e7e78 ESP: f62e7e48
>>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> Process bash (pid: 3934, ti=f62e6000 task=f60fbfc0 task.ti=f62e6000)
>> Stack: 00000000 c06ddf70 f62e7e6c 00200246 c0803f00 00000001 c1fb3f00 f62e7e6c
>>       c0581fcf c074ec70 ffffffff 00000000 f62e7e98 c014d5a7 00000001 00000007
>>       c074ecf4 ffffffff 00000001 e7c86f90 f62e7eac c014d619 ffffffff 00000000
>> Call Trace:
>>  [<c0581fcf>] ? preempt_schedule+0x3f/0x50
>>  [<c014d5a7>] ? notifier_call_chain+0x37/0x70
>>  [<c014d619>] ? __raw_notifier_call_chain+0x19/0x20
>>  [<c014d63a>] ? raw_notifier_call_chain+0x1a/0x20
>>  [<c055ff68>] ? _cpu_down+0x148/0x240
>>  [<c015da8f>] ? cpu_maps_update_begin+0xf/0x20
>>  [<c056008b>] ? cpu_down+0x2b/0x40
>>  [<c05612a9>] ? store_online+0x39/0x80
>>  [<c0561270>] ? store_online+0x0/0x80
>>  [<c02fba7b>] ? sysdev_store+0x2b/0x40
>>  [<c01dd0f2>] ? sysfs_write_file+0xa2/0x100
>>  [<c019ed76>] ? vfs_write+0x96/0x130
>>  [<c01dd050>] ? sysfs_write_file+0x0/0x100
>>  [<c019f43d>] ? sys_write+0x3d/0x70
>>  [<c0104ceb>] ? sysenter_past_esp+0x78/0xd1
>>  =======================
>> Code: 45 e8 e8 2f 53 00 00 b8 01 00 00 00 e9 a2 fb ff ff bb 60 36 59 c0 eb 02 8b
>>  1b 89 f8 ff 53 18 85 c0 89 c6 74 f3 90 e9 89 fe ff ff <0f> 0b eb fe 8d b4 26 00
>>  00 00 00 e8 8b 82 bd ff 89 f0 50 9d 0f
>> EIP: [<c057f7c5>] migration_call+0x495/0x4d0 SS:ESP 0068:f62e7e48
>>
>>
>> Oh, I just saw
>>
>> commit dc7fab8b3bb388c57c6c4a43ba68c8a32ca25204
>> Author: Dmitry Adamushko <dmitry.adamushko@gmail.com>
>> Date:   Thu Jul 10 00:32:40 2008 +0200
>>
>>   sched: fix cpu hotplug
>>
>> will apply and retry. Is this likely to fix the oops I saw, though?
>
> Nope, I get the same thing (just 2 lines offset):

No, it shouldn't fix this particular problem.

Does a patch from Miao Xie available via the link below makes this
problem disappear? Both bugs are likely to have the same cause.

http://lkml.org/lkml/2008/7/7/75


-- 
Best regards,
Dmitry Adamushko
