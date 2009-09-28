Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZI1L0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZI1L0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 07:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbZI1L0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 07:26:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53753 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZI1L0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 07:26:14 -0400
Message-ID: <388eedb15161ebaccb671e1c1fe3af46.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <661de9470909280222g7fef6a0fq947c8e22cfc0029b@mail.gmail.com>
References: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org>
    <20090928154213.8e873dec.kamezawa.hiroyu@jp.fujitsu.com>
    <661de9470909280222g7fef6a0fq947c8e22cfc0029b@mail.gmail.com>
Date: Mon, 28 Sep 2009 20:26:13 +0900 (JST)
Subject: Re: Question: RCU stall detected in memcg (Re: mmotm
 2009-09-25-14-35  uploaded
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
>> akpm@linux-foundation.org wrote:
>>
>>> The mm-of-the-moment snapshot 2009-09-25-14-35 has been uploaded to
>>>
>>> &#160; &#160;http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>> &#160; &#160;git://git.zen-sources.org/zen/mmotm.git
>>>
>>> It contains the following patches against 2.6.31:
>>>
>>
>> At testing my (small) patch, with high memory pressure to
>> memcg+hierarchy+softlimit, following is shown.
>> ==
>> INFO: RCU detected CPU 0 stall (t=10000 jiffies)
>> sending NMI to all CPUs:
>> NMI backtrace for cpu 0
>> CPU 0:
>> Modules linked in: sco bridge stp bnep l2cap crc16 bluetooth rfkill
>> iptabl
>> e_filter ip_tables ip6table_filter ip6_tables x_tables ipv6
>> cpufreq_ondemand acpi_cpufreq dm_mirror dm_region_hash dm_log d
>> m_multipath dm_mod uinput ppdev i2c_i801 pcspkr i2c_core bnx2 sg e1000e
>> parport_pc parport button shpchp megaraid_sas sd_mo
>> d scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded:
>> microcode]
>> &#160;Pid: 2886, comm: ruby Not tainted 2.6.31-mm1 #2 PRIMERGY
>> &#160;RIP: 0010:[<ffffffff810878fe>] &#160;[<ffffffff810878fe>]
trace_hardirqs_off_ca
>> ller+0x3e/0xb RSP: 0018:ffff88004fa03d98 &#160;EFLAGS: 00000006
>> &#160;RAX: 0000000000000046 RBX: 0000000000000c00 RCX: 000000000000e501
>> &#160;RDX: ffff8806133564f0 RSI: 0000000000000002 RDI: ffffffff8102a940
>> &#160;RBP: ffff88004fa03d98 R08: 0000000000000001 R09: 0000000000000000
>> &#160;R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
>> &#160;R13: 0000000000000046 R14: 00000000000000ff R15: ffff88004fa03f48
>> &#160;FS: &#160;00007fdeca0856f0(0000) GS:ffff88004fa00000(0000)
knlGS:0000000000000000
>> &#160;CS: &#160;0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> &#160;CR2: 00007fdeca09e000 CR3: 0000000619fc6000 CR4: 00000000000006f0
>> &#160;DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> &#160;DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> &#160;Call Trace:
>> &#160;<#DB[1]> &#160;<<EOE>> Pid: 2886, comm: ruby Not tainted
2.6.31-mm1 #2
>> &#160;Call Trace:
>> &#160;<NMI> &#160;[<ffffffff8100af79>] ? show_regs+0x49/0x50
>> &#160;[<ffffffff81429385>] nmi_watchdog_tick+0x1e5/0x210
>> &#160;[<ffffffff81428891>] do_nmi+0x1b1/0x2e0
>> &#160;[<ffffffff8142808a>] nmi+0x1a/0x2c
>> &#160;[<ffffffff8102a940>] ? flat_send_IPI_mask+0x90/0xb0
>> &#160;[<ffffffff810878fe>] ? trace_hardirqs_off_caller+0x3e/0xb0
>> &#160;<<EOE>> &#160;<IRQ> &#160;[<ffffffff810884bd>]
trace_hardirqs_off+0xd/0x10
>> &#160;[<ffffffff8102a940>] flat_send_IPI_mask+0x90/0xb0
>> &#160;[<ffffffff8102a9c9>] flat_send_IPI_all+0x69/0x70
>> &#160;[<ffffffff81027372>] arch_trigger_all_cpu_backtrace+0x62/0xa0
>> &#160;[<ffffffff810bff8e>] __rcu_pending+0x7e/0x370
>> &#160;[<ffffffff810c02c7>] rcu_check_callbacks+0x47/0x130
>> &#160;[<ffffffff81063a26>] update_process_times+0x46/0x70
>> &#160;[<ffffffff81085930>] tick_sched_timer+0x60/0x160
>> &#160;[<ffffffff810858d0>] ? tick_sched_timer+0x0/0x160
>> &#160;[<ffffffff8107a03a>] __run_hrtimer+0xba/0x150
>> &#160;[<ffffffff8107a325>] hrtimer_interrupt+0xd5/0x1b0
>> &#160;[<ffffffff81426dfe>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>> &#160;[<ffffffff8142cacd>] smp_apic_timer_interrupt+0x6d/0x9b
>> &#160;[<ffffffff8100cb33>] apic_timer_interrupt+0x13/0x20
>> &#160;<EOI> &#160;[<ffffffff811317b6>] ? mem_cgroup_walk_tree+0x156/0x180
>> &#160;[<ffffffff811316d3>] ? mem_cgroup_walk_tree+0x73/0x180
>> &#160;[<ffffffff81131692>] ? mem_cgroup_walk_tree+0x32/0x180
>> &#160;[<ffffffff81131a00>] ? mem_cgroup_get_local_stat+0x0/0x110
>> &#160;[<ffffffff81131d5b>] ? mem_control_stat_show+0x14b/0x330
>> &#160;[<ffffffff810a57fd>] ? cgroup_seqfile_show+0x3d/0x60
>> &#160;[<ffffffff810a5b90>] ? cgroup_map_add+0x0/0x30
>> &#160;[<ffffffff8115de03>] ? seq_read+0xf3/0x420
>> &#160;[<ffffffff811d9926>] ? security_file_permission+0x16/0x20
>> &#160;[<ffffffff8113b7ec>] ? vfs_read+0xcc/0x190
>> &#160;[<ffffffff8113b9b5>] ? sys_read+0x55/0x90
>> &#160;[<ffffffff8100bf9b>] ? system_call_fastpath+0x16/0x1b
>> .....
>> ==
>> mem_cgroup_walk_tree() is not very young function and I've been doing
>> the
>> same kind of tests but this is 1st messeage for me. So, I'm a bit
>> confused.
>> and not sure how I start debug from...
>>
>> Does this mean mem_cgroup_walk_tree() blocks RCU's progress
>> over 10000 jiffies ? What should I doubt ?
>
> Could you share your test case so that I can reproduce the problem? My
> tests seem to work fine so far
>
Create following hierarchy

  /cgroup/A     .... use_hierarchy=1, softlimit=300M, no task
            /01  .... add task which use much memory
            /02  .... no task
          B     .... add task which use much memory

Then, kswapd will reclaim memory from A/01.

I couldn't reproduce this. I doubt ,y own patch may affect.

Thanks,
-Kame

