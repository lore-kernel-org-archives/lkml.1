Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYH3Pyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYH3Pyx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYH3Pyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:54:43 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:28842 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYH3Pym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lx+BK4Mqg5PC2WxHB6v0uK2iuhvrVCpdkS1CkZCKol6OsgeflsYGOa0wfjAbCUejQJ
         jvAGls1lnMU++qPD/lq4c0e6c2Zfvu4tsp1iVC89kN8PuiA2EtCzFY4cj9+DKSgWEnZn
         uI9IeAJNij4JA/aQDSKnvr88as3obIrBUPI3U=
Message-ID: <19f34abd0808300854t33db98b2l37d35c08297e59d0@mail.gmail.com>
Date: Sat, 30 Aug 2008 17:54:40 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Thomas Backlund" <tmb@mandriva.org>
Subject: Re: BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808300830q25cef20chf5f905af210198c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B94120.1010108@mandriva.org>
	 <19f34abd0808300830q25cef20chf5f905af210198c4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 5:30 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sat, Aug 30, 2008 at 2:46 PM, Thomas Backlund <tmb@mandriva.org> wrote:
>> Hi, (please cc me as I'm not subscribed)
>>
>> thought I would post this right now, I'll try to reproduce it with vanilla
>> 2.6.27-rc5 as soon as the buildhost is back up...
>>
>> (vanilla 2.6.27-rc5 x86_64 also locked up my laptop wich is a
>>  Core2 Duo T8300 during kernel build with make -j3, but
>>  I dont have any logs of that yet)
>>
>> Kernel: 2.6.27-rc5 + Mandriva patches
>> Config:
>> http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel/branches/rebase-to-2.6.27/PATCHES/configs/x86_64.config?revision=276760&view=markup
>> Arch: x86_64
>>
>> System: Intel Quad Core Q9300
>>
>> getting this with netconsole while building kernel rpms with make -j5:
>
> Hi,
>
> I tried your recipe. Well, not exactly. But I also got this during a
> kernel build. Notice that the kernel version is a clean v2.6.27-rc5
> (i.e. latest Linus -git):
>
> BUG: soft lockup - CPU#1 stuck for 61s! [swapper:0]
> irq event stamp: 3585444
> hardirqs last  enabled at (3585443): [<c015927b>] trace_hardirqs_on+0xb/0x10
> hardirqs last disabled at (3585444): [<c0290614>] trace_hardirqs_off_thunk+0xc/8
> softirqs last  enabled at (3585438): [<c0139fb1>] __do_softirq+0xe1/0x100
> softirqs last disabled at (3585427): [<c013a075>] do_softirq+0xa5/0xb0
>
> Pid: 0, comm: swapper Not tainted (2.6.27-rc5-00006-gbef69ea #3)
> EIP: 0060:[<c011eb55>] EFLAGS: 00000202 CPU: 1
> EIP is at native_safe_halt+0x5/0x10
> EAX: 0036b5a3 EBX: c2161b80 ECX: 00000000 EDX: 00000000
> ESI: 00000001 EDI: c090fb80 EBP: f7855f80 ESP: f7855f80
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: 0807a0b0 CR3: 3695d000 CR4: 000006d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c010ad80>] default_idle+0x50/0x70
>  [<c01029c8>] cpu_idle+0x68/0x130
>  [<c059e120>] start_secondary+0x160/0x1c0
>  =======================
>
> c011eb50 <native_safe_halt>:
> c011eb50:       55                      push   %ebp
> c011eb51:       89 e5                   mov    %esp,%ebp
> c011eb53:       fb                      sti
> c011eb54:       f4                      hlt
> c011eb55:       5d                      pop    %ebp
> c011eb56:       c3                      ret
> c011eb57:       89 f6                   mov    %esi,%esi
> c011eb59:       8d bc 27 00 00 00 00    lea    0x0(%edi),%edi
>
> ...there's not many clues here as to what went wrong. Curious.
>
> (Yes, I played with CPU hotplug and hibernate as well.)

Ok, mine is definitely because of hotplug. The issue you are seeing is
probably more important, though, sorry for hijacking your thread. You
should be able to do the SysRq thing as well, though. SysRq-w (dump
blocked tasks) and SysRq-d (held locks) here:

SysRq : Show Blocked State
  task                PC stack   pid father
bash          D d450a1ee  5912  3772   3720
       f68e1df4 00200046 2fb00387 d450a1ee 2fb00387 00000004 f68e1df0 c015aa4a
       c2036d80 f7830cc0 1e881e2a 000000bc f67d72c0 f67d7534 c2036d80 f68e0000
       f86e8552 00000000 6db5f2ce 00000000 f86e8552 f67d781c f67d72c0 c0d1dcf4
Call Trace:
 [<c015aa4a>] ? __lock_acquire+0x27a/0xa00
 [<c05a1a38>] schedule_timeout+0x78/0xc0
 [<c015904f>] ? mark_held_locks+0x6f/0x90
 [<c015927b>] ? trace_hardirqs_on+0xb/0x10
 [<c01591e4>] ? trace_hardirqs_on_caller+0xd4/0x160
 [<c015927b>] ? trace_hardirqs_on+0xb/0x10
 [<c05a0e33>] wait_for_common+0xb3/0x130
 [<c012c860>] ? default_wake_function+0x0/0x10
 [<c05a0f42>] wait_for_completion+0x12/0x20
 [<c016c264>] __stop_machine+0x184/0x1f0
 [<c016c310>] ? stop_cpu+0x0/0xa0
 [<c016c0d0>] ? chill+0x0/0x10
 [<c057e920>] ? take_cpu_down+0x0/0x30
 [<c057ea77>] _cpu_down+0xd7/0x270
 [<c0179d1d>] ? __synchronize_sched+0x2d/0x40
 [<c0146ef0>] ? wakeme_after_rcu+0x0/0x10
 [<c057ec5a>] cpu_down+0x4a/0x70
 [<c057ff68>] store_online+0x38/0x80
 [<c057ff30>] ? store_online+0x0/0x80
 [<c0312f5c>] sysdev_store+0x2c/0x40
 [<c01e67b2>] sysfs_write_file+0xa2/0x100
 [<c01a8606>] vfs_write+0x96/0x130
 [<c01e6710>] ? sysfs_write_file+0x0/0x100
 [<c01a8b4d>] sys_write+0x3d/0x70
 [<c01040db>] sysenter_do_call+0x12/0x3f
 =======================


SysRq : Show Locks Held

Showing all locks held in the system:
1 lock held by mingetty/3520:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c02f3004>] read_chan+0x424/0x640
1 lock held by mingetty/3521:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c02f3004>] read_chan+0x424/0x640
1 lock held by mingetty/3522:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c02f3004>] read_chan+0x424/0x640
1 lock held by mingetty/3523:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c02f3004>] read_chan+0x424/0x640
1 lock held by mingetty/3524:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c02f3004>] read_chan+0x424/0x640
4 locks held by bash/3772:
 #0:  (&buffer->mutex){--..}, at: [<c01e673b>] sysfs_write_file+0x2b/0x100
 #1:  (cpu_add_remove_lock){--..}, at: [<c01367af>] cpu_maps_update_begin+0xf/00
 #2:  (&cpu_hotplug.lock){--..}, at: [<c013680a>] cpu_hotplug_begin+0x1a/0x50
 #3:  (lock){--..}, at: [<c016c132>] __stop_machine+0x52/0x1f0
1 lock held by bash/5074:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c02f3004>] read_chan+0x424/0x640
2 locks held by bash/6363:
 #0:  (sysrq_key_table_lock){++..}, at: [<c030094a>] __handle_sysrq+0x1a/0x120
 #1:  (tasklist_lock){..--}, at: [<c01574a1>] debug_show_all_locks+0x31/0x180

=============================================

So it seems (in my case) to be waiting for &finished to complete
(__stop_machine()):

        /* This will release the thread on our CPU. */
        put_cpu();
        wait_for_completion(&finished);
        mutex_unlock(&lock);


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
