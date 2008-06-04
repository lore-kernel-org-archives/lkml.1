Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYFDQgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYFDQgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYFDQgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:36:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2781 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbYFDQgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:36:05 -0400
Date: Wed, 4 Jun 2008 18:36:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tristan Linnenbank <tristan@byte.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: file_splice_read problem in 2.6.24.2?
Message-ID: <20080604163559.GS5757@kernel.dk>
References: <4846AB26.5040802@byte.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846AB26.5040802@byte.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04 2008, Tristan Linnenbank wrote:
> Dear lkml,
> 
> this afternoon I had a kernel crash on one of my webboxes. 
> Halting/rebooting the machine after the crash was not possible. I 
> had to power cycle it.
> 
> Pid: 22361, comm: apache2 Not tainted (2.6.24.2-fwsh-byte #2)
> EIP: 0060:[<c0140967>] EFLAGS: 00000286 CPU: 0
> EIP is at find_get_pages_contig+0x67/0x73
> EAX: 00000000 EBX: 00000010 ECX: c1c75e20 EDX: c1c75e20
> ESI: 00000010 EDI: de5cb920 EBP: 00000010 ESP: d43b7cd8
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> CR0: 8005003b CR2: b77f8e04 CR3: 0c78a000 CR4: 000006f0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c017c49c>] __generic_file_splice_read+0xa2/0x41e
>  [<c0132efc>] clocksource_get_next+0x3a/0x40
>  [<c0113b11>] sched_slice+0x15/0x6f
>  [<c0110cb8>] read_hpet+0xa/0xd
>  [<c0131291>] getnstimeofday+0x31/0x105
>  [<f905ee38>] kcs_event+0xb0/0x690 [ipmi_si]
>  [<c0134301>] clockevents_program_event+0xbf/0x134
>  [<f905c07d>] start_next_msg+0x14/0xa1 [ipmi_si]
>  [<c0122ed9>] lock_timer_base+0x27/0x51
>  [<c0122f83>] __mod_timer+0x80/0x8e
>  [<f905c9ba>] smi_timeout+0x0/0xfe [ipmi_si]
>  [<c0123289>] run_timer_softirq+0xcf/0x184
>  [<c012a893>] __rcu_process_callbacks+0x76/0xbb
>  [<c011f979>] tasklet_action+0x53/0x93
>  [<c011f754>] __do_softirq+0xba/0xcf
>  [<c017c88d>] generic_file_splice_read+0x75/0xc9
>  [<c01eda5c>] nfs_file_splice_read+0x67/0x9d
>  [<c017d083>] do_splice_to+0x6e/0x90
>  [<c017d144>] splice_direct_to_actor+0x9f/0x166
>  [<c017d20b>] direct_splice_actor+0x0/0x31
>  [<c017d2a4>] do_splice_direct+0x68/0x8b
>  [<c016141a>] do_readv_writev+0x130/0x193
>  [<c01617ff>] do_sendfile+0x1f5/0x256
>  [<c01618b8>] sys_sendfile+0x58/0xa5
>  [<c0102836>] sysenter_past_esp+0x5f/0x85
>  =======================
> 
> pid 22361 was an apache2 process.
> the "-fwsh-byte" suffix to the kernel string indicates a 
> forwarded-share patch to the kernel.
> 
> We (=the company I work for) had similar kernel crashes before (
> see http://article.gmane.org/gmane.linux.nfs/19130, and 
> http://article.gmane.org/gmane.linux.nfs/19107). Those crashes were 
> on nfs servers, but the webbox is an nfs client.
> 
> We switched the webbox to kernel 2.5.25.4 to test if that will fix 
> the problem.
> 
> Are there any more people that have experienced this issue before?
> 
> What information can I provide to ease debugging?
> 
> As I am not a member of LKML, could you please CC me in the replies 
> to the list?

So either this is fixed by this:

http://git.kernel.dk/?p=linux-2.6.git;a=commit;h=8191ecd1d14c6914c660dfa007154860a7908857

or it's a different bug. You should post the full oops (including any
message that came before the oops, like the 'locked up for foo seconds'
in the urls you reference above) with the Code line at the bottom as
well so we can see what the registers are used for.

If it's the bug fixed with the above commit, then 2.6.25.x should
work. Unfortunately I'm unsure of the -stable status of the above
patch.

-- 
Jens Axboe

