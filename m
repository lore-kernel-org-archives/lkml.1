Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0CDDBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:01:39 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:64009 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0CDDBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:01:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VIftsZuu9E/q1w307WbhshokUk/Efi13XKTG6Jrtm2TUaal/BX0khG1FAeXk5+U/Vb
         84DMvw/DvHtuq0KD9dC6cU0gsU+wh5Ye2gPzCZCYQWYUQGNigAuarThEBadvoHWny0IS
         xwDmAq/qkgFd987J8wA0DZOZdwKT52qxv3lFI=
MIME-Version: 1.0
In-Reply-To: <20100304014641.GH5194@nowhere>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <20100304014641.GH5194@nowhere>
Date: Thu, 4 Mar 2010 11:01:36 +0800
Message-ID: <2375c9f91003031901v19c00c21k4a5d46bbe9ade3f@mail.gmail.com>
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 9:46 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, Mar 03, 2010 at 02:04:23PM +0800, Américo Wang wrote:
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: BUG: soft lockup - CPU#3 stuck for 61s! [kstop/3:4876]
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: Modules linked in: ipt_REJECT xt_tcpudp x_tables bridge stp deflate zlib_deflate ctr cast5 crypto_null ccm serpent blowfish twofish twofish_common ecb xcbc cbc md5 sha256_generic sha512_generic des_generic aes_x86_64 aes_generic ah6 ah4 esp6 esp4 xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6 xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 hidp rfcomm l2cap crc16 bluetooth lockd sunrpc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i iw_cxgb3 ib_core cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand powernow_k8 freq_table dm_multipath scsi_dh video output sbs sbshc power_meter hwmon battery acpi_memhotplug ac parport_pc lp parport sg dcdbas sr_mod cdrom serio_raw rtc_cmos rtc_core rtc_lib tpm_tis tpm tpm_bios button tg3 libphy shpchp i2c_nforce2 i2c_core pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod sata_nv libata sd_mod s
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: si_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: ip_tables]
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: irq event stamp: 51397
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: hardirqs last  enabled at (51396): [<ffffffff8155287c>] restore_args+0x0/0x30
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: hardirqs last disabled at (51397): [<ffffffff81003917>] save_args+0x67/0x70
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: softirqs last  enabled at (6536): [<ffffffff81003881>] return_to_handler+0x0/0x2f
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: softirqs last disabled at (6567): [<ffffffff81003881>] return_to_handler+0x0/0x2f
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: CPU 3
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: Modules linked in: ipt_REJECT xt_tcpudp x_tables bridge stp deflate zlib_deflate ctr cast5 crypto_null ccm serpent blowfish twofish twofish_common ecb xcbc cbc md5 sha256_generic sha512_generic des_generic aes_x86_64 aes_generic ah6 ah4 esp6 esp4 xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport xfrm6_mode_transport xfrm6_mode_beet xfrm6_mode_tunnel ipcomp ipcomp6 xfrm_ipcomp xfrm6_tunnel tunnel6 af_key autofs4 hidp rfcomm l2cap crc16 bluetooth lockd sunrpc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i iw_cxgb3 ib_core cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand powernow_k8 freq_table dm_multipath scsi_dh video output sbs sbshc power_meter hwmon battery acpi_memhotplug ac parport_pc lp parport sg dcdbas sr_mod cdrom serio_raw rtc_cmos rtc_core rtc_lib tpm_tis tpm tpm_bios button tg3 libphy shpchp i2c_nforce2 i2c_core pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod sata_nv libata sd_mod s
>> Mar  3 13:34:37 dhcp-66-70-5 kernel: si_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: ip_tables]
>> Mar  3 13:34:37 dhcp-66-70-5 kernel:
>> Mar  3 13:34:38 dhcp-66-70-5 kernel: Pid: 4876, comm: kstop/3 Not tainted 2.6.33 #31 0J001K/PowerEdge T105
>> Mar  3 13:34:38 dhcp-66-70-5 kernel: RIP: 0010:[<ffffffff8100d3d7>]  [<ffffffff8100d3d7>] native_sched_clock+0x2a/0x69
>> Mar  3 13:34:38 dhcp-66-70-5 kernel: RSP: 0018:ffff88002fe03da0  EFLAGS: 00000246
>> Mar  3 13:34:38 dhcp-66-70-5 kernel: RAX: 00000000b24e3e78 RBX: ffff88002fe03da0 RCX: ffff88002fe03ee0
>> Mar  3 13:34:39 dhcp-66-70-5 kernel: RDX: 0000000000000053 RSI: ffffffff810dfde6 RDI: ffffffff810e138d
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: RBP: ffffffff81003881 R08: 0000000000000110 R09: ffffffff81003896
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: R10: ffff88021697dfd8 R11: 0000000000000000 R12: ffff88002fe03d20
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: R13: ffffffff810e138d R14: ffff8802287a6680 R15: ffffffff81003881
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: FS:  00007fd9db23a720(0000) GS:ffff88002fe00000(0000) knlGS:0000000000000000
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: CR2: 00000000008e42c0 CR3: 0000000219d90000 CR4: 00000000000006e0
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: Process kstop/3 (pid: 4876, threadinfo ffff88021697c000, task ffff8802287a6680)
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: Stack:
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  ffff88002fe03db0 ffffffff810e7407 ffff88002fe03df0 ffffffff810ff331
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: <0> ffff88002ffceec0 ffff88002fe03e98 ffffffff810e138d ffff8802287a6680
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: <0> ffff88002fe03e00 ffffffff810dfde6 ffff88002fe03e40 ffffffff8102cd97
>> Mar  3 13:34:41 dhcp-66-70-5 kernel: Call Trace:
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  <IRQ>
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810e7407>] ? trace_clock_local+0x2c/0x43
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810ff331>] ? ftrace_push_return_trace+0xac/0x17a
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810e138d>] ? __rcu_process_callbacks+0x1d4/0x4a9
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810dfde6>] ? cpu_needs_another_gp+0x4/0x46
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8102cd97>] ? prepare_ftrace_return+0xda/0x138
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8100385a>] ? ftrace_graph_caller+0x4a/0x71
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003896>] ? return_to_handler+0x15/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810dfdeb>] ? cpu_needs_another_gp+0x9/0x46
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81008d3c>] print_context_stack+0xb6/0x144
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81007375>] dump_trace+0x320/0x3bf
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81008979>] show_trace_log_lvl+0x5f/0x72
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8108568d>] ? worker_thread+0x0/0x46c
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8107de2a>] ? exit_signals+0x7/0x253
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8100703f>] show_stack_log_lvl+0x185/0x19b
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81006d50>] ? do_softirq+0x8c/0x181
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81007516>] show_registers+0x102/0x3ac
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8100e739>] show_regs+0x1d/0x53
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810da649>] softlockup_tick+0x268/0x2d2
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  <EOI>
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8107de2a>] ? exit_signals+0x7/0x253
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8102cce7>] ? prepare_ftrace_return+0x2a/0x138
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81066035>] ? do_exit+0x160/0xad0
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8108568d>] ? worker_thread+0x0/0x46c
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8108568d>] ? worker_thread+0x0/0x46c
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8100385a>] ? ftrace_graph_caller+0x4a/0x71
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8107de2f>] ? exit_signals+0xc/0x253
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81066044>] ? do_exit+0x16f/0xad0
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8108ab21>] ? autoremove_wake_function+0x0/0x52
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8108568d>] ? worker_thread+0x0/0x46c
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81076327>] run_local_timers+0x32/0x3b
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81003881>] ? return_to_handler+0x0/0x2f
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff81076547>] update_process_times+0x51/0xa5
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810048d4>] ? kernel_thread_helper+0x4/0x10
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8155287c>] ? restore_args+0x0/0x30
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff8108a4c9>] ? kthread+0x0/0xec
>> Mar  3 13:34:41 dhcp-66-70-5 kernel:  [<ffffffff810048d0>] ? kernel_thread_helper+0x0/0x10
>
>
> So it is stuck in stop machine. I wonder where exactly. I see some do_exit
> at the top but I wonder how much they are reliable.

Well, I think 'kstop' is just random, sometimes I got 'watchdog' or some other
process.

>
> Anyway, as Steve said, we really need a full config to reproduce it.
>

Done in another reply.
