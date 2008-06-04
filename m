Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbYFDOsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbYFDOsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYFDOsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:48:10 -0400
Received: from gw.c1.byte.nl ([82.94.214.64]:56296 "EHLO smtp.byte.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752659AbYFDOsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:48:08 -0400
Message-ID: <4846AB26.5040802@byte.nl>
Date: Wed, 04 Jun 2008 16:48:06 +0200
From: Tristan Linnenbank <tristan@byte.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: file_splice_read problem in 2.6.24.2?
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear lkml,

this afternoon I had a kernel crash on one of my webboxes. 
Halting/rebooting the machine after the crash was not possible. I had to 
power cycle it.

Pid: 22361, comm: apache2 Not tainted (2.6.24.2-fwsh-byte #2)
EIP: 0060:[<c0140967>] EFLAGS: 00000286 CPU: 0
EIP is at find_get_pages_contig+0x67/0x73
EAX: 00000000 EBX: 00000010 ECX: c1c75e20 EDX: c1c75e20
ESI: 00000010 EDI: de5cb920 EBP: 00000010 ESP: d43b7cd8
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b77f8e04 CR3: 0c78a000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
  [<c017c49c>] __generic_file_splice_read+0xa2/0x41e
  [<c0132efc>] clocksource_get_next+0x3a/0x40
  [<c0113b11>] sched_slice+0x15/0x6f
  [<c0110cb8>] read_hpet+0xa/0xd
  [<c0131291>] getnstimeofday+0x31/0x105
  [<f905ee38>] kcs_event+0xb0/0x690 [ipmi_si]
  [<c0134301>] clockevents_program_event+0xbf/0x134
  [<f905c07d>] start_next_msg+0x14/0xa1 [ipmi_si]
  [<c0122ed9>] lock_timer_base+0x27/0x51
  [<c0122f83>] __mod_timer+0x80/0x8e
  [<f905c9ba>] smi_timeout+0x0/0xfe [ipmi_si]
  [<c0123289>] run_timer_softirq+0xcf/0x184
  [<c012a893>] __rcu_process_callbacks+0x76/0xbb
  [<c011f979>] tasklet_action+0x53/0x93
  [<c011f754>] __do_softirq+0xba/0xcf
  [<c017c88d>] generic_file_splice_read+0x75/0xc9
  [<c01eda5c>] nfs_file_splice_read+0x67/0x9d
  [<c017d083>] do_splice_to+0x6e/0x90
  [<c017d144>] splice_direct_to_actor+0x9f/0x166
  [<c017d20b>] direct_splice_actor+0x0/0x31
  [<c017d2a4>] do_splice_direct+0x68/0x8b
  [<c016141a>] do_readv_writev+0x130/0x193
  [<c01617ff>] do_sendfile+0x1f5/0x256
  [<c01618b8>] sys_sendfile+0x58/0xa5
  [<c0102836>] sysenter_past_esp+0x5f/0x85
  =======================

pid 22361 was an apache2 process.
the "-fwsh-byte" suffix to the kernel string indicates a forwarded-share 
patch to the kernel.

We (=the company I work for) had similar kernel crashes before (
see http://article.gmane.org/gmane.linux.nfs/19130, and 
http://article.gmane.org/gmane.linux.nfs/19107). Those crashes were on 
nfs servers, but the webbox is an nfs client.

We switched the webbox to kernel 2.5.25.4 to test if that will fix the 
problem.

Are there any more people that have experienced this issue before?

What information can I provide to ease debugging?

As I am not a member of LKML, could you please CC me in the replies to 
the list?

Thanks in advance.

Kind regards,
Tristan Linnenbank


