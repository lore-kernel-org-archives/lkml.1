Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbYELE5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbYELE5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYELE5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:57:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:5306 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYELE5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:57:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=dHmbj0CwnF4lnl1YFlIj51BcoIP4a8jtxPF+oZIXyC5wnujkwHnf32LiI+gX71G2KZpONz8XMVNWpHmO+YotUvhloywSAf/FjreY7r8h4DiZ+lX6y/7F0gmVKmkjwjm6oVGKXqw01BKWT1Nao2UXxu/W45wfgNnZOCaJeHYCfls=
Date: Mon, 12 May 2008 12:57:26 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: perex@perex.cz
Subject: 2.6.26-rc2 pcsp lockdep warnings
Message-ID: <20080512045726.GA3317@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 1922.871339] =======================================================
[ 1922.871349] [ INFO: possible circular locking dependency detected ]
[ 1922.871354] 2.6.26-rc2 #5
[ 1922.871357] -------------------------------------------------------
[ 1922.871361] xine/2911 is trying to acquire lock:
[ 1922.871364]  (&pcsp_chip.substream_lock){++..}, at: [<c03be7fe>] pcsp_do_timer+0x7e/0x350
[ 1922.871381] 
[ 1922.871382] but task is already holding lock:
[ 1922.871386]  (&cpu_base->lock){++..}, at: [<c014167d>] hrtimer_interrupt+0x7d/0x1a0
[ 1922.871398] 
[ 1922.871399] which lock already depends on the new lock.
[ 1922.871401] 
[ 1922.871404] 
[ 1922.871405] the existing dependency chain (in reverse order) is:
[ 1922.871409] 
[ 1922.871410] -> #5 (&cpu_base->lock){++..}:
[ 1922.871417]        [<c014ba03>] check_prev_add+0xd3/0x200
[ 1922.871431]        [<c014bbc5>] check_prevs_add+0x95/0xe0
[ 1922.871444]        [<c014be4f>] validate_chain+0x23f/0x320
[ 1922.872275]        [<c014d691>] __lock_acquire+0x1c1/0x760
[ 1922.872289]        [<c014e229>] lock_acquire+0x79/0xb0
[ 1922.872302]        [<c04523b8>] _spin_lock_irqsave+0x48/0xa0
[ 1922.872317]        [<c0140813>] lock_hrtimer_base+0x23/0x50
[ 1922.872331]        [<c0141029>] hrtimer_start+0x19/0x170
[ 1922.872344]        [<c011bf72>] start_rt_bandwidth+0x72/0x90
[ 1922.872358]        [<c011e6e1>] enqueue_rt_entity+0x91/0xb0
[ 1922.872372]        [<c011e8d5>] enqueue_task_rt+0x35/0x60
[ 1922.872385]        [<c0120f25>] enqueue_task+0x15/0x30
[ 1922.872398]        [<c0120fc9>] activate_task+0x19/0x30
[ 1922.872412]        [<c0121715>] try_to_wake_up+0xc5/0x120
[ 1922.872425]        [<c012177f>] wake_up_process+0xf/0x20
[ 1922.872438]        [<c044ec79>] migration_call+0xf9/0x2c0
[ 1922.872452]        [<c05df314>] migration_init+0x34/0x50
[ 1922.872466]        [<c05ce9f8>] do_pre_smp_initcalls+0x8/0x20
[ 1922.872481]        [<c05cea56>] kernel_init+0x46/0xb0
[ 1922.872494]        [<c0104a37>] kernel_thread_helper+0x7/0x10
[ 1922.872509]        [<ffffffff>] 0xffffffff
[ 1922.872522] 
[ 1922.872523] -> #4 (&rt_b->rt_runtime_lock){++..}:
[ 1922.872531]        [<c014ba03>] check_prev_add+0xd3/0x200
[ 1922.872544]        [<c014bbc5>] check_prevs_add+0x95/0xe0
[ 1922.872557]        [<c014be4f>] validate_chain+0x23f/0x320
[ 1922.872571]        [<c014d691>] __lock_acquire+0x1c1/0x760
[ 1922.872584]        [<c014e229>] lock_acquire+0x79/0xb0
[ 1922.872597]        [<c0452889>] _spin_lock+0x39/0x80
[ 1922.872611]        [<c011bf3a>] start_rt_bandwidth+0x3a/0x90
[ 1922.872624]        [<c011e6e1>] enqueue_rt_entity+0x91/0xb0
[ 1922.872637]        [<c011e8d5>] enqueue_task_rt+0x35/0x60
[ 1922.872650]        [<c0120f25>] enqueue_task+0x15/0x30
[ 1922.872663]        [<c0120fc9>] activate_task+0x19/0x30
[ 1922.872676]        [<c0121715>] try_to_wake_up+0xc5/0x120
[ 1922.872690]        [<c012177f>] wake_up_process+0xf/0x20
[ 1922.872703]        [<c044ec79>] migration_call+0xf9/0x2c0
[ 1922.872716]        [<c05df314>] migration_init+0x34/0x50
[ 1922.872722]        [<c05ce9f8>] do_pre_smp_initcalls+0x8/0x20
[ 1922.872722]        [<c05cea56>] kernel_init+0x46/0xb0
[ 1922.872722]        [<c0104a37>] kernel_thread_helper+0x7/0x10
[ 1922.872722]        [<ffffffff>] 0xffffffff
[ 1922.872722] 
[ 1922.872722] -> #3 (&rq->rq_lock_key){++..}:
[ 1922.872722]        [<c014ba03>] check_prev_add+0xd3/0x200
[ 1922.872722]        [<c014bbc5>] check_prevs_add+0x95/0xe0
[ 1922.872722]        [<c014be4f>] validate_chain+0x23f/0x320
[ 1922.872722]        [<c014d691>] __lock_acquire+0x1c1/0x760
[ 1922.872722]        [<c014e229>] lock_acquire+0x79/0xb0
[ 1922.872722]        [<c0452889>] _spin_lock+0x39/0x80
[ 1922.872722]        [<c011c3ec>] task_rq_lock+0x3c/0x70
[ 1922.872722]        [<c012167a>] try_to_wake_up+0x2a/0x120
[ 1922.872722]        [<c012380b>] default_wake_function+0xb/0x10
[ 1922.872722]        [<c0123848>] __wake_up_common+0x38/0x70
[ 1922.872722]        [<c012398d>] complete+0x3d/0x60
[ 1922.872722]        [<c013d8f7>] create_kthread+0x87/0xb0
[ 1922.872722]        [<c013db93>] kthreadd+0xb3/0xf0
[ 1922.872722]        [<c0104a37>] kernel_thread_helper+0x7/0x10
[ 1922.872722]        [<ffffffff>] 0xffffffff
[ 1922.872722] 
[ 1922.872722] -> #2 (&q->lock){++..}:
[ 1922.872722]        [<c014ba03>] check_prev_add+0xd3/0x200
[ 1922.872722]        [<c014bbc5>] check_prevs_add+0x95/0xe0
[ 1922.872722]        [<c014be4f>] validate_chain+0x23f/0x320
[ 1922.872722]        [<c014d691>] __lock_acquire+0x1c1/0x760
[ 1922.872722]        [<c014e229>] lock_acquire+0x79/0xb0
[ 1922.872722]        [<c04523b8>] _spin_lock_irqsave+0x48/0xa0
[ 1922.872722]        [<c012389b>] __wake_up+0x1b/0x50
[ 1922.872722]        [<c03ac832>] snd_pcm_post_stop+0x52/0x70
[ 1922.872722]        [<c03ac3bf>] snd_pcm_action_single+0x4f/0x80
[ 1922.872722]        [<c03ac458>] snd_pcm_action+0x68/0xc0
[ 1922.872722]        [<c03ac861>] snd_pcm_stop+0x11/0x20
[ 1922.872722]        [<c03ad530>] snd_pcm_drop+0x80/0xf0
[ 1922.872722]        [<c03ae5e7>] snd_pcm_release_substream+0x27/0x80
[ 1922.872722]        [<c03baab5>] snd_pcm_oss_release_file+0x15/0x30
[ 1922.872722]        [<c03baf56>] snd_pcm_oss_release+0x46/0xb0
[ 1922.872722]        [<c018b946>] __fput+0x156/0x180
[ 1922.872722]        [<c018b789>] fput+0x19/0x20
[ 1922.872722]        [<c0189ddc>] filp_close+0x3c/0x80
[ 1922.872722]        [<c0189e86>] sys_close+0x66/0xc0
[ 1922.872722]        [<c0103df6>] syscall_call+0x7/0xb
[ 1922.872722]        [<ffffffff>] 0xffffffff
[ 1922.872722] 
[ 1922.872722] -> #1 (&substream->self_group.lock){.+..}:
[ 1922.872722]        [<c014ba03>] check_prev_add+0xd3/0x200
[ 1922.872722]        [<c014bbc5>] check_prevs_add+0x95/0xe0
[ 1922.872722]        [<c014be4f>] validate_chain+0x23f/0x320
[ 1922.872722]        [<c014d691>] __lock_acquire+0x1c1/0x760
[ 1922.872722]        [<c014e229>] lock_acquire+0x79/0xb0
[ 1922.872722]        [<c0452889>] _spin_lock+0x39/0x80
[ 1922.872722]        [<c03be82c>] pcsp_do_timer+0xac/0x350
[ 1922.872722]        [<c01414d4>] run_hrtimer_pending+0x94/0x120
[ 1922.872722]        [<c01417be>] run_hrtimer_softirq+0x1e/0x30
[ 1922.872722]        [<c012ec96>] __do_softirq+0x76/0xe0
[ 1922.872722]        [<c012ed7a>] do_softirq+0x7a/0x80
[ 1922.872722]        [<c012f45d>] ksoftirqd+0x6d/0x150
[ 1922.872722]        [<c013d82c>] kthread+0x5c/0xa0
[ 1922.872722]        [<c0104a37>] kernel_thread_helper+0x7/0x10
[ 1922.872722]        [<ffffffff>] 0xffffffff
[ 1922.872722] 
[ 1922.872722] -> #0 (&pcsp_chip.substream_lock){++..}:
[ 1922.872722]        [<c014b964>] check_prev_add+0x34/0x200
[ 1922.872722]        [<c014bbc5>] check_prevs_add+0x95/0xe0
[ 1922.872722]        [<c014be4f>] validate_chain+0x23f/0x320
[ 1922.872722]        [<c014d691>] __lock_acquire+0x1c1/0x760
[ 1922.872722]        [<c014e229>] lock_acquire+0x79/0xb0
[ 1922.872722]        [<c04523b8>] _spin_lock_irqsave+0x48/0xa0
[ 1922.872722]        [<c03be7fe>] pcsp_do_timer+0x7e/0x350
[ 1922.872722]        [<c01415b5>] __run_hrtimer+0x55/0xa0
[ 1922.872722]        [<c014175f>] hrtimer_interrupt+0x15f/0x1a0
[ 1922.872722]        [<c0113574>] local_apic_timer_interrupt+0x54/0x60
[ 1922.872722]        [<c01135a8>] smp_apic_timer_interrupt+0x28/0x40
[ 1922.872722]        [<c01048cb>] apic_timer_interrupt+0x33/0x38
[ 1922.872722]        [<ffffffff>] 0xffffffff
[ 1922.872722] 
[ 1922.872722] other info that might help us debug this:
[ 1922.872722] 
[ 1922.872722] 1 lock held by xine/2911:
[ 1922.872722]  #0:  (&cpu_base->lock){++..}, at: [<c014167d>] hrtimer_interrupt+0x7d/0x1a0
[ 1922.872722] 
[ 1922.872722] stack backtrace:
[ 1922.872722] Pid: 2911, comm: xine Not tainted 2.6.26-rc2 #5
[ 1922.872722]  [<c012a2f8>] ? printk+0x18/0x20
[ 1922.872722]  [<c014b15f>] print_circular_bug_tail+0x6f/0x80
[ 1922.872722]  [<c014b001>] ? print_circular_bug_entry+0x51/0x60
[ 1922.872722]  [<c014b964>] check_prev_add+0x34/0x200
[ 1922.872722]  [<c014bbc5>] check_prevs_add+0x95/0xe0
[ 1922.872722]  [<c014be4f>] validate_chain+0x23f/0x320
[ 1922.872722]  [<c014cf2b>] ? mark_lock+0x8b/0x1a0
[ 1922.872722]  [<c014d691>] __lock_acquire+0x1c1/0x760
[ 1922.872723]  [<c014e229>] lock_acquire+0x79/0xb0
[ 1922.872723]  [<c03be7fe>] ? pcsp_do_timer+0x7e/0x350
[ 1922.872723]  [<c04523b8>] _spin_lock_irqsave+0x48/0xa0
[ 1922.872723]  [<c03be7fe>] ? pcsp_do_timer+0x7e/0x350
[ 1922.872723]  [<c03be7fe>] pcsp_do_timer+0x7e/0x350
[ 1922.872723]  [<c014a69d>] ? put_lock_stats+0xd/0x30
[ 1922.872723]  [<c014a664>] ? get_lock_stats+0x24/0x50
[ 1922.872723]  [<c0140fbf>] ? __remove_hrtimer+0x4f/0xa0
[ 1922.872723]  [<c03be780>] ? pcsp_do_timer+0x0/0x350
[ 1922.872723]  [<c01415b5>] __run_hrtimer+0x55/0xa0
[ 1922.872723]  [<c03be780>] ? pcsp_do_timer+0x0/0x350
[ 1922.872723]  [<c014175f>] hrtimer_interrupt+0x15f/0x1a0
[ 1922.872723]  [<c0113574>] local_apic_timer_interrupt+0x54/0x60
[ 1922.872723]  [<c012edc6>] ? irq_enter+0x46/0x70
[ 1922.872723]  [<c01135a8>] smp_apic_timer_interrupt+0x28/0x40
[ 1922.872723]  [<c01048cb>] apic_timer_interrupt+0x33/0x38
[ 1922.872723]  =======================
