Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYGXOy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYGXOy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbYGXOwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:52:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:24730 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbYGXOwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a/ZiBCLURqrXGz5Vu2ty6YrGXxYbk22Pzc3bGciubC6Xf59mmFgxgxMAf5SffvVP/Z
         HbisVw/USzmxyWw7qi4+azSHAbaIqMBB/I7Lop6NGPdQ4CYlXFFM013jHj5oocNBM80b
         4dfYOgidYN3Hn9JaNwD2IBnWgFihQo0TKhFY0=
Message-ID: <b647ffbd0807240752r6edc73c1m6bf63a6124504365@mail.gmail.com>
Date: Thu, 24 Jul 2008 16:52:41 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: latest -git: kernel BUG at arch/x86/kernel/microcode.c:142!
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
       "Mike Travis" <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Gregory Haskins" <ghaskins@novell.com>, pj@sgi.com,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <19f34abd0807240702i349777e5y6f57c19c51dff60f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807240348n4c31e6el7358d3fc4d10e392@mail.gmail.com>
	 <19f34abd0807240702i349777e5y6f57c19c51dff60f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/24 Vegard Nossum <vegard.nossum@gmail.com>:
> On Thu, Jul 24, 2008 at 12:48 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Hi,
>>
>> I just got this when doing CPU hotplug:
>>
>> ------------[ cut here ]------------
>> kernel BUG at arch/x86/kernel/microcode.c:142!
>> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>
>> Pid: 4140, comm: bash Not tainted (2.6.26-06371-g338b9bb-dirty #14)
>> EIP: 0060:[<c0117f1e>] EFLAGS: 00210202 CPU: 0
>> EIP is at __mc_sysdev_add+0x1ee/0x200
>> EAX: 00000000 EBX: c1f61028 ECX: 01798000 EDX: c081ac80
>> ESI: 00000001 EDI: 00000001 EBP: f5bcbe24 ESP: f5bcbdcc
>>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> Process bash (pid: 4140, ti=f5bca000 task=f4066f90 task.ti=f5bca000)
>> Stack: 00000000 f5bcbe24 c028300b 00000001 000000d0 c06d8dc3 f73f77d0 00000000
>>       00000000 00000014 00000000 00000000 c0829254 f4f0fa00 f6e950f0 00200282
>>       f6d5180c 00000002 00000003 00000002 00000001 c1f61028 f5bcbe2c c0117f3a
>> Call Trace:
>>  [<c028300b>] ? kobject_uevent_env+0xdb/0x380
>>  [<c0117f3a>] ? mc_sysdev_add+0xa/0x10
>>  [<c05875fa>] ? mc_cpu_callback+0x1ea/0x240
>>  [<c014db67>] ? notifier_call_chain+0x37/0x70
>>  [<c014dbd9>] ? __raw_notifier_call_chain+0x19/0x20
>>  [<c014dbfa>] ? raw_notifier_call_chain+0x1a/0x20
>>  [<c0589477>] ? _cpu_up+0xa7/0x100
>>  [<c0589519>] ? cpu_up+0x49/0x80
>>  [<c056a3d8>] ? store_online+0x58/0x80
>>  [<c056a380>] ? store_online+0x0/0x80
>>  [<c02ff57c>] ? sysdev_store+0x2c/0x40
>>  [<c01de412>] ? sysfs_write_file+0xa2/0x100
>>  [<c01a0386>] ? vfs_write+0x96/0x130
>>  [<c01de370>] ? sysfs_write_file+0x0/0x100
>>  [<c01a08cd>] ? sys_write+0x3d/0x70
>>  [<c0103f5b>] ? sysenter_do_call+0x12/0x3f
>>  =======================
>> Code: 4d d8 c7 01 00 00 00 00 b8 00 1a 6f c0 e8 fb 46 47 00 8d 55 f0
>> 64 a1 00 90 7c c0 e8 0d 75 01 00 8b 45 d4 83 c4 4c 5b 5e 5f 5d c3 <0f>
>> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 31 d2
>> EIP: [<c0117f1e>] __mc_sysdev_add+0x1ee/0x200 SS:ESP 0068:f5bcbdcc
>> ---[ end trace 8c86c730d90bf362 ]---
>>
>> It's this one:
>>
>>        /* We should bind the task to the CPU */
>>        BUG_ON(raw_smp_processor_id() != cpu_num);
>>
>> Maybe related to recently merged per-cpu changes? (Yesterday's tests ran fine.)
>>
>> It seems 100% reproducible, so I'll start bisecting it.
>
> Ahha, after many hours of hitting various unrelated crashes,
> miscompiles, etc. I finally arrive at this commit:
>
> commit e761b7725234276a802322549cee5255305a0930
> Author: Max Krasnyansky <maxk@qualcomm.com>
> Date:   Tue Jul 15 04:43:49 2008 -0700

Yeah, there seems to be a funny situation here :-) I'd expect it to be
100% reproduceable with CONFIG_MICROCODE=y.

cpu_up() -> raw_notifier_call_chain(CPU_ONLINE, ...) ->

(microcode's part)

mc_cpu_callback() -> mc_sysdev_add() -> microcode_init_cpu()

and here we have:

        set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
        mutex_lock(&microcode_mutex);
        collect_cpu_info(cpu);

this code expects that after set_cpus_allowed_ptr() has been
completed, it will continue running on "cpu"

that's why BUG_ON(raw_smp_processor_id() != cpu_num);

the funny thing is that (1) it doesn't check for an error (otherwise
it would see an error)
and (2) cpu_active_map does _not_ yet have a bit for 'cpu' at this moment.

so migrate_task() will forward a migration request to migration_thread
(because 'current' is on-the-queue/running at this point and we can't
migrate it immediatelly -- current gets blocked inside migrate_task()
waiting for request's completion)

it all will end up in migration_thread() -> __migrate_task()
which does a test for cpu_active(dest_cpu) and bails out.

summary, with cpu_active_map as it's being used now this microcode's
scheme (the fact that it expects to be migrated onto 'cpu' while its
cpu_up(cpu) is not completely finished) doesn't work.

note, I've only taken a quick look so I don't make any judgements,
(good-bad)design-wise. But it's quite a funny use-case of
cpu-hotplug-notifications and CPU_ONLINE in particular :-)


-- 
Best regards,
Dmitry Adamushko
