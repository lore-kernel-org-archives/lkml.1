Return-Path: <linux-kernel-owner+w=401wt.eu-S1946021AbXDCWVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946021AbXDCWVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946022AbXDCWVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:21:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:24617 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946021AbXDCWVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=qqoHyAkvTRqVQGfA7utMWLaxWLoM4M101WrHmq+RHIGgX5Rb1VRWDvFDYrftvwoGZ2AOpJQkNEzricGWT/MHTJcUHfdLTwpTNXNnHKI62CvGqkdBVePmf40/sGI1CTCIQ0ZqyeuQ83/+6gaxFPYoC2giBpyUvgWf9EALRiAEI1Q=
Message-ID: <4612D32E.20105@googlemail.com>
Date: Wed, 04 Apr 2007 00:20:30 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: 2.6.21-rc5-mm4
References: <20070402224745.71a25af7.akpm@linux-foundation.org> <46127CBF.8040803@googlemail.com>
In-Reply-To: <46127CBF.8040803@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> Andrew Morton napisał(a):
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
>>
> 
> Looks like a scheduler problem.
> 
> BUG: unable to handle kernel paging request at virtual address 0743c798
>  printing eip:
> c011d840
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP 
> last sysfs file: devices/platform/w83627hf.656/temp2_input
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd soundcore snd_page_alloc intel_agp agpgart i2c_i801 ide_cd cdrom rtc unix
> CPU:    0
> EIP:    0060:[<c011d840>]    Not tainted VLI
> 
>  l *0xc011d840
> 0xc011d840 is in recalc_task_prio (/mnt/md0/devel/linux-mm/kernel/sched.c:720).
> 715              * a queued better static_prio's prio_level.
> 716              */
> 717             if (p->static_prio < rq->best_static_prio) {
> 718                     search_prio = MAX_RT_PRIO;
> 719                     if (likely(p->policy != SCHED_BATCH))
> 720                             rq->best_static_prio = p->static_prio;
> 721             } else if (p->static_prio == rq->best_static_prio)
> 722                     search_prio = rq->prio_level[uprio];
> 723             else {
> 724                     search_prio = max(rq->prio_level[uprio],
> 
> 
> EFLAGS: 00210006   (2.6.21-rc5-mm4 #13)
> EIP is at recalc_task_prio+0xfa/0x19e
> eax: 1000008b   ebx: 10000027   ecx: 0000008b   edx: c743bda0
> esi: c985a070   edi: c743bda0   ebp: ce47fec0   esp: ce47fe98
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process operapluginwrap (pid: 3560, ti=ce47e000 task=ccffd510 task.ti=ce47e000)
> Stack: 00000000 c743bda0 c743c27c c011df36 c01240ed c04eac14 ce47fed0 c985a070 
>        c743bda0 c985a070 ce47fed0 c011da29 00000001 c985a070 ce47ff00 c011f327 
>        00000000 c052cda0 ce47ff00 c743bda0 8fbe3987 0000002d c985a070 003d0f00 
> Call Trace:
>  [<c011da29>] enqueue_task+0x31/0x7d
>  [<c011f327>] activate_task+0xba/0xce
>  [<c01223f3>] wake_up_new_task+0x65/0x125
>  [<c012440d>] do_fork+0x10f/0x181
>  [<c010223f>] sys_clone+0x33/0x39
>  [<c010424c>] syscall_call+0x7/0xb
>  [<4cefd258>] 0x4cefd258
>  =======================
> INFO: lockdep is turned off.
> Code: 83 7e 5c 03 0f 95 c2 b8 74 4c 4a c0 e8 12 e4 0f 00 bf 64 00 00 00 85 c0 74 2f 8b 46 1c 8b 55 dc 89 82 fc 09 00 00 eb 21 8b 7d dc <8b> 94 9f 5c 09 00 00 75 04 89 d7 eb 11 8b 7d dc 8b 84 8f cc 07 
> EIP: [<c011d840>] recalc_task_prio+0xfa/0x19e SS:ESP 0068:ce47fe98
> BUG: NMI Watchdog detected LOCKUP on CPU1, eip c020cf0f, registers:
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd soundcore snd_page_alloc intel_agp agpgart i2c_i801 ide_cd cdrom rtc unix
> CPU:    1
> EIP:    0060:[<c020cf0f>]    Not tainted VLI
> 
> l *0xc020cf0f
> 0xc020cf0f is in delay_tsc (/mnt/md0/devel/linux-mm/arch/i386/lib/delay.c:45).
> 40      /* TSC based delay: */
> 41      static void delay_tsc(unsigned long loops)
> 42      {
> 43              unsigned long bclock, now;
> 44
> 45              rdtscl(bclock);
> 46              do {
> 47                      rep_nop();
> 48                      rdtscl(now);
> 49              } while ((now-bclock) < loops);
> 
> 
> EFLAGS: 00000096   (2.6.21-rc5-mm4 #13)
> EIP is at delay_tsc+0x8/0x17
> eax: aa2a3a10   ebx: 00000001   ecx: aa2a386c   edx: 00000083
> esi: 0262e5e8   edi: 00000001   ebp: ccf1fc80   esp: ccf1fc7c
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process firefox-bin (pid: 3464, ti=ccf1e000 task=caf66ac0 task.ti=ccf1e000)
> Stack: c743bda0 ccf1fc90 c020cedc 00000000 c021add9 ccf1fcc0 c021ade8 00000000 
>        00000002 00000001 c011df36 00000000 caf66ac0 a6ca16f0 c743bda0 c743bda0 
>        ccf1fd50 ccf1fce0 c034f4be 00000000 00000002 c011df36 00200200 ccea1050 
> Call Trace:
>  [<c020cedc>] __delay+0xc/0xe
>  [<c021ade8>] _raw_spin_lock+0xc3/0x128
>  [<c034f4be>] _spin_lock+0x3c/0x42
>  [<c011df36>] task_rq_lock+0x36/0x70
>  [<c011f355>] try_to_wake_up+0x1a/0x36b
>  [<c011f6b4>] default_wake_function+0xe/0x10
>  [<c011c773>] __wake_up_common+0x32/0x55
>  [<c011d627>] __wake_up+0x31/0x42
>  [<c02f847f>] sock_def_readable+0x42/0x70
>  [<f8858ed0>] unix_stream_sendmsg+0x22d/0x2e2 [unix]
>  [<c02f3f95>] sock_aio_write+0xfb/0x107
>  [<c0185cb4>] do_sync_write+0xc5/0x102
>  [<c01865aa>] vfs_write+0xe5/0x15a
>  [<c0186bc8>] sys_write+0x3d/0x72
>  [<c010424c>] syscall_call+0x7/0xb
>  [<b7f24410>] 0xb7f24410
>  =======================
> INFO: lockdep is turned off.
> Code: c1 e0 02 64 8b 15 04 00 00 00 c1 e2 08 69 92 88 88 4e c0 fa 00 00 00 f7 e2 8d 42 01 e8 cb ff ff ff c9 c3 55 89 e5 53 89 c3 0f 31 <89> c1 f3 90 0f 31 29 c8 39 d8 72 f6 5b 5d c3 55 89 e5 83 ec 08 
> BUG: NMI Watchdog detected LOCKUP on CPU0, eip c020cf15, registers:
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm evdev snd_timer snd soundcore snd_page_alloc intel_agp agpgart i2c_i801 ide_cd cdrom rtc unix
> CPU:    0
> EIP:    0060:[<c020cf15>]    Not tainted VLI
> 
> l *0xc020cf15
> 0xc020cf15 is in delay_tsc (/mnt/md0/devel/linux-mm/arch/i386/lib/delay.c:49).
> 44
> 45              rdtscl(bclock);
> 46              do {
> 47                      rep_nop();
> 48                      rdtscl(now);
> 49              } while ((now-bclock) < loops);
> 50      }
> 51
> 52      /*
> 53       * Since we calibrate only once at boot, this
> 
> 
> EFLAGS: 00200086   (2.6.21-rc5-mm4 #13)
> EIP is at delay_tsc+0xe/0x17
> eax: ec55c3c8   ebx: 00000001   ecx: ec55c348   edx: 00000086
> esi: 04531454   edi: 00000001   ebp: ce47fc48   esp: ce47fc44
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process operapluginwrap (pid: 3560, ti=ce47e000 task=ccffd510 task.ti=ce47e000)
> Stack: c743bda0 ce47fc58 c020cedc 00000000 c021add9 ce47fc88 c021ade8 00000000 
>        00000002 00000001 c011df36 000f4240 000026eb a6ca16f0 c743bda0 c743bda0 
>        ce47fd18 ce47fca8 c034f4be 00000000 00000002 c011df36 c011fe36 c011f5b2 
> Call Trace:
>  [<c020cedc>] __delay+0xc/0xe
>  [<c021ade8>] _raw_spin_lock+0xc3/0x128
>  [<c034f4be>] _spin_lock+0x3c/0x42
>  [<c011df36>] task_rq_lock+0x36/0x70
>  [<c011f5bd>] try_to_wake_up+0x282/0x36b
>  [<c011f6b4>] default_wake_function+0xe/0x10
>  [<c0136fc2>] autoremove_wake_function+0x17/0x3a
>  [<c011c773>] __wake_up_common+0x32/0x55
>  [<c011d627>] __wake_up+0x31/0x42
>  [<c0125457>] wake_up_klogd+0x36/0x38
>  [<c020e38a>] bust_spinlocks+0x2a/0x2c
>  [<c01058bd>] die+0x16c/0x22c
>  [<c011b9ed>] do_page_fault+0x47c/0x55b
>  [<c034fdf1>] error_code+0x79/0x80
>  [<c011d840>] recalc_task_prio+0xfa/0x19e
>  [<c011da29>] enqueue_task+0x31/0x7d
>  [<c011f327>] activate_task+0xba/0xce
>  [<c01223f3>] wake_up_new_task+0x65/0x125
>  [<c012440d>] do_fork+0x10f/0x181
>  [<c010223f>] sys_clone+0x33/0x39
>  [<c010424c>] syscall_call+0x7/0xb
>  [<4cefd258>] 0x4cefd258
>  =======================
> INFO: lockdep is turned off.
> Code: 04 00 00 00 c1 e2 08 69 92 88 88 4e c0 fa 00 00 00 f7 e2 8d 42 01 e8 cb ff ff ff c9 c3 55 89 e5 53 89 c3 0f 31 89 c1 f3 90 0f 31 <29> c8 39 d8 72 f6 5b 5d c3 55 89 e5 83 ec 08 69 c0 1c 43 00 00 
> 
> I'll try without this patches
> 
> sched-fix-idle-load-balancing-in-softirqd-context.patch
> sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
> sched-dynticks-idle-load-balancing-v3.patch
> speedup-divides-by-cpu_power-in-scheduler.patch
> sched-optimize-siblings-status-check-logic-in-wake_idle.patch
> #
> sched-dont-renice-kernel-threads.patch
> sched-remove-sleepavg-from-proc.patch
> sched-implement-staircase-deadline-cpu-scheduler.patch
> sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
> sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
> sched-remove-noninteractive-flag.patch
> sched-document-sd-cpu-scheduler.patch
> #
> sched2-sched-domain-sysctl.patch
> #
> sched-add-above-background-load-function.patch
> 
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4/mm-oops
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-mm4/mm-config
> 

Sorry for a delay.

Con, I think that your
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
is causing this oops.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
