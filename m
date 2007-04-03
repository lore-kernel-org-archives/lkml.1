Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXDCXcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXDCXcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933104AbXDCXcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:32:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:2188 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbXDCXcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=J5K1uQa8y3WkCN0Bbh2eno1c5qUky6/Gg7aa4PP/ZcuxZGOkq5V3zS4o6TS8yfiGvZaAeH56/b9hFTmy3PeUMFFEBFaEXrWeph+gVJUgakzv2mq7RGbyb+WiYCkjpuYLBC8Sm8h3heu2pmaugKTSeGqEJcAC1Bc9ROZ2uS+XmIA=
Message-ID: <4612E3C3.6020806@googlemail.com>
Date: Wed, 04 Apr 2007 01:31:15 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Con Kolivas <kernel@kolivas.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <46127CBF.8040803@googlemail.com> <4612D32E.20105@googlemail.com> <200704040831.35225.kernel@kolivas.org>
In-Reply-To: <200704040831.35225.kernel@kolivas.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas napisał(a):
> On Wednesday 04 April 2007 08:20, Michal Piotrowski wrote:
>> Michal Piotrowski napisał(a):
>>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4/m
>>> m-oops
>>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4/m
>>> m-config
>> Sorry for a delay.
> 
> Never apologise! 
> 
> (I'm trying hard to stay offline for my own health so I may have huge delays).
> 
>> Con, I think that your
>> sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.pat
>> ch is causing this oops.
> 
> Thanks for heads up!
> 
> Try this patch please?

I still get the same oops.

BUG: unable to handle kernel paging request at virtual address 0743c798
 printing eip:
c011d80a
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
last sysfs file: devices/platform/w83627hf.656/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc evdev i2c_i801 intel_agp agpgart ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c011d80a>]    Not tainted VLI
EFLAGS: 00210006   (2.6.21-rc5-mm4 #15)
EIP is at recalc_task_prio+0xc0/0x162

l *0xc011d80a
0xc011d80a is in recalc_task_prio (/mnt/md0/devel/linux-mm/kernel/sched.c:722).
717              * a queued better static_prio's prio_level.
718              */
719             if (p->static_prio < rq->best_static_prio) {
720                     search_prio = MAX_RT_PRIO;
721                     if (likely(p->policy != SCHED_BATCH))
722                             rq->best_static_prio = p->static_prio;
723             } else if (p->static_prio == rq->best_static_prio)
724                     search_prio = rq->prio_level[uprio];
725             else {
726                     search_prio = max(rq->prio_level[uprio],


eax: 1000008b   ebx: 10000027   ecx: 0000008b   edx: c743c27c
esi: cc33d510   edi: c743bda0   ebp: ce4a9ec0   esp: ce4a9e98
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process operapluginwrap (pid: 3559, ti=ce4a8000 task=ce006ac0 task.ti=ce4a8000)
Stack: 00000000 c743c27c 00000001 c011defe c01240b5 c04eac14 ce4a9ed0 cc33d510 
       c743bda0 cc33d510 ce4a9ed0 c011d9f1 00000001 cc33d510 ce4a9f00 c011f2ef 
       00000000 c052cda0 ce4a9f00 c743bda0 c8ada023 00000029 cc33d510 003d0f00 
Call Trace:
 [<c011d9f1>] enqueue_task+0x31/0x7d
 [<c011f2ef>] activate_task+0xba/0xce
 [<c01223bb>] wake_up_new_task+0x65/0x125
 [<c01243d5>] do_fork+0x10f/0x181
 [<c010223f>] sys_clone+0x33/0x39
 [<c010424c>] syscall_call+0x7/0xb
 [<4cefd258>] 0x4cefd258
 =======================
INFO: lockdep is turned off.
Code: 7d 29 31 d2 83 7e 5c 03 0f 95 c2 b8 74 4c 4a c0 e8 04 e4 0f 00 c7 45 e0 64 00 00 00 85 c0 74 23 8b 46 1c 89 87 fc 09 00 00 eb 18 <8b> 94 9f 5c 09 00 00 74 0c 8b 84 8f cc 07 00 00 39 d0 0f 4d d0 
EIP: [<c011d80a>] recalc_task_prio+0xc0/0x162 SS:ESP 0068:ce4a9e98
BUG: NMI Watchdog detected LOCKUP on CPU0, eip c021ad9a, registers:
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc evdev i2c_i801 intel_agp agpgart ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c021ad9a>]    Not tainted VLI
EFLAGS: 00200006   (2.6.21-rc5-mm4 #15)
EIP is at _raw_spin_lock+0xb5/0x128

l *0xc021ad9a
0xc021ad9a is in _raw_spin_lock (/mnt/md0/devel/linux-mm/lib/spinlock_debug.c:109).
104             u64 loops = loops_per_jiffy * HZ;
105             int print_once = 1;
106
107             for (;;) {
108                     for (i = 0; i < loops; i++) {
109                             if (__raw_spin_trylock(&lock->raw_lock))
110                                     return;
111                             __delay(1);
112                     }
113                     /* lockup suspected: */


eax: 00000000   ebx: c743bda0   ecx: 88044b58   edx: 00000078
esi: 01f2bd6f   edi: 00000001   ebp: ce4a9c88   esp: ce4a9c60
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process operapluginwrap (pid: 3559, ti=ce4a8000 task=ce006ac0 task.ti=ce4a8000)
Stack: 00000000 00000002 00000001 c011defe 000f4240 000026ec a6ca8450 c743bda0 
       c743bda0 ce4a9d18 ce4a9ca8 c034f47e 00000000 00000002 c011defe c0140275 
       c0852720 c052cda0 ce4a9cc8 c011defe c0852720 000f4240 c9855510 c9799f00 
Call Trace:
 [<c034f47e>] _spin_lock+0x3c/0x42
 [<c011defe>] task_rq_lock+0x36/0x70
 [<c011f31d>] try_to_wake_up+0x1a/0x36b
 [<c011f67c>] default_wake_function+0xe/0x10
 [<c0136f8a>] autoremove_wake_function+0x17/0x3a
 [<c011c773>] __wake_up_common+0x32/0x55
 [<c011d62b>] __wake_up+0x31/0x42
 [<c012541f>] wake_up_klogd+0x36/0x38
 [<c020e34a>] bust_spinlocks+0x2a/0x2c
 [<c01058bd>] die+0x16c/0x22c
 [<c011b9ed>] do_page_fault+0x47c/0x55b
 [<c034fdb1>] error_code+0x79/0x80
 [<c011d80a>] recalc_task_prio+0xc0/0x162
 [<c011d9f1>] enqueue_task+0x31/0x7d
 [<c011f2ef>] activate_task+0xba/0xce
 [<c01223bb>] wake_up_new_task+0x65/0x125
 [<c01243d5>] do_fork+0x10f/0x181
 [<c010223f>] sys_clone+0x33/0x39
 [<c010424c>] syscall_call+0x7/0xb
 [<4cefd258>] 0x4cefd258
 =======================
INFO: lockdep is turned off.
Code: 9e c2 b8 38 16 4c c0 e8 7d 0e 00 00 85 c0 74 74 69 05 88 07 4a c0 e8 03 00 00 89 45 f0 bf 01 00 00 00 31 f6 eb 13 31 c0 86 03 46 <84> c0 7f 55 b8 01 00 00 00 e8 e8 20 ff ff 3b 75 f0 75 e8 85 ff 

serial console log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4/mm-oops2

BTW. I want to do some scheduler benchmarks tomorrow.
Do sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
is really important for staircase scheduler performance?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
