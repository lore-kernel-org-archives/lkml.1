Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbZAZPCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbZAZPCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbZAZPC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:02:28 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:33733 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZAZPC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:02:27 -0500
X-BigFish: VPS-49(z21eW5c9iz1432R62a3L98dR936eQ4015M1805M1315mzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KE333D-03-813-01
Date: Mon, 26 Jan 2009 16:02:03 +0100
From: Robert Richter <robert.richter@amd.com>
To: hooanon05@yahoo.co.jp
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: oprofile? lockdep warning from 2.6.27-rc1-mm1
Message-ID: <20090126150203.GJ21604@erda.amd.com>
References: <7045.1217680122@jrobl> <20080805110649.GJ811@erda.amd.com> <9061.1217935746@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9061.1217935746@jrobl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Jan 2009 15:02:03.0489 (UTC) FILETIME=[0C180510:01C97FC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.08 20:29:06, hooanon05@yahoo.co.jp wrote:
> 
> Robert Richter:
> > this is new to me. I will take a look at this.
> 
> Thanks.
> Here is another message at shutdown time.

Junjiro,

I reworked the code around this bug and it is upstream in
v2.6.29-rc1. Could you test with this version and look if the problem
still exists, please?

Thanks,

-Robert

> 
> 
> Junjiro R. Okajima
> 
> ----------------------------------------------------------------------
> BUG: sleeping function called from invalid context at /home/jro/transparent/linux-2.6.27-rc1-mm1/kernel/sched.c:4613
> in_atomic():1, irqs_disabled():0
> 1 lock held by oprofiled/1843:
>  #0:  (start_mutex){--..}, at: [<c02d5c77>] oprofile_shutdown+0xf/0x5a
> Pid: 1843, comm: oprofiled Not tainted 2.6.27-rc1-mm1jrousD #1
>  [<c011ac79>] __might_sleep+0xdf/0x103
>  [<c03688a8>] wait_for_common+0x1f/0x140
>  [<c036e602>] ? sub_preempt_count+0x62/0xb0
>  [<c036bf14>] ? _spin_unlock_irqrestore+0x53/0x69
>  [<c0368a4b>] wait_for_completion+0x12/0x14
>  [<c01314fe>] synchronize_rcu+0x2d/0x33
>  [<c013154b>] ? wakeme_after_rcu+0x0/0xd
>  [<c0137cc5>] atomic_notifier_chain_unregister+0x2b/0x32
>  [<c0137cdb>] unregister_die_notifier+0xf/0x14
>  [<c02d787c>] nmi_shutdown+0x44/0x84
>  [<c02d5c94>] oprofile_shutdown+0x2c/0x5a
>  [<c02d697c>] event_buffer_release+0x10/0x3c
>  [<c01849a8>] __fput+0xc7/0x1b8
>  [<c0184e43>] fput+0x22/0x3b
>  [<c0181c32>] filp_close+0x43/0x69
>  [<c012266f>] ? exit_files+0x30/0x3c
>  [<c012261a>] put_files_struct+0xb1/0xd6
>  [<c0122676>] exit_files+0x37/0x3c
>  [<c0123b21>] do_exit+0x292/0x909
>  [<c013e854>] ? put_lock_stats+0x27/0x3a
>  [<c013e8b9>] ? lock_release_holdtime+0x52/0x6b
>  [<c0173114>] ? sys_munmap+0x3b/0x42
>  [<c01241dd>] do_group_exit+0x45/0x9d
>  [<c0124244>] sys_exit_group+0xf/0x11
>  [<c0103151>] sysenter_do_call+0x12/0x31
>  =======================
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

