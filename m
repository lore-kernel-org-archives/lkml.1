Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXC3RU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXC3RU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbXC3RU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:20:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:39833 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbXC3RUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=Zw6ZViF5FeFC/4/UA0rj3oDfTKVpWlNQ+rG4JUFbFIdT0cvPGQNrYorWZ3vlixWWClpNk0LC8MEvdJxdLVpSEvY4ynpNFxLP+YnjrSYxTK9hQOdG+LpmoDzs0DOZylrT9Ujd8a4WaKKH+njQvOo8sQmES26LHcg7RSEQ32Q487U=
Message-ID: <460D46BD.1080506@googlemail.com>
Date: Fri, 30 Mar 2007 19:19:57 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <6bffcb0e0703300931n1fb83ad3j2f857a8959c470b@mail.gmail.com> <20070330165522.GA4808@elte.hu>
In-Reply-To: <20070330165522.GA4808@elte.hu>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar napisał(a):
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> It's my lucky Friday, kernel hangs shortly after
>>
>> PM: Removing info for No Bus:vcsa1
>> PM: Adding info for No Bus:vcs1
>> PM: Adding info for No Bus:vcsa1
>> PM: Removing info for No Bus:vcs1
>> PM: Removing info for No Bus:vcsa1
>> PM: Adding info for No Bus:vcs1
>> PM: Adding info for No Bus:vcsa1
>> PM: Adding info for No Bus:rtc
>> Real Time Clock Driver v1.12ac
>>
>> due to
>>
>> GOOD
>> mm-only-hrtimers-debug-patch.patch
>> mm-only-hrtimers-debug-patch-fix.patch
>> BAD
>>
>> patches. Both patches works fine for me in vanilla tree.
> 
> hm. now that's a mystery ... Any way to figure out where it hangs? 
> nmi_watchdog=1/2, softlockup, etc?
> 
> 	Ingo
> 

nmi_watchdog=1 boots fine

nmi_watchdog=2 shows this

BUG: NMI Watchdog detected LOCKUP on CPU0, eip c014ce9c, registers:
Modules linked in: ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c014ce9c>]    Not tainted VLI
EFLAGS: 00000093   (2.6.21-rc5-mm3 #10)
EIP is at read_pointer+0x49/0x2d8
eax: c7a8dd04   ebx: 00000000   ecx: 00000000   edx: c043d19c
esi: c043d184   edi: c043d19c   ebp: c7a8dbf4   esp: c7a8dbbc
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevd (pid: 864, ti=c7a8c000 task=c97cd4d0 task.ti=c7a8c000)
Stack: 0000000b c7a8dc70 c7a8dbf4 c014d6d0 c7a8dd04 c043e454 c7a8dbf4 c011fdd1 
       c043e404 c043e454 c043d190 0005cd94 c043d184 c7a8dd04 c7a8dd14 c014dd3a 
       00000000 00000000 00000000 00000000 c7a8df44 c7a8dd74 c741eefb 00000008 
Call Trace:
 [<c014dd3a>] unwind+0x414/0xfa2
 [<c010510d>] dump_trace_unwind+0xb4/0xe5
 [<c014ce4d>] unwind_init_running+0x25/0x2b
 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c010ad39>] save_stack_trace+0x23/0x42
 [<c01393c9>] update_cpu_base_expires_next+0x56/0x5a
 [<c013a475>] hrtimer_interrupt+0x17c/0x1b8
 [<c0115e8e>] smp_apic_timer_interrupt+0x72/0x85
 [<c0104bef>] apic_timer_interrupt+0x33/0x38
 [<c014320c>] lock_release+0x1d2/0x1da
 [<c013a7ef>] up_read+0x19/0x2e
 [<c011b800>] do_page_fault+0x28f/0x55b
 [<c034d191>] error_code+0x79/0x80
 [<c020c23e>] __put_user_4+0x12/0x18
DWARF2 unwinder stuck at __put_user_4+0x12/0x18
Leftover inexact backtrace:
 [<c01040d6>] ret_from_fork+0x6/0x1c
 =======================
Code: a8 47 83 c0 00 0f 84 a3 02 00 00 8b 55 d8 8b 02 89 7c 24 0c 89 44 24 08 89 5c 24 04 c7 04 24 7c 54 3f c0 e9 75 02 00 00 8b 45 d8 <8b> 08 89 4d f0 89 d8 83 e0 07 83 f8 01 74 7f 7f 04 85 c0 eb 08 

