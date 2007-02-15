Return-Path: <linux-kernel-owner+w=401wt.eu-S1422703AbXBOXY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422703AbXBOXY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422704AbXBOXY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:24:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:12806 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422703AbXBOXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:24:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=YKyf76Rb/SsvE1EBqERE8O00Jkn2qsw5eipJZWJ+7uHK9IdmR7Sjmj83HIQnUrS9LXhCi4gCtIN1rU22p5GV7osU/dfW4KHWoRX/YhjnBtm4iGSw8iGjGYw6/ms3DD5UaSlT1z/C+vh/NqYC3hn4zARkpJJUaSRzr/8xA+ryncA=
Message-ID: <45D4EBB3.2060800@googlemail.com>
Date: Fri, 16 Feb 2007 00:24:35 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.20-mm1
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>	<45D47020.1010309@googlemail.com> <20070215140232.0aba86a7.akpm@linux-foundation.org>
In-Reply-To: <20070215140232.0aba86a7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Thu, 15 Feb 2007 15:37:20 +0100
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> Andrew Morton napisa__(a):
>>> Temporarily at
>>>
>>>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
>>>
>>> Will appear later at
>>>
>>>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm1/
>>>
>>>
>> BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/mm/slab.c:3043
>> in_atomic():1, irqs_disabled():0
>> 1 lock held by artsd/3819:
>>  #0:  (&new->lock){--..}, at: [<c01d5b7c>] ipc_lock+0x35/0x4f
>>  [<c0105312>] show_trace_log_lvl+0x1a/0x2f
>>  [<c0105a25>] show_trace+0x12/0x14
>>  [<c0105ae7>] dump_stack+0x16/0x18
>>  [<c011db4a>] __might_sleep+0xc9/0xcf
>>  [<c017c37a>] kmem_cache_zalloc+0x28/0xe5
>>  [<c01d8c7d>] do_shmat+0x111/0x372
>>  [<c0109151>] sys_ipc+0x148/0x1b5
>>  [<c010432c>] syscall_call+0x7/0xb
> 
> That's shm-make-sysv-ipc-shared-memory-use-stacked-files.patch, brought to
> us by Eric-who-hasnt-read-Documentation/SubmitChecklist.
> 
> Like this, I guess:
> 
> diff -puN ipc/shm.c~shm-make-sysv-ipc-shared-memory-use-stacked-files-fix ipc/shm.c

I might be drunk...

This patch still doesn't solve the problem.

BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/mm/slab.c:3043
in_atomic():1, irqs_disabled():0
1 lock held by Xorg/2885:
 #0:  (&new->lock){--..}, at: [<c01d5b7c>] ipc_lock+0x35/0x4f
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a25>] show_trace+0x12/0x14
 [<c0105ae7>] dump_stack+0x16/0x18
 [<c011db4a>] __might_sleep+0xc9/0xcf
 [<c017c45f>] kmem_cache_alloc+0x28/0xbf
 [<c01814c3>] get_empty_filp+0x6a/0x173
 [<c01d8ca2>] do_shmat+0x136/0x390
 [<c0109151>] sys_ipc+0x148/0x1b5
 [<c010432c>] syscall_call+0x7/0xb
 =======================
BUG: MAX_LOCK_DEPTH too low!
turning off the locking correctness validator.
do_IRQ: stack overflow: -52
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a25>] show_trace+0x12/0x14
 [<c0105ae7>] dump_stack+0x16/0x18
 [<c0106cc0>] do_IRQ+0x95/0xc1
BUG: unable to handle kernel paging request at virtual address 0e200034
 printing eip:
c01052e2
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
last sysfs file: /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/vendor
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss evdev snd_mixer_oss snd_pcm snd_timer skge snd 8139too intel_agp sk98lin agpgart soundcore mii i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c01052e2>]    Not tainted VLI
EFLAGS: 00013046   (2.6.20-mm1 #16)
EIP is at dump_trace+0x88/0x9e
eax: 00000000   ebx: f412c01c   ecx: c0429344   edx: c03cf8fa
BUG: unable to handle kernel paging request at virtual address 8d17ca6c
 printing eip:
c011d927
*pde = 00000000
esi: 0e200000   edi: c03daed2   ebp: f412bfd0   esp: f412bfc0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process Xorg (pid: 2885, ti=f412a000 task=f4a58aa0 task.ti=f412c000)
Stack: c7422ac0 c03daed2 00000011 00000000 f412bfe4 c0105312 c0429344 c03daed2
       00000004 f412bff0 c0105a25 c03daed2 f412bffc c0105ae7 f412c008 f412c01c
Call Trace:
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011b8d1>] do_page_fault+0x47c/0x55b
 [<c033aaac>] error_code+0x7c/0x84
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a25>] show_trace+0x12/0x14
 [<c0105ae7>] dump_stack+0x16/0x18
 [<c0106cc0>] do_IRQ+0x95/0xc1
BUG: unable to handle kernel paging request at virtual address 0e200034
 printing eip:
