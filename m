Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYFEG7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYFEG7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 02:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYFEG7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 02:59:10 -0400
Received: from gw.c1.byte.nl ([82.94.214.64]:50466 "EHLO smtp.byte.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751647AbYFEG7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 02:59:08 -0400
Message-ID: <48478EB5.9020207@byte.nl>
Date: Thu, 05 Jun 2008 08:59:01 +0200
From: Tristan Linnenbank <tristan@byte.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: file_splice_read problem in 2.6.24.2?
References: <4846AB26.5040802@byte.nl> <20080604163559.GS5757@kernel.dk>
In-Reply-To: <20080604163559.GS5757@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> So either this is fixed by this:
> 
> http://git.kernel.dk/?p=linux-2.6.git;a=commit;h=8191ecd1d14c6914c660dfa007154860a7908857
> 
> or it's a different bug. You should post the full oops (including any
> message that came before the oops, like the 'locked up for foo seconds'
> in the urls you reference above) with the Code line at the bottom as
> well so we can see what the registers are used for.
> 
> If it's the bug fixed with the above commit, then 2.6.25.x should
> work. Unfortunately I'm unsure of the -stable status of the above
> patch.
> 
thanks for your reply.

I appended five of the bunch of errors to this mail. They all lock the 
CPU for 11 seconds (just like the nfsd errors we had in February/April), 
so that could be a sign of them being the same bug.

It seems to be the same problem. We've only seen this behaviour once on 
the one machine though. I'll keep a couple of webservers on 2.6.24.2 and 
some on 2.6.25.4, just to see what happens.

Thanks!

Kind regards,

Tristan

