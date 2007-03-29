Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXC2SSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXC2SSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030621AbXC2SSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:18:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:53971 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030532AbXC2SSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:18:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=MVcCDVG11PEROVeT/MCUc9sXn4ifgPfRbzeNUFXqJY3D8McGGoRah4Ju5cIF0VYU7sHMzSoLGtctlSYz/1ibOeOdUo1XJLExFMslBz0x63y0o7E/t9ljnC7MS0QFXUCqeWCOqC3+khHB6Kf8wUdWC3NRTpnzotLVlHWLULUV5sg=
Message-ID: <460C02F6.5050903@googlemail.com>
Date: Thu, 29 Mar 2007 20:18:30 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-rt4 inconsistent lock state
References: <460BB361.1000002@googlemail.com>
In-Reply-To: <460BB361.1000002@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisa³(a):
> Hi,
[..]
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-rt4/rt-config
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-rt4/rt-dmesg
> 

I just fixed an isic build in AT :)

BUG: isic:11396 task might have lost a preemption check!
 [<c0105470>] dump_trace+0x78/0x21a
 [<c0105647>] show_trace_log_lvl+0x35/0x54
 [<c0105dcc>] show_trace+0x2c/0x2e
 [<c0105e93>] dump_stack+0x29/0x2b
 [<c0121d64>] preempt_enable_no_resched+0x5c/0x5e
 [<c0218390>] debug_smp_processor_id+0xb0/0xb8
 [<fd98a83f>] nf_conntrack_in+0x39c/0x468 [nf_conntrack]
 [<fd999316>] ipv4_conntrack_local+0x61/0x67 [nf_conntrack_ipv4]
 [<c031c494>] nf_iterate+0x40/0x71
 [<c031c61a>] nf_hook_slow+0x5c/0xd7
 [<c033f066>] raw_sendmsg+0x518/0x6ee
 [<c0346819>] inet_sendmsg+0x4b/0x55
 [<c030109b>] sock_sendmsg+0xf7/0x114
 [<c0301b34>] sys_sendto+0xe5/0x105
 [<c0302521>] sys_socketcall+0x17e/0x254
 [<c010432d>] syscall_call+0x7/0xb
 [<b7f0c410>] 0xb7f0c410
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

BUG: using smp_processor_id() in preemptible [00000000] code: isic/16471
caller is nf_conntrack_in+0xd0/0x468 [nf_conntrack]
 [<c0105470>] dump_trace+0x78/0x21a
 [<c0105647>] show_trace_log_lvl+0x35/0x54
 [<c0105dcc>] show_trace+0x2c/0x2e
 [<c0105e93>] dump_stack+0x29/0x2b
 [<c021838b>] debug_smp_processor_id+0xab/0xb8
 [<fd98a573>] nf_conntrack_in+0xd0/0x468 [nf_conntrack]
 [<fd999316>] ipv4_conntrack_local+0x61/0x67 [nf_conntrack_ipv4]
 [<c031c494>] nf_iterate+0x40/0x71
 [<c031c61a>] nf_hook_slow+0x5c/0xd7
 [<c033f066>] raw_sendmsg+0x518/0x6ee
 [<c0346819>] inet_sendmsg+0x4b/0x55
 [<c030109b>] sock_sendmsg+0xf7/0x114
 [<c0301b34>] sys_sendto+0xe5/0x105
 [<c0302521>] sys_socketcall+0x17e/0x254
 [<c010432d>] syscall_call+0x7/0xb
 [<b7f01410>] 0xb7f01410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0359d9e>] .... __spin_lock+0x1a/0x59
.....[<c016321a>] ..   ( <= handle_fasteoi_irq+0x27/0xdf)

 l *0xc0359d9e
0xc0359d9e is in __spin_lock (kernel/spinlock.c:218).
213     EXPORT_SYMBOL(__write_lock_bh);
214
215     void __lockfunc __spin_lock(raw_spinlock_t *lock)
216     {
217             preempt_disable();
218             spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
219             _raw_spin_lock(lock);
220     }
221
222     EXPORT_SYMBOL(__spin_lock);

l *0xc016321a
0xc016321a is in handle_fasteoi_irq (kernel/irq/chip.c:405).
400             struct irqaction *action;
401             irqreturn_t action_ret;
402
403             spin_lock(&desc->lock);
404
405             if (unlikely(desc->status & IRQ_INPROGRESS))
406                     goto out;
407
408             desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
409             kstat_cpu(cpu).irqs[irq]++;


BUG: using smp_processor_id() in preemptible [00000000] code: isic/16471
caller is nf_conntrack_in+0x43d/0x468 [nf_conntrack]
 [<c0105470>] dump_trace+0x78/0x21a
 [<c0105647>] show_trace_log_lvl+0x35/0x54
 [<c0105dcc>] show_trace+0x2c/0x2e
 [<c0105e93>] dump_stack+0x29/0x2b
 [<c021838b>] debug_smp_processor_id+0xab/0xb8
 [<fd98a8e0>] nf_conntrack_in+0x43d/0x468 [nf_conntrack]
 [<fd999316>] ipv4_conntrack_local+0x61/0x67 [nf_conntrack_ipv4]
 [<c031c494>] nf_iterate+0x40/0x71
 [<c031c61a>] nf_hook_slow+0x5c/0xd7
 [<c033f066>] raw_sendmsg+0x518/0x6ee
 [<c0346819>] inet_sendmsg+0x4b/0x55
 [<c030109b>] sock_sendmsg+0xf7/0x114
 [<c0301b34>] sys_sendto+0xe5/0x105
 [<c0302521>] sys_socketcall+0x17e/0x254
 [<c010432d>] syscall_call+0x7/0xb
 [<b7f01410>] 0xb7f01410
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0218336>] .... debug_smp_processor_id+0x56/0xb8
.....[<fd98a8e0>] ..   ( <= nf_conntrack_in+0x43d/0x468 [nf_conntrack])

 l *0xc0218336
0xc0218336 is in debug_smp_processor_id (lib/smp_processor_id.c:42).
37              /*
38               * Avoid recursion:
39               */
40              preempt_disable();
41
42              if (!printk_ratelimit())
43                      goto out_enable;
44
45              printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] code: %s/%d\n", preempt_count()-1, current->comm, current->pid);
46              print_symbol("caller is %s\n", (long)__builtin_return_address(0));

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5-rt4/rt-dmesg2

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