c01052e2
*pde = 00000000
Oops: 0000 [#2]
PREEMPT SMP
last sysfs file: /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/vendor
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss evdev snd_mixer_oss snd_pcm snd_timer skge snd 8139too intel_agp sk98lin agpgart soundcore mii i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c01052e2>]    Not tainted VLI
EFLAGS: 00013046   (2.6.20-mm1 #16)
EIP is at dump_trace+0x88/0x9e
eax: 00000000   ebx: f412c01c   ecx: c0429344   edx: c03cf8fa
esi: 0e200000   edi: c03cfa80   ebp: f412be5c   esp: f412be4c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process Xorg (pid: 2885, ti=f412a000 task=f4a58aa0 task.ti=f412c000)
Stack: f412be64 c03cfa80 00000010 00000000 f412be70 c0105312 c0429344 c03cfa80
       f412c003 f412be94 c01053c4 c03cfa80 c03cfa80 f412bf88 f412bfc0 f4a58c3c
       0000002b 00000040 f412bef8 c01055c0 c03cfa80 00000010 f4a58c3c 00000b45
Call Trace:
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011b8d1>] do_page_fault+0x47c/0x55b
 [<c033aaac>] error_code+0x7c/0x84
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011b8d1>] do_page_fault+0x47c/0x55b
 [<c033aaac>] error_code+0x7c/0x84
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a25>] show_trace+0x12/0x14
 [<c0105ae7>] dump_stack+0x16/0x18
 [<c0106cc0>] do_IRQ+0x95/0xc1
BUG: unable to handle kernel paging request at virtual address 0e200034
 printing eip:
c01052e2
*pde = 00000000
Recursive die() failure, output suppressed
Oops: 0000 [#3]
Kernel panic - not syncing: Fatal exception in interrupt
PREEMPT SMP
last sysfs file: /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/vendor
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss evdev snd_mixer_oss snd_pcm snd_timer skge snd 8139too intel_agp sk98lin agpgart soundcore mii i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c011d927>]    Not tainted VLI
EFLAGS: 00010087   (2.6.20-mm1 #16)
EIP is at resched_task+0x19/0x7f
eax: 8d17ca6c   ebx: f4a58aa0   ecx: f59ceae0   edx: 00003246
esi: f59ceae0   edi: 00000000   ebp: f5fedde8   esp: f5fedde0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process automount (pid: 2423, ti=f5fec000 task=f7e79550 task.ti=f5fec000)
Stack: c7429b20 f59ceae0 f5fede3c c011f23d 00000080 00000000 00000003 f59ceae0
       00000000 00000001 00000001 c7421b20 00000080 00000000 00000069 06f71d80
       2a57c378 00000020 00000003 00000086 f5ae1f40 f5ae1f18 00000000 f5fede44
Call Trace:
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011b8d1>] do_page_fault+0x47c/0x55b
 [<c033aaac>] error_code+0x7c/0x84
 [<c011f23d>] try_to_wake_up+0x3eb/0x418
 [<c011f275>] default_wake_function+0xb/0xd
 [<c011c5d0>] __wake_up_common+0x32/0x55
 [<c011d3d9>] __wake_up+0x31/0x42
 [<c0142243>] wake_futex+0x45/0x50
 [<c0143dc0>] do_futex+0x88d/0xe93
 [<c0144456>] sys_futex+0x90/0xa3
 [<c010432c>] syscall_call+0x7/0xb
 =======================
Code: 01 7b 08 11 4b 0c eb 05 01 3b 11 4b 04 5b 5e 5f 5d c3 55 89 e5 56 53 89 c3 b8 a0 fd 4a c0 8b 53 04 8b 52 10 03 04 95 00 66 47 c0 <8a> 00 31 d2 84 c0 0f 9f c2 b8 e0 cd 42 c0 e8 d2 39 0f 00 85 c0
EIP: [<c011d927>] resched_task+0x19/0x7f SS:ESP 0068:f5fedde0
BUG: at /mnt/md0/devel/linux-mm/drivers/char/vt.c:3392 do_unblank_screen()
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a25>] show_trace+0x12/0x14
 [<c0105ae7>] dump_stack+0x16/0x18
 [<c025eb1d>] do_unblank_screen+0x73/0x138
 [<c025ebec>] unblank_screen+0xa/0xc
 [<c0203cac>] bust_spinlocks+0x18/0x2c
 [<c0105893>] die+0x174/0x234
 [<c011b8d1>] do_page_fault+0x47c/0x55b
 [<c033aaac>] error_code+0x7c/0x84
 [<c011f23d>] try_to_wake_up+0x3eb/0x418
 [<c011f275>] default_wake_function+0xb/0xd
 [<c011c5d0>] __wake_up_common+0x32/0x55
 [<c011d3d9>] __wake_up+0x31/0x42
 [<c0142243>] wake_futex+0x45/0x50
 [<c0143dc0>] do_futex+0x88d/0xe93
 [<c0144456>] sys_futex+0x90/0xa3
 [<c010432c>] syscall_call+0x7/0xb
 =======================
note: automount[2423] exited with preempt_count 4

0xc01052e2 is in dump_trace (/mnt/md0/devel/linux-mm/arch/i386/kernel/traps.c:191).
186                     /* Should be after the line below, but somewhere
187                        in early boot context comes out corrupted and we
188                        can't reference it -AK */
189                     if (ops->stack(data, "IRQ") < 0)
190                             break;
191                     stack = (unsigned long*)context->previous_esp;
192                     if (!stack)
193                             break;
194                     touch_nmi_watchdog();
195             }

0xc011d927 is in resched_task (include2/asm/spinlock.h:33).
28       * (the type definitions are in asm/spinlock_types.h)
29       */
30
31      static inline int __raw_spin_is_locked(raw_spinlock_t *x)
32      {
33              return *(volatile signed char *)(&(x)->slock) <= 0;
34      }
35
36      static inline void __raw_spin_lock(raw_spinlock_t *lock)
37      {

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
