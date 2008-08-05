Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYHEL3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYHEL3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbYHEL3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:29:14 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:39455 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbYHEL3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:29:13 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: oprofile? lockdep warning from 2.6.27-rc1-mm1 
To: Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080805110649.GJ811@erda.amd.com>
References: <7045.1217680122@jrobl> <20080805110649.GJ811@erda.amd.com>
Date: Tue, 05 Aug 2008 20:29:06 +0900
Message-ID: <9061.1217935746@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Robert Richter:
> this is new to me. I will take a look at this.

Thanks.
Here is another message at shutdown time.


Junjiro R. Okajima

----------------------------------------------------------------------
BUG: sleeping function called from invalid context at /home/jro/transparent/linux-2.6.27-rc1-mm1/kernel/sched.c:4613
in_atomic():1, irqs_disabled():0
1 lock held by oprofiled/1843:
 #0:  (start_mutex){--..}, at: [<c02d5c77>] oprofile_shutdown+0xf/0x5a
Pid: 1843, comm: oprofiled Not tainted 2.6.27-rc1-mm1jrousD #1
 [<c011ac79>] __might_sleep+0xdf/0x103
 [<c03688a8>] wait_for_common+0x1f/0x140
 [<c036e602>] ? sub_preempt_count+0x62/0xb0
 [<c036bf14>] ? _spin_unlock_irqrestore+0x53/0x69
 [<c0368a4b>] wait_for_completion+0x12/0x14
 [<c01314fe>] synchronize_rcu+0x2d/0x33
 [<c013154b>] ? wakeme_after_rcu+0x0/0xd
 [<c0137cc5>] atomic_notifier_chain_unregister+0x2b/0x32
 [<c0137cdb>] unregister_die_notifier+0xf/0x14
 [<c02d787c>] nmi_shutdown+0x44/0x84
 [<c02d5c94>] oprofile_shutdown+0x2c/0x5a
 [<c02d697c>] event_buffer_release+0x10/0x3c
 [<c01849a8>] __fput+0xc7/0x1b8
 [<c0184e43>] fput+0x22/0x3b
 [<c0181c32>] filp_close+0x43/0x69
 [<c012266f>] ? exit_files+0x30/0x3c
 [<c012261a>] put_files_struct+0xb1/0xd6
 [<c0122676>] exit_files+0x37/0x3c
 [<c0123b21>] do_exit+0x292/0x909
 [<c013e854>] ? put_lock_stats+0x27/0x3a
 [<c013e8b9>] ? lock_release_holdtime+0x52/0x6b
 [<c0173114>] ? sys_munmap+0x3b/0x42
 [<c01241dd>] do_group_exit+0x45/0x9d
 [<c0124244>] sys_exit_group+0xf/0x11
 [<c0103151>] sysenter_do_call+0x12/0x31
 =======================
