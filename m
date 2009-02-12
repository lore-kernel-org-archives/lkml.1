Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbZBLAvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbZBLAvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 19:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZBLAuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 19:50:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:14795 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZBLAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:50:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JC1wKa8+MSvJQv3iS8+vW0tyrZgQDx0qcbLEnYq6i6Sv7De3He9T9YYLCrUp8szEZD
         2RT+kncXRaf3gRL7oSbc5jJuEhvzhAhWf9AlTN/TCKk5C3mcYGxjFepdM7FP5oMl48E7
         +z5y53BSQENA3Fn5F11sJKQaP/7/YbpSuQaOw=
Date: Thu, 12 Feb 2009 01:50:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@tglx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [Announce] 2.6.29-rc4-rt1
Message-ID: <20090212005032.GA4788@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 11, 2009 at 11:43:44PM +0100, Thomas Gleixner wrote:
> After a 1.5 years sabbatical from preempt-rt we are pleased to
> announce a refactored preempt-rt patch against linux-2.6.29-rc4.
> 
> The patch is working on x86 (32 and 64bit) but we have not yet updated
> ARM, PPC and MIPS (work in progress).
> 
> We also dropped some experimental features of the base preempt-rt
> queue 2.6.26.8-rt15 simply because we wanted to survive the forward
> port over 3 kernel releases with the least amount of surprises. These
> features (e.g. multiple reader PI locks) are not essential for the
> preempt-rt functionality and need some serious overhaul anyway.
> 
> The interested -rt observer might have noticed that we based our work
> on the 2.6.26.8-rt15 patch queue and did not pick the git-rt tree
> which is based on 2.6.28. The reason for this is that we wanted to pick
> the most stable patch queue and the git-rt tree has a lot of rewritten
> new code. Our work is not making the work which was done over the last
> months in the git-rt tree obsolete, quite the contrary: we want to
> provide a stable yet latest-kernel based foundation and integrate those
> changes gradually, as they become ready.
> 
> The further plan for the new -rt series is to merge it fully into git
> and integrate it into the -tip git tree so it gets the same treatment
> as all of our -tip based work: fully automated compile and boot
> testing. Furthermore an automated multi architecture -rt performance
> regression test based on the same infrastructure is currently being
> built.
> 
> The integration into the -tip tree also allows us to seperate out parts
> of -rt which are ready for mainline more easily and integrate them
> with our usual propagation to mainline.
> 
> The structure of the patches is likely to change over the next days
> when we tackle the git integration, but we appreciate your feedback in
> the form of comments, bugreports and patches.
> 


Hi!

I get some sleep while atomic warnings.
I've put the log and my config in attachment.



--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=rtcrash

