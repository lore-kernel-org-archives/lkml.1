Return-Path: <linux-kernel-owner+w=401wt.eu-S1161420AbXBGXVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161420AbXBGXVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 18:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422700AbXBGXVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 18:21:41 -0500
Received: from oceanic.wsisiz.edu.pl ([213.135.44.33]:19540 "EHLO
	oceanic.wsisiz.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161420AbXBGXVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 18:21:40 -0500
X-Greylist: delayed 1162 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 18:21:40 EST
X-DKIM: Sendmail DKIM Filter v0.5.2 oceanic.wsisiz.edu.pl 09AB215409E
X-DomainKeys: Sendmail DomainKeys Filter v0.4.1 oceanic.wsisiz.edu.pl 09AB215409E
DomainKey-Signature: a=rsa-sha1; s=dkimtest; d=wsisiz.edu.pl; c=nofws; q=dns;
	b=CIA6Whxve1xSnJXpXnegocbnIELWrzSq1yeGT+L3Y+sFvBshKAt6WqDiDLNxNrQAp
	KwpwmArT21Nn+j+SzIvxD/Em3T8c3TIEqvULWGDNlzPom3jBs2RsbpOUd0fgE8+U4X5
	/MP3y7oJ/ZCCFXPTZ0sJ20pSURBCKQCcOJ9j0tU=
X-DKIM: Sendmail DKIM Filter v0.5.2 oceanic.wsisiz.edu.pl 26D26154176
X-DomainKeys: Sendmail DomainKeys Filter v0.4.1 oceanic.wsisiz.edu.pl 26D26154176
Date: Thu, 8 Feb 2007 00:02:10 +0100 (CET)
From: Lukasz Trabinski <lukasz@wsisiz.edu.pl>
To: linux-kernel@vger.kernel.org
cc: Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>
Subject: 2.6.20 BUG: soft lockup detected on CPU#0!
Message-ID: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On 2.6.19 I had about 60 days uptime, on 2.6.20 2 days :(



oceanic:~$ uname -a
Linux oceanic.wsisiz.edu.pl 2.6.20-oceanic #2 SMP Sun Feb 4 21:55:29 CET 
2007 x86_64 x86_64 x86_64 GNU/Linux

Feb  7 22:46:00 oceanic kernel: BUG: soft lockup detected on CPU#0! 
Feb  7 22:46:00 oceanic kernel: 
Feb  7 22:46:00 oceanic kernel: Call Trace: 
Feb  7 22:46:00 oceanic kernel:  <IRQ>  [<ffffffff80250550>] softlockup_tick+0xdb/0xed 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022ea87>] __do_softirq+0x55/0xc4 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023256c>] update_process_times+0x42/0x68 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff80213e36>] smp_local_timer_interrupt+0x34/0x55 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff80214316>] smp_apic_timer_interrupt+0x51/0x68 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a3a6>] apic_timer_interrupt+0x66/0x70 
Feb  7 22:46:00 oceanic kernel:  <EOI>  [<ffffffff804393c3>] _spin_unlock_irqrestore+0x8/0x9 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff804393c3>] _spin_unlock_irqrestore+0x8/0x9 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023dddd>] hrtimer_try_to_cancel+0x4a/0x53 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023ddf2>] hrtimer_cancel+0xc/0x16 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023ddf2>] hrtimer_cancel+0xc/0x16 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022cc66>] do_exit+0x1c8/0x800 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022d31d>] sys_exit_group+0x0/0xe 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020995c>] tracesys+0xdc/0xe1 
Feb  7 22:46:00 oceanic kernel: 
Feb  7 22:46:00 oceanic kernel: BUG: soft lockup detected on CPU#1! 
Feb  7 22:46:00 oceanic kernel: 
Feb  7 22:46:00 oceanic kernel: Call Trace: 
Feb  7 22:46:00 oceanic kernel:  <IRQ>  [<ffffffff80250550>] softlockup_tick+0xdb/0xed 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023256c>] update_process_times+0x42/0x68 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff80213e36>] smp_local_timer_interrupt+0x34/0x55 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff80214316>] smp_apic_timer_interrupt+0x51/0x68 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff802338c8>] __group_send_sig_info+0x35/0x8b 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022e0f1>] it_real_fn+0x0/0x4f 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a3a6>] apic_timer_interrupt+0x66/0x70 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff802164da>] flat_send_IPI_mask+0x0/0x3d 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8023dc52>] hrtimer_run_queues+0x105/0x164 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff80231d0f>] run_timer_softirq+0x21/0x19f 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022eb49>] tasklet_action+0x53/0x9d 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8022ea87>] __do_softirq+0x55/0xc4 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a8fc>] call_softirq+0x1c/0x28 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020c3b1>] do_softirq+0x2c/0x7d 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8021431b>] smp_apic_timer_interrupt+0x56/0x68 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff80208a55>] default_idle+0x0/0x3d 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8020a3a6>] apic_timer_interrupt+0x66/0x70 
Feb  7 22:46:00 oceanic kernel:  <EOI>  [<ffffffff80208a7e>] default_idle+0x29/0x3d 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff80208ae4>] cpu_idle+0x52/0x71 
Feb  7 22:46:00 oceanic kernel:  [<ffffffff8057fbbc>] start_secondary+0x465/0x474

-- 
£T