l *0xc014ce9c
0xc014ce9c is in read_pointer (/mnt/md0/devel/linux-mm/kernel/unwind.c:526).
521
522             if (ptrType < 0 || ptrType == DW_EH_PE_omit) {
523                     dprintk(1, "Invalid pointer encoding %02X (%p,%p).", ptrType, *pLoc, end);
524                     return 0;
525             }
526             ptr.p8 = *pLoc;
527             switch(ptrType & DW_EH_PE_FORM) {
528             case DW_EH_PE_data2:
529                     if (end < (const void *)(ptr.p16u + 1)) {
530                             dprintk(1, "Data16 overrun (%p,%p).", ptr.p8, end);

UNWIND_INFO stuff

BUG: NMI Watchdog detected LOCKUP<0>Kernel panic - not syncing: Aiee, killing interrupt handler!
 on CPU1, eip c014cd37, registers:
Modules linked in: ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c014cd37>]    Not tainted VLI
EFLAGS: 00000012   (2.6.21-rc5-mm3 #10)
EIP is at cie_for_fde+0x45/0x65
eax: 0001c260   ebx: c04431f4   ecx: 0001c264   edx: 00000010
esi: c04431f8   edi: c97f7da4   ebp: c97f7c94   esp: c97f7c8c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process udevd (pid: 843, ti=c97f6000 task=c97f2ac0 task.ti=c97f6000)
Stack: 0003aac0 c045f458 c97f7db4 c014dd93 00000000 00000000 c97f3014 000001cc 
       c97f7f0c c97f7e14 c741eefb 00000008 c97f7f0c c04431f8 c020c184 c97f7f0c 
       c97f7f44 c97f7f44 00000000 00000008 c0834780 00000000 c97f7d34 c0142dc8 
Call Trace:
 [<c014dd93>] unwind+0x46d/0xfa2
 [<c010510d>] dump_trace_unwind+0xb4/0xe5
 [<c014ce4d>] unwind_init_running+0x25/0x2b
 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c010ad39>] save_stack_trace+0x23/0x42
 [<c01393c9>] update_cpu_base_expires_next+0x56/0x5a
 [<c013a475>] hrtimer_interrupt+0x17c/0x1b8
 [<c0115e8e>] smp_apic_timer_interrupt+0x72/0x85
 [<c0104bef>] apic_timer_interrupt+0x33/0x38
 [<c020c184>] __get_user_4+0x14/0x17
DWARF2 unwinder stuck at __get_user_4+0x14/0x17
Leftover inexact backtrace:
 [<c018b42f>] do_execve+0xdd/0x210
 [<c0102497>] sys_execve+0x3f/0x62
 [<c01041c2>] sysenter_past_esp+0x5f/0x99
 =======================
Code: c9 74 42 f6 c1 03 75 3b b8 04 00 00 00 2b 42 10 01 d8 39 c1 77 2d 89 c8 83 e0 fc 29 c3 8d 73 04 8b 53 04 83 fa 08 76 1b 8d 41 fc <39> c2 73 14 80 e2 03 75 0f 83 7e 04 00 74 0b eb 07 be ac 47 83 

l *0xc014cd37
0xc014cd37 is in cie_for_fde (/mnt/md0/devel/linux-mm/kernel/unwind.c:498).
493                     return &not_fde; /* this is a CIE */
494             if ((fde[1] & (sizeof(*fde) - 1))
495                 || fde[1] > (unsigned long)(fde + 1) - (unsigned long)table->address)
496                     return NULL; /* this is not a valid FDE */
497             cie = fde + 1 - fde[1] / sizeof(*fde);
498             if (*cie <= sizeof(*cie) + 4
499                 || *cie >= fde[1] - sizeof(*fde)
500                 || (*cie & (sizeof(*cie) - 1))
501                 || cie[1])
502                     return NULL; /* this is not a (valid) CIE */

UNWIND_INFO stuff

BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/drivers/char/vt.c:3409
in_atomic():1, irqs_disabled():1
no locks held by udevd/843.
irq event stamp: 186
hardirqs last  enabled at (185): [<c0141e40>] debug_check_no_locks_freed+0x123/0x12d
hardirqs last disabled at (186): [<c0104be5>] apic_timer_interrupt+0x29/0x38
softirqs last  enabled at (0): [<c0123442>] copy_process+0x534/0x138b
softirqs last disabled at (0): [<00000000>] 0x0

l *0xc0141e40
0xc0141e40 is in debug_check_no_locks_freed (include2/asm/irqflags.h:24).
19              return f;
20      }
21
22      static inline void native_restore_fl(unsigned long f)
23      {
24              asm volatile("pushl %0 ; popfl": /* no output */
25                                   :"g" (f)
26                                   :"memory", "cc");
27      }
28