Jun  4 15:08:38 web10.c1.internal kernel: BUG: soft lockup - CPU#0 stuck 
for 11s! [apache2:22361]
Jun  4 15:08:38 web10.c1.internal kernel: Jun  4 15:08:38 
web10.c1.internal kernel: Pid: 22361, comm: apache2 Not tainted 
(2.6.24.2-fwsh-byte #2)
Jun  4 15:08:38 web10.c1.internal kernel: EIP: 0060:[<c0140967>] EFLAGS: 
00000286 CPU: 0
Jun  4 15:08:38 web10.c1.internal kernel: EIP is at 
find_get_pages_contig+0x67/0x73
Jun  4 15:08:38 web10.c1.internal kernel: EAX: 00000000 EBX: 00000010 
ECX: c1c75e20 EDX: c1c75e20
Jun  4 15:08:38 web10.c1.internal kernel: ESI: 00000010 EDI: de5cb920 
EBP: 00000010 ESP: d43b7cd8
Jun  4 15:08:38 web10.c1.internal kernel: DS: 007b ES: 007b FS: 00d8 GS: 
0033 SS: 0068
Jun  4 15:08:38 web10.c1.internal kernel: CR0: 8005003b CR2: b77f8e04 
CR3: 0c78a000 CR4: 000006f0
Jun  4 15:08:38 web10.c1.internal kernel: DR0: 00000000 DR1: 00000000 
DR2: 00000000 DR3: 00000000
Jun  4 15:08:38 web10.c1.internal kernel: DR6: ffff0ff0 DR7: 00000400
Jun  4 15:08:38 web10.c1.internal kernel: [<c017c49c>] 
__generic_file_splice_read+0xa2/0x41e
Jun  4 15:08:38 web10.c1.internal kernel: [<c0113b11>] sched_slice+0x15/0x6f
Jun  4 15:08:38 web10.c1.internal kernel: [<c0110cb8>] read_hpet+0xa/0xd
Jun  4 15:08:38 web10.c1.internal kernel: [<c0131291>] 
getnstimeofday+0x31/0x105
Jun  4 15:08:38 web10.c1.internal kernel: [<c0122ed9>] 
lock_timer_base+0x27/0x51
Jun  4 15:08:38 web10.c1.internal kernel: [<c0122f83>] __mod_timer+0x80/0x8e
Jun  4 15:08:38 web10.c1.internal kernel: [<c040dde0>] 
tcp_keepalive_timer+0x0/0x1c4
Jun  4 15:08:38 web10.c1.internal kernel: [<c03d03ce>] 
sk_reset_timer+0xc/0x16
Jun  4 15:08:38 web10.c1.internal kernel: [<c040dd9b>] 
tcp_synack_timer+0x19/0x1d
Jun  4 15:08:38 web10.c1.internal kernel: [<c040df9c>] 
tcp_keepalive_timer+0x1bc/0x1c4
Jun  4 15:08:38 web10.c1.internal kernel: [<c0123289>] 
run_timer_softirq+0xcf/0x184
Jun  4 15:08:38 web10.c1.internal kernel: [<c012a893>] 
__rcu_process_callbacks+0x76/0xbb
Jun  4 15:08:38 web10.c1.internal kernel: [<c011f979>] 
tasklet_action+0x53/0x93
Jun  4 15:08:38 web10.c1.internal kernel: [<c011f754>] 
__do_softirq+0xba/0xcf
Jun  4 15:08:38 web10.c1.internal kernel: [<c017c88d>] 
generic_file_splice_read+0x75/0xc9
Jun  4 15:08:38 web10.c1.internal kernel: [<c01eda5c>] 
nfs_file_splice_read+0x67/0x9d
Jun  4 15:08:38 web10.c1.internal kernel: [<c017d083>] 
do_splice_to+0x6e/0x90
Jun  4 15:08:38 web10.c1.internal kernel: [<c017d144>] 
splice_direct_to_actor+0x9f/0x166
Jun  4 15:08:38 web10.c1.internal kernel: [<c017d20b>] 
direct_splice_actor+0x0/0x31
Jun  4 15:08:38 web10.c1.internal kernel: [<c017d2a4>] 
do_splice_direct+0x68/0x8b
Jun  4 15:08:38 web10.c1.internal kernel: [<c016141a>] 
do_readv_writev+0x130/0x193
Jun  4 15:08:38 web10.c1.internal kernel: [<c01617ff>] 
do_sendfile+0x1f5/0x256
Jun  4 15:08:38 web10.c1.internal kernel: [<c01618b8>] 
sys_sendfile+0x58/0xa5
Jun  4 15:08:38 web10.c1.internal kernel: [<c0102836>] 
sysenter_past_esp+0x5f/0x85
Jun  4 15:08:38 web10.c1.internal kernel: =======================
Jun  4 15:08:50 web10.c1.internal kernel: BUG: soft lockup - CPU#0 stuck 
for 11s! [apache2:22361]
Jun  4 15:08:50 web10.c1.internal kernel: Jun  4 15:08:50 
web10.c1.internal kernel: Pid: 22361, comm: apache2 Not tainted 
(2.6.24.2-fwsh-byte #2)
Jun  4 15:08:50 web10.c1.internal kernel: EIP: 0060:[<c0140967>] EFLAGS: 
00000286 CPU: 0
Jun  4 15:08:50 web10.c1.internal kernel: EIP is at 
find_get_pages_contig+0x67/0x73
Jun  4 15:08:50 web10.c1.internal kernel: EAX: 00000000 EBX: 00000010 
ECX: c1c75e20 EDX: c1c75e20
Jun  4 15:08:50 web10.c1.internal kernel: ESI: 00000010 EDI: de5cb920 
EBP: 00000010 ESP: d43b7cd8
Jun  4 15:08:50 web10.c1.internal kernel: DS: 007b ES: 007b FS: 00d8 GS: 
0033 SS: 0068
Jun  4 15:08:50 web10.c1.internal kernel: CR0: 8005003b CR2: b77f8e04 
CR3: 0c78a000 CR4: 000006f0
Jun  4 15:08:50 web10.c1.internal kernel: DR0: 00000000 DR1: 00000000 
DR2: 00000000 DR3: 00000000
Jun  4 15:08:50 web10.c1.internal kernel: DR6: ffff0ff0 DR7: 00000400
Jun  4 15:08:50 web10.c1.internal kernel: [<c017c49c>] 
__generic_file_splice_read+0xa2/0x41e
Jun  4 15:08:50 web10.c1.internal kernel: [<c0113b11>] sched_slice+0x15/0x6f
Jun  4 15:08:50 web10.c1.internal kernel: [<c0110cb8>] read_hpet+0xa/0xd
Jun  4 15:08:50 web10.c1.internal kernel: [<c0131291>] 
getnstimeofday+0x31/0x105
Jun  4 15:08:50 web10.c1.internal kernel: [<c0134301>] 
clockevents_program_event+0xbf/0x134
Jun  4 15:08:50 web10.c1.internal kernel: [<c012ef49>] 
ktime_get_ts+0x15/0x47
Jun  4 15:08:50 web10.c1.internal kernel: [<c01231ea>] 
run_timer_softirq+0x30/0x184
Jun  4 15:08:50 web10.c1.internal kernel: [<c012a893>] 
__rcu_process_callbacks+0x76/0xbb
Jun  4 15:08:50 web10.c1.internal kernel: [<c011f979>] 
tasklet_action+0x53/0x93
Jun  4 15:08:50 web10.c1.internal kernel: [<c011f754>] 
__do_softirq+0xba/0xcf
Jun  4 15:08:50 web10.c1.internal kernel: [<c017c88d>] 
generic_file_splice_read+0x75/0xc9
Jun  4 15:08:50 web10.c1.internal kernel: [<c01eda5c>] 
nfs_file_splice_read+0x67/0x9d
Jun  4 15:08:50 web10.c1.internal kernel: [<c017d083>] 
do_splice_to+0x6e/0x90
Jun  4 15:08:50 web10.c1.internal kernel: [<c017d144>] 
splice_direct_to_actor+0x9f/0x166
Jun  4 15:08:50 web10.c1.internal kernel: [<c017d20b>] 
direct_splice_actor+0x0/0x31
Jun  4 15:08:50 web10.c1.internal kernel: [<c017d2a4>] 
do_splice_direct+0x68/0x8b
Jun  4 15:08:50 web10.c1.internal kernel: [<c016141a>] 
do_readv_writev+0x130/0x193
Jun  4 15:08:50 web10.c1.internal kernel: [<c01617ff>] 
do_sendfile+0x1f5/0x256
Jun  4 15:08:50 web10.c1.internal kernel: [<c01618b8>] 
sys_sendfile+0x58/0xa5
Jun  4 15:08:50 web10.c1.internal kernel: [<c0102836>] 
sysenter_past_esp+0x5f/0x85
Jun  4 15:08:51 web10.c1.internal kernel: =======================
Jun  4 15:09:02 web10.c1.internal kernel: BUG: soft lockup - CPU#0 stuck 
for 11s! [apache2:22361]
Jun  4 15:09:02 web10.c1.internal kernel: Jun  4 15:09:02 
web10.c1.internal kernel: Pid: 22361, comm: apache2 Not tainted 
(2.6.24.2-fwsh-byte #2)
Jun  4 15:09:02 web10.c1.internal kernel: EIP: 0060:[<c0147bde>] EFLAGS: 
00000246 CPU: 0
Jun  4 15:09:02 web10.c1.internal kernel: EIP is at put_page+0x7/0x20
Jun  4 15:09:02 web10.c1.internal kernel: EAX: 80000028 EBX: 00000010 
ECX: 00000010 EDX: c2180ea0
Jun  4 15:09:02 web10.c1.internal kernel: ESI: 00000000 EDI: de5cb870 
EBP: 00000000 ESP: d43b7ce8
Jun  4 15:09:02 web10.c1.internal kernel: DS: 007b ES: 007b FS: 00d8 GS: 
0033 SS: 0068
Jun  4 15:09:02 web10.c1.internal kernel: CR0: 8005003b CR2: b77f8e04 
CR3: 0c78a000 CR4: 000006f0
Jun  4 15:09:02 web10.c1.internal kernel: DR0: 00000000 DR1: 00000000 
DR2: 00000000 DR3: 00000000
Jun  4 15:09:02 web10.c1.internal kernel: DR6: ffff0ff0 DR7: 00000400
Jun  4 15:09:02 web10.c1.internal kernel: [<c017c6bc>] 
__generic_file_splice_read+0x2c2/0x41e
Jun  4 15:09:02 web10.c1.internal kernel: [<c0113b11>] sched_slice+0x15/0x6f
Jun  4 15:09:02 web10.c1.internal kernel: [<c0110cb8>] read_hpet+0xa/0xd
Jun  4 15:09:02 web10.c1.internal kernel: [<c0131291>] 
getnstimeofday+0x31/0x105
Jun  4 15:09:02 web10.c1.internal kernel: [<f905ee38>] 
kcs_event+0xb0/0x690 [ipmi_si]
Jun  4 15:09:02 web10.c1.internal kernel: [<c0134301>] 
clockevents_program_event+0xbf/0x134
Jun  4 15:09:02 web10.c1.internal kernel: [<f905c07d>] 
start_next_msg+0x14/0xa1 [ipmi_si]
Jun  4 15:09:02 web10.c1.internal kernel: [<c0122ed9>] 
lock_timer_base+0x27/0x51
Jun  4 15:09:02 web10.c1.internal kernel: [<c0122f83>] __mod_timer+0x80/0x8e
Jun  4 15:09:02 web10.c1.internal kernel: [<f905c9ba>] 
smi_timeout+0x0/0xfe [ipmi_si]
Jun  4 15:09:02 web10.c1.internal kernel: [<c0123289>] 
run_timer_softirq+0xcf/0x184
Jun  4 15:09:02 web10.c1.internal kernel: [<c012a893>] 
__rcu_process_callbacks+0x76/0xbb
Jun  4 15:09:02 web10.c1.internal kernel: [<c011f979>] 
tasklet_action+0x53/0x93
Jun  4 15:09:02 web10.c1.internal kernel: [<c011f754>] 
__do_softirq+0xba/0xcf
Jun  4 15:09:02 web10.c1.internal kernel: [<c017c88d>] 
generic_file_splice_read+0x75/0xc9
Jun  4 15:09:02 web10.c1.internal kernel: [<c01eda5c>] 
nfs_file_splice_read+0x67/0x9d
Jun  4 15:09:02 web10.c1.internal kernel: [<c017d083>] 
do_splice_to+0x6e/0x90
Jun  4 15:09:02 web10.c1.internal kernel: [<c017d144>] 
splice_direct_to_actor+0x9f/0x166
Jun  4 15:09:02 web10.c1.internal kernel: [<c017d20b>] 
direct_splice_actor+0x0/0x31
Jun  4 15:09:02 web10.c1.internal kernel: [<c017d2a4>] 
do_splice_direct+0x68/0x8b
Jun  4 15:09:02 web10.c1.internal kernel: [<c016141a>] 
do_readv_writev+0x130/0x193
Jun  4 15:09:02 web10.c1.internal kernel: [<c01617ff>] 
do_sendfile+0x1f5/0x256
Jun  4 15:09:02 web10.c1.internal kernel: [<c01618b8>] 
sys_sendfile+0x58/0xa5
Jun  4 15:09:02 web10.c1.internal kernel: [<c0102836>] 
sysenter_past_esp+0x5f/0x85
Jun  4 15:09:03 web10.c1.internal kernel: =======================
Jun  4 15:09:14 web10.c1.internal kernel: BUG: soft lockup - CPU#0 stuck 
for 11s! [apache2:22361]
Jun  4 15:09:14 web10.c1.internal kernel: Jun  4 15:09:14 
web10.c1.internal kernel: Pid: 22361, comm: apache2 Not tainted 
(2.6.24.2-fwsh-byte #2)
Jun  4 15:09:14 web10.c1.internal kernel: EIP: 0060:[<c0140967>] EFLAGS: 
00000286 CPU: 0
Jun  4 15:09:14 web10.c1.internal kernel: EIP is at 
find_get_pages_contig+0x67/0x73
Jun  4 15:09:14 web10.c1.internal kernel: EAX: 00000000 EBX: 00000010 
ECX: c1c75e20 EDX: c1c75e20
Jun  4 15:09:14 web10.c1.internal kernel: ESI: 00000010 EDI: de5cb920 
EBP: 00000010 ESP: d43b7cd8
Jun  4 15:09:14 web10.c1.internal kernel: DS: 007b ES: 007b FS: 00d8 GS: 
0033 SS: 0068
Jun  4 15:09:14 web10.c1.internal kernel: CR0: 8005003b CR2: b77f8e04 
CR3: 0c78a000 CR4: 000006f0
Jun  4 15:09:14 web10.c1.internal kernel: DR0: 00000000 DR1: 00000000 
DR2: 00000000 DR3: 00000000
Jun  4 15:09:14 web10.c1.internal kernel: DR6: ffff0ff0 DR7: 00000400
Jun  4 15:09:14 web10.c1.internal kernel: [<c017c49c>] 
__generic_file_splice_read+0xa2/0x41e
Jun  4 15:09:14 web10.c1.internal kernel: [<c0113b11>] sched_slice+0x15/0x6f
Jun  4 15:09:14 web10.c1.internal kernel: [<c0110cb8>] read_hpet+0xa/0xd
Jun  4 15:09:14 web10.c1.internal kernel: [<c0131291>] 
getnstimeofday+0x31/0x105
Jun  4 15:09:14 web10.c1.internal kernel: [<f905ee38>] 
kcs_event+0xb0/0x690 [ipmi_si]
Jun  4 15:09:14 web10.c1.internal kernel: [<c0134301>] 
clockevents_program_event+0xbf/0x134
Jun  4 15:09:14 web10.c1.internal kernel: [<f905c07d>] 
start_next_msg+0x14/0xa1 [ipmi_si]
Jun  4 15:09:14 web10.c1.internal kernel: [<c0122ed9>] 
lock_timer_base+0x27/0x51
Jun  4 15:09:14 web10.c1.internal kernel: [<c0122f83>] __mod_timer+0x80/0x8e
Jun  4 15:09:14 web10.c1.internal kernel: [<f905c9ba>] 
smi_timeout+0x0/0xfe [ipmi_si]
Jun  4 15:09:14 web10.c1.internal kernel: [<c0123289>] 
run_timer_softirq+0xcf/0x184
Jun  4 15:09:14 web10.c1.internal kernel: [<c012a893>] 
__rcu_process_callbacks+0x76/0xbb
Jun  4 15:09:14 web10.c1.internal kernel: [<c011f979>] 
tasklet_action+0x53/0x93
Jun  4 15:09:14 web10.c1.internal kernel: [<c011f754>] 
__do_softirq+0xba/0xcf
Jun  4 15:09:14 web10.c1.internal kernel: [<c017c88d>] 
generic_file_splice_read+0x75/0xc9
Jun  4 15:09:14 web10.c1.internal kernel: [<c01eda5c>] 
nfs_file_splice_read+0x67/0x9d
Jun  4 15:09:14 web10.c1.internal kernel: [<c017d083>] 
do_splice_to+0x6e/0x90
Jun  4 15:09:14 web10.c1.internal kernel: [<c017d144>] 
splice_direct_to_actor+0x9f/0x166
Jun  4 15:09:14 web10.c1.internal kernel: [<c017d20b>] 
direct_splice_actor+0x0/0x31
Jun  4 15:09:14 web10.c1.internal kernel: [<c017d2a4>] 
do_splice_direct+0x68/0x8b
Jun  4 15:09:14 web10.c1.internal kernel: [<c016141a>] 
do_readv_writev+0x130/0x193
Jun  4 15:09:14 web10.c1.internal kernel: [<c01617ff>] 
do_sendfile+0x1f5/0x256
Jun  4 15:09:14 web10.c1.internal kernel: [<c01618b8>] 
sys_sendfile+0x58/0xa5
Jun  4 15:09:14 web10.c1.internal kernel: [<c0102836>] 
sysenter_past_esp+0x5f/0x85
Jun  4 15:09:15 web10.c1.internal kernel: =======================
Jun  4 15:09:27 web10.c1.internal kernel: BUG: soft lockup - CPU#0 stuck 
for 11s! [apache2:22361]
Jun  4 15:09:27 web10.c1.internal kernel: Jun  4 15:09:27 
web10.c1.internal kernel: Pid: 22361, comm: apache2 Not tainted 
(2.6.24.2-fwsh-byte #2)
Jun  4 15:09:27 web10.c1.internal kernel: EIP: 0060:[<c0140967>] EFLAGS: 
00000286 CPU: 0
Jun  4 15:09:27 web10.c1.internal kernel: EIP is at 
find_get_pages_contig+0x67/0x73
Jun  4 15:09:27 web10.c1.internal kernel: EAX: 00000000 EBX: 00000010 
ECX: c1c75e20 EDX: c1c75e20
Jun  4 15:09:27 web10.c1.internal kernel: ESI: 00000010 EDI: de5cb920 
EBP: 00000010 ESP: d43b7cd8
Jun  4 15:09:27 web10.c1.internal kernel: DS: 007b ES: 007b FS: 00d8 GS: 
0033 SS: 0068
Jun  4 15:09:27 web10.c1.internal kernel: CR0: 8005003b CR2: b77f8e04 
CR3: 0c78a000 CR4: 000006f0
Jun  4 15:09:27 web10.c1.internal kernel: DR0: 00000000 DR1: 00000000 
DR2: 00000000 DR3: 00000000
Jun  4 15:09:27 web10.c1.internal kernel: DR6: ffff0ff0 DR7: 00000400
Jun  4 15:09:27 web10.c1.internal kernel: [<c017c49c>] 
__generic_file_splice_read+0xa2/0x41e
Jun  4 15:09:27 web10.c1.internal kernel: [<c0132efc>] 
clocksource_get_next+0x3a/0x40
Jun  4 15:09:27 web10.c1.internal kernel: [<c01315cb>] 
change_clocksource+0xc/0x205
Jun  4 15:09:27 web10.c1.internal kernel: [<c0113b11>] sched_slice+0x15/0x6f
Jun  4 15:09:27 web10.c1.internal kernel: [<c0110cb8>] read_hpet+0xa/0xd
Jun  4 15:09:27 web10.c1.internal kernel: [<c0131291>] 
getnstimeofday+0x31/0x105
Jun  4 15:09:27 web10.c1.internal kernel: [<f905ee38>] 
kcs_event+0xb0/0x690 [ipmi_si]
Jun  4 15:09:27 web10.c1.internal kernel: [<c0134301>] 
clockevents_program_event+0xbf/0x134
Jun  4 15:09:27 web10.c1.internal kernel: [<f905c07d>] 
start_next_msg+0x14/0xa1 [ipmi_si]
Jun  4 15:09:27 web10.c1.internal kernel: [<c0122ed9>] 
lock_timer_base+0x27/0x51
Jun  4 15:09:27 web10.c1.internal kernel: [<c0122f83>] __mod_timer+0x80/0x8e
Jun  4 15:09:27 web10.c1.internal kernel: [<f905c9ba>] 
smi_timeout+0x0/0xfe [ipmi_si]
Jun  4 15:09:27 web10.c1.internal kernel: [<c0123289>] 
run_timer_softirq+0xcf/0x184
Jun  4 15:09:27 web10.c1.internal kernel: [<c012a893>] 
__rcu_process_callbacks+0x76/0xbb
Jun  4 15:09:27 web10.c1.internal kernel: [<c011f979>] 
tasklet_action+0x53/0x93
Jun  4 15:09:27 web10.c1.internal kernel: [<c011f754>] 
__do_softirq+0xba/0xcf
Jun  4 15:09:27 web10.c1.internal kernel: [<c017c88d>] 
generic_file_splice_read+0x75/0xc9
Jun  4 15:09:27 web10.c1.internal kernel: [<c01eda5c>] 
nfs_file_splice_read+0x67/0x9d
Jun  4 15:09:27 web10.c1.internal kernel: [<c017d083>] 
do_splice_to+0x6e/0x90
Jun  4 15:09:27 web10.c1.internal kernel: [<c017d144>] 
splice_direct_to_actor+0x9f/0x166
Jun  4 15:09:27 web10.c1.internal kernel: [<c017d20b>] 
direct_splice_actor+0x0/0x31
Jun  4 15:09:27 web10.c1.internal kernel: [<c017d2a4>] 
do_splice_direct+0x68/0x8b
Jun  4 15:09:27 web10.c1.internal kernel: [<c016141a>] 
do_readv_writev+0x130/0x193
Jun  4 15:09:27 web10.c1.internal kernel: [<c01617ff>] 
do_sendfile+0x1f5/0x256
Jun  4 15:09:27 web10.c1.internal kernel: [<c01618b8>] 
sys_sendfile+0x58/0xa5
Jun  4 15:09:27 web10.c1.internal kernel: [<c0102836>] 
sysenter_past_esp+0x5f/0x85
Jun  4 15:09:27 web10.c1.internal kernel: =======================