ents+0xd0/0xe0
[   44.220800]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   44.220808]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   44.220815]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   44.220822]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   44.220829]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   44.220836]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   44.220842]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   44.220850]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   44.220856]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   44.220864]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   44.220870]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   44.220877]  [<ffffffff802c0a6b>] ? file_read_actor+0x4b/0x190
[   44.220883]  [<ffffffff802c0a41>] ? file_read_actor+0x21/0x190
[   44.220889]  [<ffffffff802c3031>] generic_file_aio_read+0x521/0x6c0
[   44.220896]  [<ffffffff802e0c36>] ? vma_adjust+0x106/0x520
[   44.220903]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   44.220909]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   44.220915]  [<ffffffff802df709>] ? vm_stat_account+0x9/0x60
[   44.220922]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   44.220928]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   44.220936]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   44.220942]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   44.220949]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   44.220955]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   44.220960]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   45.228562] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   45.228571] in_atomic(): 0, irqs_disabled(): 1, pid: 4290, name: ntpdate
[   45.228576] INFO: lockdep is turned off.
[   45.228580] irq event stamp: 0
[   45.228583] hardirqs last  enabled at (0): [<(null)>] (null)
[   45.228589] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   45.228602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   45.228609] softirqs last disabled at (0): [<(null)>] (null)
[   45.228617] Pid: 4290, comm: ntpdate Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   45.228622] Call Trace:
[   45.228632]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   45.228639]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   45.228646]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   45.228653]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   45.228660]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   45.228667]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   45.228674]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   45.228680]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   45.228688]  [<ffffffff802d94ce>] __do_fault+0x29e/0x4c0
[   45.228694]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
[   45.228700]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   45.228707]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   45.228714]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   45.228720]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   45.228727]  [<ffffffff8043e1ed>] ? __clear_user+0x3d/0x70
[   45.228733]  [<ffffffff8043e1d1>] ? __clear_user+0x21/0x70
[   45.228738]  [<ffffffff8043e250>] clear_user+0x30/0x40
[   45.228746]  [<ffffffff80345d6c>] load_elf_binary+0x1cbc/0x1ef0
[   45.228752]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
[   45.228758]  [<ffffffff802da3ae>] ? follow_page+0x2ee/0x340
[   45.228764]  [<ffffffff802dc06c>] ? __get_user_pages+0x12c/0x4c0
[   45.228770]  [<ffffffff8077d63d>] ? __spin_unlock_irqrestore+0x6d/0x80
[   45.228777]  [<ffffffff8077d63d>] ? __spin_unlock_irqrestore+0x6d/0x80
[   45.228784]  [<ffffffff803440b0>] ? load_elf_binary+0x0/0x1ef0
[   45.228790]  [<ffffffff80304857>] search_binary_handler+0xc7/0x240
[   45.228796]  [<ffffffff80305eac>] do_execve+0x22c/0x2a0
[   45.228803]  [<ffffffff8021057e>] sys_execve+0x4e/0x80
[   45.228809]  [<ffffffff8021298a>] stub_execve+0x6a/0xc0
[   46.422994] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   46.423004] in_atomic(): 0, irqs_disabled(): 1, pid: 4301, name: gdmgreeter
[   46.423008] INFO: lockdep is turned off.
[   46.423012] irq event stamp: 0
[   46.423015] hardirqs last  enabled at (0): [<(null)>] (null)
[   46.423021] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   46.423034] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   46.423041] softirqs last disabled at (0): [<(null)>] (null)
[   46.423049] Pid: 4301, comm: gdmgreeter Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   46.423054] Call Trace:
[   46.423063]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   46.423070]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   46.423077]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   46.423084]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   46.423091]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   46.423098]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   46.423105]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   46.423111]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   46.423119]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   46.423125]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   46.423132]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   46.423140]  [<ffffffff802cc9c7>] ? activate_page+0x147/0x1e0
[   46.423146]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   46.423152]  [<ffffffff802cc9c7>] ? activate_page+0x147/0x1e0
[   46.423159]  [<ffffffff802c0a6b>] ? file_read_actor+0x4b/0x190
[   46.423165]  [<ffffffff802c0a41>] ? file_read_actor+0x21/0x190
[   46.423171]  [<ffffffff802c3031>] generic_file_aio_read+0x521/0x6c0
[   46.423178]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   46.423184]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   46.423190]  [<ffffffff802df709>] ? vm_stat_account+0x9/0x60
[   46.423197]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   46.423203]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   46.423211]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   46.423218]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   46.423224]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   46.423230]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   46.423236]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   47.420101] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   47.420111] in_atomic(): 0, irqs_disabled(): 1, pid: 4301, name: gdmgreeter
[   47.420116] INFO: lockdep is turned off.
[   47.420120] irq event stamp: 0
[   47.420123] hardirqs last  enabled at (0): [<(null)>] (null)
[   47.420130] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   47.420143] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   47.420151] softirqs last disabled at (0): [<(null)>] (null)
[   47.420158] Pid: 4301, comm: gdmgreeter Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   47.420163] Call Trace:
[   47.420173]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   47.420180]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   47.420188]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   47.420194]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   47.420202]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   47.420208]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   47.420217]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   47.420222]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   47.420230]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   47.420237]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   47.420244]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   47.420250]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   49.011076] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   49.011085] in_atomic(): 0, irqs_disabled(): 1, pid: 4303, name: aplay
[   49.011090] INFO: lockdep is turned off.
[   49.011093] irq event stamp: 0
[   49.011097] hardirqs last  enabled at (0): [<(null)>] (null)
[   49.011103] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   49.011115] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   49.011122] softirqs last disabled at (0): [<(null)>] (null)
[   49.011130] Pid: 4303, comm: aplay Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   49.011135] Call Trace:
[   49.011143]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   49.011150]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   49.011157]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   49.011165]  [<ffffffff80296985>] res_counter_uncharge+0x45/0xa0
[   49.011172]  [<ffffffff802fc108>] __mem_cgroup_uncharge_common+0xa8/0x140
[   49.011179]  [<ffffffff802fc1f0>] mem_cgroup_uncharge_cache_page+0x10/0x20
[   49.011186]  [<ffffffff802c35d1>] __remove_from_page_cache+0x51/0x100
[   49.011192]  [<ffffffff802c36ac>] remove_from_page_cache+0x2c/0x40
[   49.011199]  [<ffffffff802cd378>] truncate_complete_page+0x48/0x80
[   49.011206]  [<ffffffff802cd50f>] truncate_inode_pages_range+0x15f/0x410
[   49.011213]  [<ffffffff802cd7d5>] truncate_inode_pages+0x15/0x20
[   49.011219]  [<ffffffff802d2795>] shmem_delete_inode+0x65/0xf0
[   49.011225]  [<ffffffff802d2730>] ? shmem_delete_inode+0x0/0xf0
[   49.011232]  [<ffffffff80315c4c>] generic_delete_inode+0x8c/0x120
[   49.011239]  [<ffffffff80314b72>] iput+0x62/0x70
[   49.011245]  [<ffffffff803112d0>] dentry_iput+0xa0/0xf0
[   49.011251]  [<ffffffff8031144b>] d_kill+0x5b/0x90
[   49.011257]  [<ffffffff8031393e>] dput+0xbe/0x1d0
[   49.011263]  [<ffffffff80300795>] __fput+0x165/0x1f0
[   49.011269]  [<ffffffff80300845>] fput+0x25/0x30
[   49.011275]  [<ffffffff803c35b1>] shm_destroy+0xa1/0xc0
[   49.011281]  [<ffffffff803c37d8>] do_shm_rmid+0x18/0x50
[   49.011286]  [<ffffffff803c41d2>] sys_shmctl+0x512/0x760
[   49.011294]  [<ffffffff8021245a>] ? sysret_check+0x2e/0x69
[   49.011300]  [<ffffffff80280ed9>] ? trace_hardirqs_on_caller+0x29/0x1f0
[   49.011307]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   49.011313]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   50.039040] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   50.039049] in_atomic(): 0, irqs_disabled(): 1, pid: 3552, name: syslogd
[   50.039053] INFO: lockdep is turned off.
[   50.039057] irq event stamp: 0
[   50.039060] hardirqs last  enabled at (0): [<(null)>] (null)
[   50.039066] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   50.039078] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   50.039086] softirqs last disabled at (0): [<(null)>] (null)
[   50.039093] Pid: 3552, comm: syslogd Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   50.039098] Call Trace:
[   50.039107]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   50.039114]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   50.039121]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   50.039128]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   50.039136]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   50.039143]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   50.039151]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   50.039157]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   50.039164]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   50.039170]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   50.039176]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[   50.039182]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   50.039190]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[   50.039197]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   50.039203]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[   50.039210]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[   50.039217]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[   50.039224]  [<ffffffff802c34b0>] ? generic_file_aio_write+0x0/0xd0
[   50.039230]  [<ffffffff802feeb3>] do_sync_readv_writev+0xf3/0x140
[   50.039236]  [<ffffffff802f5da6>] ? __cache_free+0x16/0x280
[   50.039243]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   50.039252]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   50.039259]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   50.039265]  [<ffffffff802ff704>] do_readv_writev+0xd4/0x200
[   50.039271]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   50.039277]  [<ffffffff802ff878>] vfs_writev+0x48/0x70
[   50.039283]  [<ffffffff802ff8f5>] sys_writev+0x55/0xc0
[   50.039289]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   54.841672] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   54.842049] in_atomic(): 0, irqs_disabled(): 1, pid: 4238, name: nm-dispatcher.a
[   54.842404] INFO: lockdep is turned off.
[   54.842408] irq event stamp: 0
[   54.842412] hardirqs last  enabled at (0): [<(null)>] (null)
[   54.842418] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   54.842430] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   54.842438] softirqs last disabled at (0): [<(null)>] (null)
[   54.842446] Pid: 4238, comm: nm-dispatcher.a Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   54.842451] Call Trace:
[   54.842460]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   54.842467]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   54.842474]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   54.842481]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   54.842488]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   54.842494]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   54.842502]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   54.842508]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   54.842516]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   54.842522]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   54.842529]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   54.842535]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   57.756764] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   57.756773] in_atomic(): 0, irqs_disabled(): 1, pid: 4301, name: gdmgreeter
[   57.756778] INFO: lockdep is turned off.
[   57.756781] irq event stamp: 0
[   57.756785] hardirqs last  enabled at (0): [<(null)>] (null)
[   57.756791] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   57.756803] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   57.756810] softirqs last disabled at (0): [<(null)>] (null)
[   57.756818] Pid: 4301, comm: gdmgreeter Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   57.756823] Call Trace:
[   57.756831]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   57.756838]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   57.756846]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   57.756852]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   57.756860]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   57.756866]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   57.756874]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   57.756880]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   57.756888]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   57.756894]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   57.756901]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   57.756907]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   57.756914]  [<ffffffff802c0a6b>] ? file_read_actor+0x4b/0x190
[   57.756920]  [<ffffffff802c0a41>] ? file_read_actor+0x21/0x190
[   57.756926]  [<ffffffff802c3031>] generic_file_aio_read+0x521/0x6c0
[   57.756933]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   57.756939]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   57.756945]  [<ffffffff802df709>] ? vm_stat_account+0x9/0x60
[   57.756952]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   57.756959]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   57.756967]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   57.756973]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   57.756979]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   57.756985]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   57.756991]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   59.167886] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   59.167896] in_atomic(): 0, irqs_disabled(): 1, pid: 4067, name: gdm
[   59.167900] INFO: lockdep is turned off.
[   59.167904] irq event stamp: 0
[   59.167907] hardirqs last  enabled at (0): [<(null)>] (null)
[   59.167913] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   59.167925] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   59.167932] softirqs last disabled at (0): [<(null)>] (null)
[   59.167939] Pid: 4067, comm: gdm Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   59.167944] Call Trace:
[   59.167953]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   59.167960]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   59.167967]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   59.167974]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   59.167982]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   59.167988]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   59.167995]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   59.168001]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   59.168008]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   59.168014]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   59.168022]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   59.168028]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   59.168036]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   59.168043]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   59.168049]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   59.168056]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   59.168063]  [<ffffffff802cba73>] ondemand_readahead+0x193/0x210
[   59.168069]  [<ffffffff802cbbd5>] page_cache_sync_readahead+0x25/0x30
[   59.168075]  [<ffffffff802c2f64>] generic_file_aio_read+0x454/0x6c0
[   59.168082]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   59.168087]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   59.168095]  [<ffffffff802df709>] ? vm_stat_account+0x9/0x60
[   59.168101]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   59.168107]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   59.168115]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   59.168121]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   59.168128]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   59.168134]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   59.168140]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   60.264296] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   60.264305] in_atomic(): 0, irqs_disabled(): 1, pid: 432, name: pdflush
[   60.264309] INFO: lockdep is turned off.
[   60.264313] irq event stamp: 0
[   60.264316] hardirqs last  enabled at (0): [<(null)>] (null)
[   60.264322] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   60.264334] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   60.264341] softirqs last disabled at (0): [<(null)>] (null)
[   60.264348] Pid: 432, comm: pdflush Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   60.264353] Call Trace:
[   60.264362]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   60.264369]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   60.264376]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   60.264383]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   60.264390]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   60.264397]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   60.264404]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   60.264410]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   60.264417]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   60.264423]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   60.264429]  [<ffffffff802c1eb9>] find_or_create_page+0x69/0xb0
[   60.264436]  [<ffffffff80325771>] __getblk+0x111/0x350
[   60.264443]  [<ffffffff803858af>] do_journal_end+0x54f/0x1110
[   60.264449]  [<ffffffff8077cbeb>] ? _mutex_unlock+0x2b/0x40
[   60.264455]  [<ffffffff80386934>] ? do_journal_begin_r+0x164/0x340
[   60.264461]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   60.264467]  [<ffffffff803864e3>] journal_end_sync+0x73/0x90
[   60.264473]  [<ffffffff803758f0>] reiserfs_sync_fs+0x70/0x90
[   60.264479]  [<ffffffff80375923>] reiserfs_write_super+0x13/0x20
[   60.264486]  [<ffffffff80301284>] sync_supers+0x94/0xf0
[   60.264492]  [<ffffffff802ca367>] wb_kupdate+0x37/0x130
[   60.264498]  [<ffffffff802cb2b1>] pdflush+0x161/0x240
[   60.264504]  [<ffffffff802ca330>] ? wb_kupdate+0x0/0x130
[   60.264510]  [<ffffffff802810ad>] ? trace_hardirqs_on+0xd/0x10
[   60.264516]  [<ffffffff802cb150>] ? pdflush+0x0/0x240
[   60.264522]  [<ffffffff8026f0ee>] kthread+0x4e/0x90
[   60.264528]  [<ffffffff802135ba>] child_rip+0xa/0x20
[   60.264534]  [<ffffffff80250125>] ? schedule_tail+0x45/0xb0
[   60.264539]  [<ffffffff802810ad>] ? trace_hardirqs_on+0xd/0x10
[   60.264545]  [<ffffffff80212f54>] ? restore_args+0x0/0x30
[   60.264551]  [<ffffffff8026f0a0>] ? kthread+0x0/0x90
[   60.264556]  [<ffffffff802135b0>] ? child_rip+0x0/0x20
[   61.274005] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   61.274013] in_atomic(): 0, irqs_disabled(): 1, pid: 4384, name: cc1
[   61.274018] INFO: lockdep is turned off.
[   61.274021] irq event stamp: 0
[   61.274024] hardirqs last  enabled at (0): [<(null)>] (null)
[   61.274030] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   61.274042] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   61.274050] softirqs last disabled at (0): [<(null)>] (null)
[   61.274057] Pid: 4384, comm: cc1 Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   61.274062] Call Trace:
[   61.274071]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   61.274078]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   61.274085]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   61.274092]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   61.274100]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   61.274106]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   61.274113]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   61.274119]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   61.274126]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   61.274132]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   61.274140]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   61.274146]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   61.274154]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   61.274161]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   61.274167]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   61.274174]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   61.274181]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   61.274187]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   61.274194]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   61.274200]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   61.274206]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   61.274213]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   61.274219]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   62.285531] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   62.285540] in_atomic(): 0, irqs_disabled(): 1, pid: 4408, name: dbus-daemon
[   62.285545] INFO: lockdep is turned off.
[   62.285549] irq event stamp: 0
[   62.285552] hardirqs last  enabled at (0): [<(null)>] (null)
[   62.285558] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   62.285570] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   62.285578] softirqs last disabled at (0): [<(null)>] (null)
[   62.285585] Pid: 4408, comm: dbus-daemon Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   62.285589] Call Trace:
[   62.285599]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   62.285605]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   62.285613]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   62.285620]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   62.285627]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   62.285633]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   62.285641]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   62.285647]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   62.285654]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   62.285660]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   62.285667]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   62.285674]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   62.285681]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   62.285689]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   62.285695]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   62.285702]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   62.285708]  [<ffffffff802cba73>] ondemand_readahead+0x193/0x210
[   62.285715]  [<ffffffff802cbbd5>] page_cache_sync_readahead+0x25/0x30
[   62.285721]  [<ffffffff802c2f64>] generic_file_aio_read+0x454/0x6c0
[   62.285728]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   62.285733]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   62.285739]  [<ffffffff8077b9c9>] ? rt_mutex_unlock+0x9/0x40
[   62.285746]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   62.285753]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   62.285758]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   62.285766]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   62.285772]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   62.285779]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   62.285785]  [<ffffffff8030550f>] kernel_read+0x3f/0x60
[   62.285790]  [<ffffffff80305615>] prepare_binprm+0xe5/0x110
[   62.285796]  [<ffffffff80305e25>] do_execve+0x1a5/0x2a0
[   62.285802]  [<ffffffff8021057e>] sys_execve+0x4e/0x80
[   62.285808]  [<ffffffff8021298a>] stub_execve+0x6a/0xc0
[   63.288944] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   63.288953] in_atomic(): 0, irqs_disabled(): 1, pid: 4413, name: gvfsd
[   63.288958] INFO: lockdep is turned off.
[   63.288961] irq event stamp: 0
[   63.288965] hardirqs last  enabled at (0): [<(null)>] (null)
[   63.288971] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   63.288982] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   63.288990] softirqs last disabled at (0): [<(null)>] (null)
[   63.288997] Pid: 4413, comm: gvfsd Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   63.289002] Call Trace:
[   63.289010]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   63.289017]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   63.289025]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   63.289031]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   63.289039]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   63.289045]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   63.289053]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   63.289059]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   63.289065]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   63.289071]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   63.289079]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   63.289085]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   63.289093]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   63.289100]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   63.289106]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   63.289113]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   63.289120]  [<ffffffff802cba73>] ondemand_readahead+0x193/0x210
[   63.289126]  [<ffffffff802cbbd5>] page_cache_sync_readahead+0x25/0x30
[   63.289132]  [<ffffffff802c2f64>] generic_file_aio_read+0x454/0x6c0
[   63.289138]  [<ffffffff802fcc60>] ? generic_file_open+0x0/0x40
[   63.289144]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   63.289150]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   63.289157]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   63.289163]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   63.289171]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   63.289177]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   63.289184]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   63.289189]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   63.289195]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   64.339383] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   64.339392] in_atomic(): 0, irqs_disabled(): 1, pid: 4411, name: xfce-mcs-manage
[   64.339397] INFO: lockdep is turned off.
[   64.339401] irq event stamp: 0
[   64.339404] hardirqs last  enabled at (0): [<(null)>] (null)
[   64.339409] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   64.339421] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   64.339428] softirqs last disabled at (0): [<(null)>] (null)
[   64.339435] Pid: 4411, comm: xfce-mcs-manage Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   64.339440] Call Trace:
[   64.339449]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   64.339456]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   64.339463]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   64.339470]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   64.339477]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   64.339484]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   64.339491]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   64.339497]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   64.339504]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   64.339510]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   64.339517]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   64.339524]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   64.339531]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   64.339539]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   64.339545]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   64.339551]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   64.339558]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   64.339564]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   64.339571]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   64.339577]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   64.339583]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   64.339590]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   64.339596]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   65.336753] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   65.336762] in_atomic(): 0, irqs_disabled(): 1, pid: 4424, name: gam_server
[   65.336767] INFO: lockdep is turned off.
[   65.336770] irq event stamp: 0
[   65.336773] hardirqs last  enabled at (0): [<(null)>] (null)
[   65.336779] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   65.336791] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   65.336799] softirqs last disabled at (0): [<(null)>] (null)
[   65.336806] Pid: 4424, comm: gam_server Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   65.336811] Call Trace:
[   65.336821]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   65.336827]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   65.336834]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   65.336841]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   65.336848]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   65.336854]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   65.336862]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   65.336868]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   65.336876]  [<ffffffff802d94ce>] __do_fault+0x29e/0x4c0
[   65.336881]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
[   65.336888]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   65.336894]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   65.336901]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   65.336907]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   65.336914]  [<ffffffff8043e1ed>] ? __clear_user+0x3d/0x70
[   65.336919]  [<ffffffff8043e1d1>] ? __clear_user+0x21/0x70
[   65.336924]  [<ffffffff8043e250>] clear_user+0x30/0x40
[   65.336932]  [<ffffffff80345d6c>] load_elf_binary+0x1cbc/0x1ef0
[   65.336938]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
[   65.336944]  [<ffffffff802da3ae>] ? follow_page+0x2ee/0x340
[   65.336950]  [<ffffffff802dc06c>] ? __get_user_pages+0x12c/0x4c0
[   65.336956]  [<ffffffff8077d63d>] ? __spin_unlock_irqrestore+0x6d/0x80
[   65.336962]  [<ffffffff8077d63d>] ? __spin_unlock_irqrestore+0x6d/0x80
[   65.336969]  [<ffffffff803440b0>] ? load_elf_binary+0x0/0x1ef0
[   65.336976]  [<ffffffff80304857>] search_binary_handler+0xc7/0x240
[   65.336981]  [<ffffffff80305eac>] do_execve+0x22c/0x2a0
[   65.336988]  [<ffffffff8021057e>] sys_execve+0x4e/0x80
[   65.336994]  [<ffffffff8021298a>] stub_execve+0x6a/0xc0
[   66.374844] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   66.374853] in_atomic(): 0, irqs_disabled(): 1, pid: 4425, name: xfdesktop
[   66.374858] INFO: lockdep is turned off.
[   66.374862] irq event stamp: 0
[   66.374865] hardirqs last  enabled at (0): [<(null)>] (null)
[   66.374871] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   66.374883] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   66.374891] softirqs last disabled at (0): [<(null)>] (null)
[   66.374898] Pid: 4425, comm: xfdesktop Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   66.374903] Call Trace:
[   66.374912]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   66.374918]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   66.374926]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   66.374933]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   66.374940]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   66.374946]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   66.374954]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   66.374960]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   66.374967]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   66.374973]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   66.374980]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   66.374987]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   66.374994]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   66.375002]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   66.375008]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   66.375015]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   66.375021]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   66.375027]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   66.375034]  [<ffffffff804383f7>] ? prio_tree_insert+0x247/0x2d0
[   66.375042]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   66.375047]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   66.375054]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   66.375060]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   66.375067]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   66.375073]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   67.374088] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   67.374097] in_atomic(): 0, irqs_disabled(): 1, pid: 4425, name: xfdesktop
[   67.374102] INFO: lockdep is turned off.
[   67.374105] irq event stamp: 0
[   67.374108] hardirqs last  enabled at (0): [<(null)>] (null)
[   67.374114] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   67.374126] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   67.374133] softirqs last disabled at (0): [<(null)>] (null)
[   67.374140] Pid: 4425, comm: xfdesktop Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   67.374145] Call Trace:
[   67.374154]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   67.374161]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   67.374168]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   67.374175]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   67.374182]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   67.374188]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   67.374196]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   67.374201]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   67.374209]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   67.374215]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   67.374222]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   67.374228]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   67.374234]  [<ffffffff802c0a6b>] ? file_read_actor+0x4b/0x190
[   67.374240]  [<ffffffff802c0a41>] ? file_read_actor+0x21/0x190
[   67.374246]  [<ffffffff802c3031>] generic_file_aio_read+0x521/0x6c0
[   67.374253]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   67.374259]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   67.374265]  [<ffffffff802df709>] ? vm_stat_account+0x9/0x60
[   67.374272]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   67.374278]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   67.374286]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   67.374292]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   67.374298]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   67.374304]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   67.374310]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   68.378367] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   68.378376] in_atomic(): 0, irqs_disabled(): 1, pid: 4438, name: xfce4-panel
[   68.378381] INFO: lockdep is turned off.
[   68.378385] irq event stamp: 0
[   68.378388] hardirqs last  enabled at (0): [<(null)>] (null)
[   68.378394] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   68.378406] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   68.378413] softirqs last disabled at (0): [<(null)>] (null)
[   68.378420] Pid: 4438, comm: xfce4-panel Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   68.378425] Call Trace:
[   68.378434]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   68.378440]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   68.378448]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   68.378454]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   68.378462]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   68.378468]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   68.378475]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   68.378481]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   68.378488]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   68.378494]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   68.378502]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   68.378508]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   68.378516]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   68.378523]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   68.378529]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   68.378536]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   68.378543]  [<ffffffff802cba73>] ondemand_readahead+0x193/0x210
[   68.378549]  [<ffffffff802cbbd5>] page_cache_sync_readahead+0x25/0x30
[   68.378555]  [<ffffffff802c2f64>] generic_file_aio_read+0x454/0x6c0
[   68.378562]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   68.378568]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   68.378574]  [<ffffffff802df709>] ? vm_stat_account+0x9/0x60
[   68.378581]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   68.378587]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   68.378595]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   68.378602]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   68.378608]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   68.378614]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   68.378619]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   69.377249] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   69.377258] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   69.377263] INFO: lockdep is turned off.
[   69.377267] irq event stamp: 0
[   69.377270] hardirqs last  enabled at (0): [<(null)>] (null)
[   69.377276] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   69.377288] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   69.377296] softirqs last disabled at (0): [<(null)>] (null)
[   69.377303] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   69.377308] Call Trace:
[   69.377317]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   69.377324]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   69.377331]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   69.377338]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   69.377345]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   69.377352]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   69.377359]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   69.377365]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   69.377372]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   69.377378]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   69.377385]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   69.377392]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   69.377399]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   69.377407]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   69.377413]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   69.377420]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   69.377426]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   69.377432]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   69.377439]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   69.377445]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   69.377452]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   69.377458]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   69.377465]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   70.376254] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   70.376263] in_atomic(): 0, irqs_disabled(): 1, pid: 4445, name: xfce4-places-pl
[   70.376268] INFO: lockdep is turned off.
[   70.376272] irq event stamp: 0
[   70.376275] hardirqs last  enabled at (0): [<(null)>] (null)
[   70.376281] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   70.376293] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   70.376300] softirqs last disabled at (0): [<(null)>] (null)
[   70.376307] Pid: 4445, comm: xfce4-places-pl Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   70.376312] Call Trace:
[   70.376321]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   70.376328]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   70.376335]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   70.376342]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   70.376349]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   70.376356]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   70.376364]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   70.376369]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   70.376377]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   70.376383]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   70.376390]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   70.376396]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   71.386946] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   71.386955] in_atomic(): 0, irqs_disabled(): 1, pid: 4499, name: python
[   71.386960] INFO: lockdep is turned off.
[   71.386965] irq event stamp: 0
[   71.386968] hardirqs last  enabled at (0): [<(null)>] (null)
[   71.386975] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   71.386987] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   71.386995] softirqs last disabled at (0): [<(null)>] (null)
[   71.387003] Pid: 4499, comm: python Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   71.387008] Call Trace:
[   71.387017]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   71.387024]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   71.387031]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   71.387038]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   71.387045]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   71.387051]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   71.387058]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   71.387064]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   71.387072]  [<ffffffff802d9d03>] do_wp_page+0x323/0x6e0
[   71.387078]  [<ffffffff802dbca6>] handle_mm_fault+0x5f6/0x890
[   71.387084]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   71.387091]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   71.387097]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   72.402564] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   72.402572] in_atomic(): 0, irqs_disabled(): 1, pid: 4503, name: nm-applet
[   72.402577] INFO: lockdep is turned off.
[   72.402581] irq event stamp: 0
[   72.402584] hardirqs last  enabled at (0): [<(null)>] (null)
[   72.402590] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   72.402602] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   72.402609] softirqs last disabled at (0): [<(null)>] (null)
[   72.402616] Pid: 4503, comm: nm-applet Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   72.402621] Call Trace:
[   72.402630]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   72.402637]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   72.402645]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   72.402651]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   72.402659]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   72.402665]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   72.402672]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   72.402678]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   72.402686]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   72.402692]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   72.402699]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   72.402705]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   73.400318] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   73.400327] in_atomic(): 0, irqs_disabled(): 1, pid: 4510, name: xfce4-terminal
[   73.400332] INFO: lockdep is turned off.
[   73.400335] irq event stamp: 0
[   73.400338] hardirqs last  enabled at (0): [<(null)>] (null)
[   73.400344] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   73.400357] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   73.400365] softirqs last disabled at (0): [<(null)>] (null)
[   73.400372] Pid: 4510, comm: xfce4-terminal Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   73.400377] Call Trace:
[   73.400387]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   73.400393]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   73.400401]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   73.400408]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   73.400416]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   73.400422]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   73.400430]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   73.400436]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   73.400443]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   73.400450]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   73.400457]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   73.400463]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   74.400744] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   74.400753] in_atomic(): 0, irqs_disabled(): 1, pid: 4499, name: python
[   74.400758] INFO: lockdep is turned off.
[   74.400762] irq event stamp: 0
[   74.400765] hardirqs last  enabled at (0): [<(null)>] (null)
[   74.400771] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   74.400783] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   74.400790] softirqs last disabled at (0): [<(null)>] (null)
[   74.400797] Pid: 4499, comm: python Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   74.400802] Call Trace:
[   74.400811]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   74.400818]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   74.400825]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   74.400832]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   74.400839]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   74.400846]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   74.400853]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   74.400859]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   74.400866]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   74.400872]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   74.400878]  [<ffffffff802c1eb9>] find_or_create_page+0x69/0xb0
[   74.400884]  [<ffffffff80325771>] __getblk+0x111/0x350
[   74.400892]  [<ffffffff8037e1e9>] search_by_key+0x89/0xf70
[   74.400898]  [<ffffffff802f7da5>] ? cache_alloc_refill+0x95/0x2b0
[   74.400905]  [<ffffffff80445048>] ? __raw_spin_lock_init+0x38/0x70
[   74.400913]  [<ffffffff8036c43e>] reiserfs_read_locked_inode+0x7e/0x5f0
[   74.400920]  [<ffffffff8036a8d0>] ? reiserfs_init_locked_inode+0x0/0x20
[   74.400927]  [<ffffffff8036ca5d>] reiserfs_iget+0xad/0xd0
[   74.400932]  [<ffffffff8037e0d0>] ? pathrelse+0x40/0x60
[   74.400938]  [<ffffffff80368c25>] reiserfs_lookup+0x105/0x180
[   74.400944]  [<ffffffff8077c803>] ? rt_spin_lock+0x93/0xb0
[   74.400951]  [<ffffffff803085c6>] do_lookup+0x206/0x260
[   74.400957]  [<ffffffff8030a8fb>] __link_path_walk+0x78b/0x1030
[   74.400963]  [<ffffffff8030b3ee>] path_walk+0x6e/0xe0
[   74.400969]  [<ffffffff8030b5d6>] do_path_lookup+0xb6/0x230
[   74.400974]  [<ffffffff8030a106>] ? getname+0x1c6/0x230
[   74.400980]  [<ffffffff8030c50b>] user_path_at+0x7b/0xb0
[   74.400986]  [<ffffffff803031e8>] ? cp_new_stat+0xe8/0x100
[   74.400992]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   74.400998]  [<ffffffff8030360d>] vfs_stat_fd+0x2d/0x60
[   74.401004]  [<ffffffff803036ec>] sys_newstat+0x2c/0x50
[   74.401010]  [<ffffffff80280ed9>] ? trace_hardirqs_on_caller+0x29/0x1f0
[   74.401016]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   74.401022]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   75.400153] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   75.400162] in_atomic(): 0, irqs_disabled(): 1, pid: 4514, name: geany
[   75.400167] INFO: lockdep is turned off.
[   75.400171] irq event stamp: 0
[   75.400174] hardirqs last  enabled at (0): [<(null)>] (null)
[   75.400180] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   75.400192] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   75.400199] softirqs last disabled at (0): [<(null)>] (null)
[   75.400206] Pid: 4514, comm: geany Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   75.400211] Call Trace:
[   75.400221]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   75.400227]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   75.400235]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   75.400241]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   75.400249]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   75.400255]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   75.400263]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   75.400269]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   75.400276]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   75.400282]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   75.400289]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   75.400295]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   76.402822] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   76.402831] in_atomic(): 0, irqs_disabled(): 1, pid: 4589, name: bash
[   76.402835] INFO: lockdep is turned off.
[   76.402839] irq event stamp: 0
[   76.402842] hardirqs last  enabled at (0): [<(null)>] (null)
[   76.402848] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   76.402861] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   76.402868] softirqs last disabled at (0): [<(null)>] (null)
[   76.402876] Pid: 4589, comm: bash Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   76.402880] Call Trace:
[   76.402890]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   76.402896]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   76.402904]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   76.402910]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   76.402917]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   76.402924]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   76.402932]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   76.402938]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   76.402945]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   76.402951]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   76.402958]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   76.402964]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   77.405166] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   77.405176] in_atomic(): 0, irqs_disabled(): 1, pid: 4514, name: geany
[   77.405180] INFO: lockdep is turned off.
[   77.405184] irq event stamp: 0
[   77.405187] hardirqs last  enabled at (0): [<(null)>] (null)
[   77.405193] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   77.405205] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   77.405212] softirqs last disabled at (0): [<(null)>] (null)
[   77.405219] Pid: 4514, comm: geany Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   77.405224] Call Trace:
[   77.405233]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   77.405240]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   77.405247]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   77.405253]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   77.405261]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   77.405267]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   77.405274]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   77.405280]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   77.405287]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   77.405294]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   77.405300]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   77.405306]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   77.405313]  [<ffffffff802c0a8b>] ? file_read_actor+0x6b/0x190
[   77.405319]  [<ffffffff802c0a41>] ? file_read_actor+0x21/0x190
[   77.405325]  [<ffffffff802c3031>] generic_file_aio_read+0x521/0x6c0
[   77.405332]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   77.405338]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   77.405345]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   77.405351]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   77.405358]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   77.405365]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   77.405371]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   77.405376]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   77.405382]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   78.405258] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   78.405267] in_atomic(): 0, irqs_disabled(): 1, pid: 4583, name: bash
[   78.405271] INFO: lockdep is turned off.
[   78.405275] irq event stamp: 0
[   78.405278] hardirqs last  enabled at (0): [<(null)>] (null)
[   78.405284] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   78.405296] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   78.405304] softirqs last disabled at (0): [<(null)>] (null)
[   78.405311] Pid: 4583, comm: bash Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   78.405316] Call Trace:
[   78.405325]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   78.405331]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   78.405339]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   78.405345]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   78.405353]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   78.405359]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   78.405366]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   78.405372]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   78.405380]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   78.405386]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   78.405393]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   78.405399]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   79.415146] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   79.415155] in_atomic(): 0, irqs_disabled(): 1, pid: 4650, name: apt-cache
[   79.415160] INFO: lockdep is turned off.
[   79.415163] irq event stamp: 0
[   79.415167] hardirqs last  enabled at (0): [<(null)>] (null)
[   79.415173] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   79.415185] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   79.415193] softirqs last disabled at (0): [<(null)>] (null)
[   79.415200] Pid: 4650, comm: apt-cache Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   79.415204] Call Trace:
[   79.415216]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   79.415223]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   79.415230]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   79.415237]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   79.415244]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   79.415251]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   79.415258]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   79.415264]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   79.415271]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   79.415277]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   79.415285]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   79.415292]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   79.415300]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   79.415308]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   79.415314]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   79.415321]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   79.415328]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   79.415334]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   79.415341]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   79.415347]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   79.415353]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   79.415361]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   79.415367]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   80.415481] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   80.415489] in_atomic(): 0, irqs_disabled(): 1, pid: 4650, name: apt-cache
[   80.415494] INFO: lockdep is turned off.
[   80.415498] irq event stamp: 0
[   80.415501] hardirqs last  enabled at (0): [<(null)>] (null)
[   80.415507] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   80.415519] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   80.415526] softirqs last disabled at (0): [<(null)>] (null)
[   80.415533] Pid: 4650, comm: apt-cache Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   80.415538] Call Trace:
[   80.415547]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   80.415554]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   80.415562]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   80.415568]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   80.415575]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   80.415582]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   80.415589]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   80.415595]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   80.415602]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   80.415608]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   80.415615]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   80.415622]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   80.415629]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   80.415636]  [<ffffffff802a813d>] ? __rcu_read_unlock+0xad/0xe0
[   80.415642]  [<ffffffff80280ed9>] ? trace_hardirqs_on_caller+0x29/0x1f0
[   80.415649]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   80.415656]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   80.415662]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   80.415669]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   80.415675]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   80.415682]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   80.415688]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   80.415694]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   80.415701]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   80.415707]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   81.413509] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   81.413518] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   81.413523] INFO: lockdep is turned off.
[   81.413527] irq event stamp: 0
[   81.413530] hardirqs last  enabled at (0): [<(null)>] (null)
[   81.413536] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   81.413548] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   81.413556] softirqs last disabled at (0): [<(null)>] (null)
[   81.413563] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   81.413567] Call Trace:
[   81.413577]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   81.413584]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   81.413591]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   81.413597]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   81.413605]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   81.413611]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   81.413618]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   81.413624]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   81.413632]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   81.413638]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   81.413645]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   81.413651]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   82.418681] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   82.418689] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   82.418694] INFO: lockdep is turned off.
[   82.418698] irq event stamp: 0
[   82.418701] hardirqs last  enabled at (0): [<(null)>] (null)
[   82.418707] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   82.418719] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   82.418726] softirqs last disabled at (0): [<(null)>] (null)
[   82.418733] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   82.418738] Call Trace:
[   82.418747]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   82.418754]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   82.418761]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   82.418768]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   82.418775]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   82.418781]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   82.418788]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   82.418794]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   82.418802]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   82.418808]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   82.418815]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   82.418821]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   83.416791] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   83.416799] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   83.416804] INFO: lockdep is turned off.
[   83.416808] irq event stamp: 0
[   83.416811] hardirqs last  enabled at (0): [<(null)>] (null)
[   83.416817] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   83.416829] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   83.416836] softirqs last disabled at (0): [<(null)>] (null)
[   83.416843] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   83.416848] Call Trace:
[   83.416857]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   83.416864]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   83.416871]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   83.416878]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   83.416886]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   83.416892]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   83.416900]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   83.416906]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   83.416913]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   83.416919]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   83.416926]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   83.416932]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   84.435979] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   84.435988] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   84.435993] INFO: lockdep is turned off.
[   84.435997] irq event stamp: 0
[   84.436000] hardirqs last  enabled at (0): [<(null)>] (null)
[   84.436006] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   84.436019] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   84.436027] softirqs last disabled at (0): [<(null)>] (null)
[   84.436034] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   84.436039] Call Trace:
[   84.436049]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   84.436055]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   84.436064]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   84.436071]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   84.436079]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   84.436085]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   84.436093]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   84.436099]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   84.436106]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   84.436112]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   84.436120]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   84.436126]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   85.432123] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   85.432132] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   85.432137] INFO: lockdep is turned off.
[   85.432141] irq event stamp: 0
[   85.432144] hardirqs last  enabled at (0): [<(null)>] (null)
[   85.432150] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   85.432162] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   85.432170] softirqs last disabled at (0): [<(null)>] (null)
[   85.432177] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   85.432182] Call Trace:
[   85.432191]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   85.432198]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   85.432205]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   85.432212]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   85.432219]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   85.432226]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   85.432233]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   85.432239]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   85.432247]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   85.432253]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   85.432260]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   85.432266]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   86.454653] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   86.454662] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   86.454667] INFO: lockdep is turned off.
[   86.454671] irq event stamp: 0
[   86.454674] hardirqs last  enabled at (0): [<(null)>] (null)
[   86.454680] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   86.454692] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   86.454699] softirqs last disabled at (0): [<(null)>] (null)
[   86.454706] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   86.454711] Call Trace:
[   86.454720]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   86.454727]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   86.454734]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   86.454741]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   86.454748]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   86.454755]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   86.454762]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   86.454768]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   86.454775]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   86.454781]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   86.454789]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   86.454795]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   87.453221] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   87.453230] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   87.453235] INFO: lockdep is turned off.
[   87.453239] irq event stamp: 0
[   87.453242] hardirqs last  enabled at (0): [<(null)>] (null)
[   87.453248] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   87.453260] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   87.453267] softirqs last disabled at (0): [<(null)>] (null)
[   87.453274] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   87.453279] Call Trace:
[   87.453288]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   87.453295]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   87.453302]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   87.453308]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   87.453316]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   87.453322]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   87.453330]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   87.453336]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   87.453343]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   87.453349]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   87.453356]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   87.453362]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   88.478497] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   88.478507] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   88.478512] INFO: lockdep is turned off.
[   88.478515] irq event stamp: 0
[   88.478518] hardirqs last  enabled at (0): [<(null)>] (null)
[   88.478524] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   88.478537] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   88.478544] softirqs last disabled at (0): [<(null)>] (null)
[   88.478551] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   88.478556] Call Trace:
[   88.478566]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   88.478572]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   88.478580]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   88.478587]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   88.478594]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   88.478600]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   88.478608]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   88.478614]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   88.478621]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   88.478627]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   88.478634]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   88.478640]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   89.484892] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   89.484900] in_atomic(): 0, irqs_disabled(): 1, pid: 4674, name: linux32
[   89.484905] INFO: lockdep is turned off.
[   89.484909] irq event stamp: 0
[   89.484912] hardirqs last  enabled at (0): [<(null)>] (null)
[   89.484918] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   89.484930] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   89.484937] softirqs last disabled at (0): [<(null)>] (null)
[   89.484944] Pid: 4674, comm: linux32 Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   89.484949] Call Trace:
[   89.484958]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   89.484965]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   89.484972]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   89.484979]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   89.484987]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   89.484993]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   89.485000]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   89.485006]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   89.485013]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   89.485019]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   89.485027]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   89.485034]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   89.485042]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   89.485049]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   89.485055]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   89.485062]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   89.485068]  [<ffffffff802cba73>] ondemand_readahead+0x193/0x210
[   89.485075]  [<ffffffff802cbbd5>] page_cache_sync_readahead+0x25/0x30
[   89.485081]  [<ffffffff802c2f64>] generic_file_aio_read+0x454/0x6c0
[   89.485088]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   89.485094]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   89.485100]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   89.485106]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
[   89.485113]  [<ffffffff80308020>] ? deny_write_access+0x30/0x70
[   89.485119]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   89.485127]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   89.485133]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   89.485139]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   89.485145]  [<ffffffff8030550f>] kernel_read+0x3f/0x60
[   89.485151]  [<ffffffff803492ee>] load_elf_binary+0x1b6e/0x2020
[   89.485158]  [<ffffffff802cc768>] ? __lru_cache_add+0x48/0xd0
[   89.485165]  [<ffffffff802da2f7>] ? follow_page+0x237/0x340
[   89.485171]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
[   89.485177]  [<ffffffff802da3ae>] ? follow_page+0x2ee/0x340
[   89.485183]  [<ffffffff802dc06c>] ? __get_user_pages+0x12c/0x4c0
[   89.485189]  [<ffffffff8077d63d>] ? __spin_unlock_irqrestore+0x6d/0x80
[   89.485195]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   89.485201]  [<ffffffff8077d63d>] ? __spin_unlock_irqrestore+0x6d/0x80
[   89.485207]  [<ffffffff80347780>] ? load_elf_binary+0x0/0x2020
[   89.485212]  [<ffffffff80304857>] search_binary_handler+0xc7/0x240
[   89.485218]  [<ffffffff80305eac>] do_execve+0x22c/0x2a0
[   89.485225]  [<ffffffff8021057e>] sys_execve+0x4e/0x80
[   89.485231]  [<ffffffff8021298a>] stub_execve+0x6a/0xc0
[   90.486459] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   90.486468] in_atomic(): 0, irqs_disabled(): 1, pid: 4674, name: npviewer.bin
[   90.486472] INFO: lockdep is turned off.
[   90.486476] irq event stamp: 0
[   90.486479] hardirqs last  enabled at (0): [<(null)>] (null)
[   90.486485] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   90.486497] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   90.486505] softirqs last disabled at (0): [<(null)>] (null)
[   90.486512] Pid: 4674, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   90.486517] Call Trace:
[   90.486526]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   90.486533]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   90.486540]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   90.486547]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   90.486554]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   90.486560]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   90.486568]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   90.486574]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   90.486581]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   90.486587]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   90.486594]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   90.486601]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   90.486609]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   90.486616]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   90.486622]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   90.486629]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   90.486636]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   90.486641]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   90.486649]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   90.486654]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   90.486661]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   90.486667]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   90.486674]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   90.486680]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   91.537577] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   91.537586] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   91.537591] INFO: lockdep is turned off.
[   91.537595] irq event stamp: 0
[   91.537598] hardirqs last  enabled at (0): [<(null)>] (null)
[   91.537604] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   91.537616] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   91.537624] softirqs last disabled at (0): [<(null)>] (null)
[   91.537631] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   91.537636] Call Trace:
[   91.537645]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   91.537651]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   91.537659]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   91.537666]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   91.537673]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   91.537679]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   91.537687]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   91.537692]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   91.537700]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   91.537706]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   91.537713]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   91.537719]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   92.548199] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   92.548208] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[   92.548212] INFO: lockdep is turned off.
[   92.548216] irq event stamp: 0
[   92.548219] hardirqs last  enabled at (0): [<(null)>] (null)
[   92.548225] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   92.548237] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   92.548245] softirqs last disabled at (0): [<(null)>] (null)
[   92.548252] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   92.548257] Call Trace:
[   92.548266]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   92.548273]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   92.548280]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   92.548286]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   92.548294]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   92.548300]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   92.548308]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   92.548313]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   92.548321]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   92.548327]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   92.548334]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   92.548340]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   93.602269] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   93.602278] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[   93.602283] INFO: lockdep is turned off.
[   93.602287] irq event stamp: 0
[   93.602290] hardirqs last  enabled at (0): [<(null)>] (null)
[   93.602296] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   93.602308] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   93.602315] softirqs last disabled at (0): [<(null)>] (null)
[   93.602322] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   93.602327] Call Trace:
[   93.602336]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   93.602343]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   93.602350]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   93.602357]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   93.602364]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   93.602370]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   93.602378]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   93.602384]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   93.602391]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   93.602397]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   93.602404]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   93.602411]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   93.602418]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   93.602426]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   93.602432]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   93.602439]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   93.602445]  [<ffffffff802cb736>] do_page_cache_readahead+0x66/0x90
[   93.602451]  [<ffffffff802c1be2>] filemap_fault+0x352/0x4f0
[   93.602458]  [<ffffffff802d9285>] __do_fault+0x55/0x4c0
[   93.602464]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   93.602470]  [<ffffffff802db8b5>] handle_mm_fault+0x205/0x890
[   93.602476]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   93.602483]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   93.602489]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   94.604670] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   94.604680] in_atomic(): 0, irqs_disabled(): 1, pid: 4441, name: firefox
[   94.604685] INFO: lockdep is turned off.
[   94.604688] irq event stamp: 0
[   94.604692] hardirqs last  enabled at (0): [<(null)>] (null)
[   94.604697] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   94.604709] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   94.604717] softirqs last disabled at (0): [<(null)>] (null)
[   94.604724] Pid: 4441, comm: firefox Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   94.604729] Call Trace:
[   94.604738]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   94.604745]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   94.604752]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   94.604759]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   94.604766]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   94.604772]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   94.604780]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   94.604785]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   94.604793]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   94.604798]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   94.604806]  [<ffffffff8032f4dc>] mpage_readpages+0xbc/0x130
[   94.604813]  [<ffffffff8036dee0>] ? reiserfs_get_block+0x0/0x1210
[   94.604820]  [<ffffffff802c8e23>] ? __alloc_pages_internal+0xf3/0x510
[   94.604828]  [<ffffffff8036b8e0>] ? reiserfs_readpages+0x0/0x30
[   94.604834]  [<ffffffff8036b8ff>] reiserfs_readpages+0x1f/0x30
[   94.604840]  [<ffffffff802cb5f1>] __do_page_cache_readahead+0x181/0x260
[   94.604847]  [<ffffffff802cbae5>] ondemand_readahead+0x205/0x210
[   94.604853]  [<ffffffff802cbbd5>] page_cache_sync_readahead+0x25/0x30
[   94.604859]  [<ffffffff802c2f64>] generic_file_aio_read+0x454/0x6c0
[   94.604866]  [<ffffffff802ff040>] ? do_sync_read+0x0/0x140
[   94.604872]  [<ffffffff802ff139>] do_sync_read+0xf9/0x140
[   94.604879]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   94.604885]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   94.604892]  [<ffffffff803cfc39>] ? cap_file_permission+0x9/0x10
[   94.604899]  [<ffffffff803cea36>] ? security_file_permission+0x16/0x20
[   94.604905]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   94.604911]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   94.604917]  [<ffffffff80212422>] system_call_fastpath+0x16/0x1b
[   95.614963] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   95.614972] in_atomic(): 0, irqs_disabled(): 1, pid: 4076, name: Xorg
[   95.614977] INFO: lockdep is turned off.
[   95.614981] irq event stamp: 0
[   95.614984] hardirqs last  enabled at (0): [<(null)>] (null)
[   95.614990] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   95.615002] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   95.615010] softirqs last disabled at (0): [<(null)>] (null)
[   95.615017] Pid: 4076, comm: Xorg Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   95.615022] Call Trace:
[   95.615031]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   95.615038]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   95.615045]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   95.615052]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   95.615059]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   95.615065]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   95.615074]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   95.615080]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   95.615088]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   95.615094]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   95.615103]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   95.615109]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   96.657001] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   96.657011] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[   96.657016] INFO: lockdep is turned off.
[   96.657020] irq event stamp: 0
[   96.657023] hardirqs last  enabled at (0): [<(null)>] (null)
[   96.657029] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   96.657042] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   96.657049] softirqs last disabled at (0): [<(null)>] (null)
[   96.657056] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   96.657061] Call Trace:
[   96.657071]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   96.657077]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   96.657085]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   96.657091]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   96.657099]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   96.657105]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   96.657113]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   96.657119]  [<ffffffff802fc49d>] mem_cgroup_newpage_charge+0x5d/0x60
[   96.657127]  [<ffffffff802dba37>] handle_mm_fault+0x387/0x890
[   96.657133]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   96.657140]  [<ffffffff8023495e>] do_page_fault+0x11e/0x2a0
[   96.657146]  [<ffffffff8077e5a5>] page_fault+0x25/0x30
[   96.657154]  [<ffffffff8043d6dd>] ? copy_user_generic_string+0x2d/0x40
[   96.657161]  [<ffffffff8031cb6a>] ? seq_read+0x2aa/0x370
[   96.657167]  [<ffffffff8031c8c0>] ? seq_read+0x0/0x370
[   96.657174]  [<ffffffff8034bf74>] proc_reg_read+0x84/0xc0
[   96.657180]  [<ffffffff802ffe18>] vfs_read+0xc8/0x190
[   96.657186]  [<ffffffff802fffe5>] sys_read+0x55/0x90
[   96.657193]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[   96.657198]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   97.670557] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   97.670566] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[   97.670570] INFO: lockdep is turned off.
[   97.670574] irq event stamp: 0
[   97.670577] hardirqs last  enabled at (0): [<(null)>] (null)
[   97.670583] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   97.670595] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   97.670602] softirqs last disabled at (0): [<(null)>] (null)
[   97.670609] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   97.670614] Call Trace:
[   97.670623]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   97.670630]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   97.670638]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   97.670644]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   97.670652]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   97.670658]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   97.670666]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   97.670672]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   97.670678]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   97.670685]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   97.670690]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[   97.670697]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   97.670704]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[   97.670710]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   97.670716]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[   97.670723]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[   97.670730]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[   97.670737]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[   97.670744]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   97.670750]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   97.670756]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[   97.670762]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[   97.670767]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[   97.670775]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[   97.670781]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   98.670643] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   98.670652] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[   98.670657] INFO: lockdep is turned off.
[   98.670660] irq event stamp: 0
[   98.670664] hardirqs last  enabled at (0): [<(null)>] (null)
[   98.670669] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   98.670681] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   98.670689] softirqs last disabled at (0): [<(null)>] (null)
[   98.670696] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   98.670700] Call Trace:
[   98.670710]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   98.670716]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   98.670723]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   98.670730]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   98.670738]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   98.670744]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   98.670751]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   98.670757]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   98.670764]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   98.670770]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   98.670776]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[   98.670782]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   98.670790]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[   98.670796]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   98.670802]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[   98.670809]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[   98.670816]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[   98.670823]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[   98.670830]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   98.670836]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   98.670842]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[   98.670848]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[   98.670853]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[   98.670861]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[   98.670866]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   99.707188] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[   99.707197] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[   99.707202] INFO: lockdep is turned off.
[   99.707206] irq event stamp: 0
[   99.707209] hardirqs last  enabled at (0): [<(null)>] (null)
[   99.707215] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   99.707226] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[   99.707234] softirqs last disabled at (0): [<(null)>] (null)
[   99.707241] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[   99.707245] Call Trace:
[   99.707254]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[   99.707261]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[   99.707268]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[   99.707275]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[   99.707283]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[   99.707289]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[   99.707297]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   99.707302]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[   99.707309]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[   99.707315]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[   99.707321]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[   99.707327]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   99.707335]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[   99.707341]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   99.707347]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[   99.707354]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[   99.707361]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[   99.707367]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[   99.707374]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[   99.707381]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[   99.707386]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[   99.707392]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[   99.707398]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[   99.707406]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[   99.707411]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  100.712941] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  100.712950] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  100.712955] INFO: lockdep is turned off.
[  100.712959] irq event stamp: 0
[  100.712962] hardirqs last  enabled at (0): [<(null)>] (null)
[  100.712968] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  100.712980] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  100.712987] softirqs last disabled at (0): [<(null)>] (null)
[  100.712994] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  100.712999] Call Trace:
[  100.713008]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  100.713015]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  100.713023]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  100.713030]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  100.713038]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  100.713044]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  100.713052]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  100.713058]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  100.713066]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  100.713072]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  100.713078]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  100.713084]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  100.713092]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  100.713098]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  100.713104]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  100.713112]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  100.713118]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  100.713125]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  100.713132]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  100.713139]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  100.713145]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  100.713151]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  100.713157]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  100.713164]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  100.713170]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  101.714983] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  101.714992] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  101.714997] INFO: lockdep is turned off.
[  101.715001] irq event stamp: 0
[  101.715004] hardirqs last  enabled at (0): [<(null)>] (null)
[  101.715010] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  101.715022] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  101.715029] softirqs last disabled at (0): [<(null)>] (null)
[  101.715036] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  101.715041] Call Trace:
[  101.715050]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  101.715057]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  101.715064]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  101.715071]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  101.715080]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  101.715086]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  101.715094]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  101.715100]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  101.715107]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  101.715113]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  101.715119]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  101.715125]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  101.715134]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  101.715140]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  101.715146]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  101.715153]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  101.715160]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  101.715167]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  101.715174]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  101.715180]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  101.715187]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  101.715192]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  101.715198]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  101.715206]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  101.715212]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  102.714789] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  102.714798] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  102.714803] INFO: lockdep is turned off.
[  102.714807] irq event stamp: 0
[  102.714810] hardirqs last  enabled at (0): [<(null)>] (null)
[  102.714816] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  102.714828] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  102.714835] softirqs last disabled at (0): [<(null)>] (null)
[  102.714842] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  102.714847] Call Trace:
[  102.714856]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  102.714863]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  102.714870]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  102.714877]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  102.714885]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  102.714891]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  102.714899]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  102.714905]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  102.714912]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  102.714918]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  102.714924]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  102.714930]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  102.714938]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  102.714944]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  102.714950]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  102.714957]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  102.714964]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  102.714971]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  102.714978]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  102.714985]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  102.714991]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  102.714997]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  102.715002]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  102.715010]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  102.715016]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  103.715104] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  103.715113] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  103.715118] INFO: lockdep is turned off.
[  103.715122] irq event stamp: 0
[  103.715125] hardirqs last  enabled at (0): [<(null)>] (null)
[  103.715130] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  103.715143] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  103.715150] softirqs last disabled at (0): [<(null)>] (null)
[  103.715157] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  103.715162] Call Trace:
[  103.715171]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  103.715177]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  103.715185]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  103.715192]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  103.715199]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  103.715206]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  103.715213]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  103.715219]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  103.715226]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  103.715233]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  103.715239]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  103.715245]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  103.715252]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  103.715258]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  103.715265]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  103.715272]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  103.715279]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  103.715285]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  103.715293]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  103.715299]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  103.715305]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  103.715311]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  103.715317]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  103.715325]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  103.715331]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  104.738641] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  104.738650] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  104.738655] INFO: lockdep is turned off.
[  104.738659] irq event stamp: 0
[  104.738662] hardirqs last  enabled at (0): [<(null)>] (null)
[  104.738668] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  104.738680] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  104.738687] softirqs last disabled at (0): [<(null)>] (null)
[  104.738694] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  104.738699] Call Trace:
[  104.738708]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  104.738715]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  104.738723]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  104.738729]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  104.738737]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  104.738743]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  104.738751]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  104.738757]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  104.738764]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  104.738770]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  104.738776]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  104.738783]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  104.738790]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  104.738796]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  104.738802]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  104.738810]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  104.738817]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  104.738823]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  104.738830]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  104.738837]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  104.738843]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  104.738849]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  104.738855]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  104.738862]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  104.738868]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  105.743379] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  105.743388] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  105.743393] INFO: lockdep is turned off.
[  105.743397] irq event stamp: 0
[  105.743400] hardirqs last  enabled at (0): [<(null)>] (null)
[  105.743406] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  105.743417] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  105.743425] softirqs last disabled at (0): [<(null)>] (null)
[  105.743432] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  105.743437] Call Trace:
[  105.743446]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  105.743452]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  105.743460]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  105.743467]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  105.743474]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  105.743480]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  105.743488]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  105.743494]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  105.743501]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  105.743507]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  105.743513]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  105.743520]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  105.743527]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  105.743533]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  105.743540]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  105.743547]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  105.743554]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  105.743560]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  105.743567]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  105.743574]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  105.743580]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  105.743586]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  105.743592]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  105.743599]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  105.743605]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  106.750202] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  106.750211] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  106.750216] INFO: lockdep is turned off.
[  106.750220] irq event stamp: 0
[  106.750223] hardirqs last  enabled at (0): [<(null)>] (null)
[  106.750229] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  106.750241] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  106.750248] softirqs last disabled at (0): [<(null)>] (null)
[  106.750255] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  106.750260] Call Trace:
[  106.750269]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  106.750275]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  106.750283]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  106.750290]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  106.750297]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  106.750304]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  106.750311]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  106.750317]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  106.750324]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  106.750331]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  106.750337]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  106.750343]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  106.750350]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  106.750357]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  106.750363]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  106.750370]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  106.750377]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  106.750383]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  106.750391]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  106.750397]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  106.750403]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  106.750409]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  106.750415]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  106.750423]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  106.750429]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  107.753607] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  107.753616] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  107.753621] INFO: lockdep is turned off.
[  107.753624] irq event stamp: 0
[  107.753628] hardirqs last  enabled at (0): [<(null)>] (null)
[  107.753634] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  107.753645] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  107.753653] softirqs last disabled at (0): [<(null)>] (null)
[  107.753660] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  107.753665] Call Trace:
[  107.753674]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  107.753681]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  107.753688]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  107.753695]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  107.753703]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  107.753709]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  107.753717]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  107.753723]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  107.753730]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  107.753736]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  107.753742]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  107.753748]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  107.753756]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  107.753762]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  107.753768]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  107.753775]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  107.753782]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  107.753789]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  107.753796]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  107.753803]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  107.753809]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  107.753815]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  107.753821]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  107.753828]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  107.753834]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  108.755818] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  108.755827] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  108.755831] INFO: lockdep is turned off.
[  108.755835] irq event stamp: 0
[  108.755839] hardirqs last  enabled at (0): [<(null)>] (null)
[  108.755844] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  108.755856] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  108.755863] softirqs last disabled at (0): [<(null)>] (null)
[  108.755870] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  108.755875] Call Trace:
[  108.755884]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  108.755890]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  108.755898]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  108.755905]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  108.755912]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  108.755919]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  108.755927]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  108.755933]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  108.755940]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  108.755946]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  108.755952]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  108.755958]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  108.755966]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  108.755972]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  108.755978]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  108.755985]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  108.755992]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  108.755999]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  108.756006]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  108.756013]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  108.756019]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  108.756025]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  108.756031]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  108.756038]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  108.756044]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  109.775203] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  109.775211] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  109.775216] INFO: lockdep is turned off.
[  109.775220] irq event stamp: 0
[  109.775223] hardirqs last  enabled at (0): [<(null)>] (null)
[  109.775229] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  109.775241] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  109.775248] softirqs last disabled at (0): [<(null)>] (null)
[  109.775255] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  109.775260] Call Trace:
[  109.775270]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  109.775277]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  109.775284]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  109.775291]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  109.775298]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  109.775305]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  109.775312]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  109.775319]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  109.775326]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  109.775332]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  109.775338]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  109.775344]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  109.775352]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  109.775358]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  109.775364]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  109.775371]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  109.775378]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  109.775384]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  109.775392]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  109.775398]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  109.775404]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  109.775410]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  109.775416]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  109.775423]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  109.775429]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  110.789131] BUG: sleeping function called from invalid context at kernel/rtmutex.c:683
[  110.789140] in_atomic(): 0, irqs_disabled(): 1, pid: 4682, name: npviewer.bin
[  110.789145] INFO: lockdep is turned off.
[  110.789149] irq event stamp: 0
[  110.789152] hardirqs last  enabled at (0): [<(null)>] (null)
[  110.789158] hardirqs last disabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  110.789170] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[  110.789177] softirqs last disabled at (0): [<(null)>] (null)
[  110.789184] Pid: 4682, comm: npviewer.bin Tainted: G        W  2.6.29-rc4-rt1-tip #1
[  110.789189] Call Trace:
[  110.789198]  [<ffffffff8027dfb0>] ? print_irqtrace_events+0xd0/0xe0
[  110.789205]  [<ffffffff8024cd73>] __might_sleep+0x113/0x130
[  110.789212]  [<ffffffff8077c811>] rt_spin_lock+0xa1/0xb0
[  110.789219]  [<ffffffff80296a3d>] res_counter_charge+0x5d/0x130
[  110.789227]  [<ffffffff802fb67f>] __mem_cgroup_try_charge+0x7f/0x180
[  110.789233]  [<ffffffff802fc407>] mem_cgroup_charge_common+0x57/0x90
[  110.789241]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  110.789247]  [<ffffffff802fc753>] mem_cgroup_cache_charge+0xe3/0x140
[  110.789254]  [<ffffffff802c1497>] add_to_page_cache_locked+0x47/0xf0
[  110.789260]  [<ffffffff802c1571>] add_to_page_cache_lru+0x31/0x90
[  110.789266]  [<ffffffff802c166c>] grab_cache_page_write_begin+0x9c/0xc0
[  110.789273]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  110.789280]  [<ffffffff8036b742>] reiserfs_write_begin+0x72/0x210
[  110.789286]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  110.789292]  [<ffffffff802c22a0>] generic_file_buffered_write+0x130/0x300
[  110.789300]  [<ffffffff802c291d>] __generic_file_aio_write_nolock+0x26d/0x460
[  110.789306]  [<ffffffff802c351c>] generic_file_aio_write+0x6c/0xd0
[  110.789313]  [<ffffffff802feff9>] do_sync_write+0xf9/0x140
[  110.789320]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[  110.789327]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[  110.789333]  [<ffffffff80370571>] reiserfs_file_write+0x31/0x70
[  110.789339]  [<ffffffff802ffb4b>] vfs_write+0xcb/0x190
[  110.789345]  [<ffffffff802ffd15>] sys_write+0x55/0x90
[  110.789352]  [<ffffffff8023cf5f>] sysenter_dispatch+0x7/0x33
[  110.789358]  [<ffffffff8077c2c0>] ? trace_hardirqs_on_thunk+0x3a/0x3f

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config-bad

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc4-rt1
# Thu Feb 12 01:05:56 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ASM_SEMAPHORES=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
# CONFIG_TREE_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_NON_STANDARD is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
# CONFIG_X86_DS is not set
# CONFIG_X86_PTRACE_BTS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT_DESKTOP is not set
CONFIG_PREEMPT_RT=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_SOFTIRQS=y
CONFIG_PREEMPT_HARDIRQS=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
CONFIG_HARDIRQS_SW_RESEND=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
# CONFIG_PHONET is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_FCOE is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
CONFIG_IEEE1394_PCILYNX=y
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VIDEO1394=y
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_IWLWIFI_LEDS is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_N_HDLC is not set
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=48
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_HVC_XEN is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_OCORES=y
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=y

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_MAX6875=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I810=y
CONFIG_DRM_I830=y
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=y
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_INTEL=y
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_MBP_NVIDIA=y
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_SSCAPE is not set
# CONFIG_SOUND_VMIDI is not set
# CONFIG_SOUND_TRIX is not set
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
# CONFIG_SOUND_PSS is not set
# CONFIG_SOUND_SB is not set
# CONFIG_SOUND_YM3812 is not set
# CONFIG_SOUND_UART6850 is not set
# CONFIG_SOUND_AEDSP16 is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_V3020=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_SMX=y
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_XEN_BALLOON is not set
CONFIG_XENFS=y
CONFIG_XEN_COMPAT_XENFS=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_ROMFS_FS=y
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="cp437"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_MMIOTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--uAKRQypu60I7Lcqm--