l *0xc0104be5
0xc0104be5 is at include2/asm/bitops.h:246.
241     static int test_bit(int nr, const volatile void * addr);
242     #endif
243
244     static __always_inline int constant_test_bit(int nr, const volatile unsigned long *addr)
245     {
246             return ((1UL << (nr & 31)) & (addr[nr >> 5])) != 0;
247     }
248
249     static inline int variable_test_bit(int nr, const volatile unsigned long * addr)
250     {

 l *0xc0123442
0xc0123442 is in copy_process (/mnt/md0/devel/linux-mm/kernel/fork.c:1084).
1079            p->hardirq_enable_ip = 0;
1080            p->hardirq_enable_event = 0;
1081            p->hardirq_disable_ip = _THIS_IP_;
1082            p->hardirq_disable_event = 0;
1083            p->softirqs_enabled = 1;
1084            p->softirq_enable_ip = _THIS_IP_;
1085            p->softirq_enable_event = 0;
1086            p->softirq_disable_ip = 0;
1087            p->softirq_disable_event = 0;
1088            p->hardirq_context = 0;


 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c0105343>] show_trace_log_lvl+0x1a/0x30
 [<c0105f8a>] show_trace+0x12/0x14
 [<c0106027>] dump_stack+0x16/0x18
 [<c011dd5b>] __might_sleep+0xc9/0xcf
 [<c0269cb7>] do_unblank_screen+0x23/0x138
 [<c0269dd9>] unblank_screen+0xd/0xf
 [<c020d3df>] bust_spinlocks+0x1b/0x2c
 [<c01060c5>] die_nmi+0x9c/0xd9
 [<c0116ce1>] nmi_watchdog_tick+0x12e/0x20d
 [<c010643a>] do_nmi+0x97/0x274
 [<c034d23b>] nmi_stack_correct+0x26/0x2b
 [<c014cd37>] cie_for_fde+0x45/0x65
 [<c014dd93>] unwind+0x46d/0xfa2
 [<c010510d>] dump_trace_unwind+0xb4/0xe5
 [<c014ce4d>] unwind_init_running+0x25/0x2b
 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c010ad39>] save_stack_trace+0x23/0x42
 [<c01393c9>] update_cpu_base_expires_next+0x56/0x5a
 [<c013a475>] hrtimer_interrupt+0x17c/0x1b8
 [<c0115e8e>] smp_apic_timer_interrupt+0x72/0x85
 [<c0104bef>] apic_timer_interrupt+0x33/0x38
 [<c020c184>] __get_user_4+0x14/0x17
DWARF2 unwinder stuck at __get_user_4+0x14/0x17
Leftover inexact backtrace:
 [<c018b42f>] do_execve+0xdd/0x210
 [<c0102497>] sys_execve+0x3f/0x62
 [<c01041c2>] sysenter_past_esp+0x5f/0x99
 =======================
BUG: at /mnt/md0/devel/linux-mm/drivers/char/vt.c:3411 do_unblank_screen()
 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c0105343>] show_trace_log_lvl+0x1a/0x30
 [<c0105f8a>] show_trace+0x12/0x14
 [<c0106027>] dump_stack+0x16/0x18
 [<c0269d07>] do_unblank_screen+0x73/0x138
 [<c0269dd9>] unblank_screen+0xd/0xf
 [<c020d3df>] bust_spinlocks+0x1b/0x2c
 [<c01060c5>] die_nmi+0x9c/0xd9
 [<c0116ce1>] nmi_watchdog_tick+0x12e/0x20d
 [<c010643a>] do_nmi+0x97/0x274
 [<c034d23b>] nmi_stack_correct+0x26/0x2b
 [<c014cd37>] cie_for_fde+0x45/0x65
 [<c014dd93>] unwind+0x46d/0xfa2
 [<c010510d>] dump_trace_unwind+0xb4/0xe5
 [<c014ce4d>] unwind_init_running+0x25/0x2b
 [<c01051a1>] dump_trace+0x63/0x1eb
 [<c010ad39>] save_stack_trace+0x23/0x42
 [<c01393c9>] update_cpu_base_expires_next+0x56/0x5a
 [<c013a475>] hrtimer_interrupt+0x17c/0x1b8
 [<c0115e8e>] smp_apic_timer_interrupt+0x72/0x85
 [<c0104bef>] apic_timer_interrupt+0x33/0x38
 [<c020c184>] __get_user_4+0x14/0x17
DWARF2 unwinder stuck at __get_user_4+0x14/0x17
Leftover inexact backtrace:
 [<c018b42f>] do_execve+0xdd/0x210
 [<c0102497>] sys_execve+0x3f/0x62
 [<c01041c2>] sysenter_past_esp+0x5f/0x99
 =======================
Kernel panic - not syncing: Aiee, killing interrupt handler!

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm3/mm-console2.log

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
