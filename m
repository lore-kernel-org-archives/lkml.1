Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYDYWjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYDYWjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755213AbYDYWja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:39:30 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:45222 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYDYWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:39:28 -0400
Date: Fri, 25 Apr 2008 18:39:20 -0400
From: Eric Buddington <ebuddington@verizon.net>
Subject: 2.6.25 BUG: soft lockup
To: linux-kernel@vger.kernel.org
Reply-to: ebuddington@wesleyan.edu
Message-id: <20080425223920.GG8519@sparrow.23.warren.st>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Sempron laptop with kernel 2.6.24.4, I am getting this reliably
after a few minutes of uptime. I am also seeing all accesses to
/dev/hda stuck permanently in D state after that, though I don't know
if that's related. Both are repeatable, though.

clipped from dmesg:
----------------------------------------------------
BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.25 #1)
EIP: 0060:[<c0132a9f>] EFLAGS: 00000293 CPU: 0
EIP is at tick_broadcast_oneshot_control+0xb8/0xc4
EAX: 00000293 EBX: c07020d0 ECX: 00000f6c EDX: c213edcf
ESI: 00000293 EDI: c0631460 EBP: 00000000 ESP: c0686f5c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: 084b5e90 CR3: 0acd2000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0132572>] tick_notify+0x185/0x294
 [<c0496e75>] notifier_call_chain+0x2a/0x47
 [<c012ebe4>] raw_notifier_call_chain+0x9/0xc
 [<c0132116>] clockevents_notify+0x11/0x45
 [<c02ab0dd>] acpi_idle_enter_simple+0x1b6/0x20d
 [<c039b66e>] cpuidle_idle_call+0x56/0x85
 [<c039b618>] cpuidle_idle_call+0x0/0x85
 [<c0105974>] default_idle+0x0/0x74
 [<c010595b>] cpu_idle+0x49/0x62




and from Alt-SysRq-t:
------------------------------------------
cp            D c063b34c     0  5813   1087
       c062c320 00000082 00120050 c063b34c c5721c74 c074c980 00000282 003faf08 
       003faf08 c5721cb4 00000000 c049457e c074c9c8 c074c9c8 003faf08 c012413e 
       c9ee4590 c074c980 c070bd98 c063b480 c0493ff9 00000005 c014ea6c 00000000 
Call Trace:
 [<c049457e>] schedule_timeout+0x72/0x8d
 [<c012413e>] process_timeout+0x0/0x5
 [<c0493ff9>] __sched_text_start+0x11/0x19
 [<c014ea6c>] congestion_wait+0x4c/0x60
 [<c012bcbe>] autoremove_wake_function+0x0/0x2d
 [<c0149f0b>] __alloc_pages+0x282/0x2cd
 [<c0145e9d>] find_or_create_page+0x6d/0xa0
 [<c017d190>] __getblk+0x135/0x2a7
 [<c01bc24b>] ext3_mark_inode_dirty+0x29/0x30
 [<c01b93a3>] read_block_bitmap+0x37/0x11f
 [<c01b9e3e>] ext3_new_blocks+0x176/0x4b8
 [<c01bd401>] ext3_get_blocks_handle+0x32f/0x777
 [<c01c8e63>] do_get_write_access+0x2d2/0x30d
 [<c01c83e8>] __journal_file_buffer+0x7d/0xfe
 [<c01c84ea>] journal_dirty_metadata+0x7c/0x82
 [<c01c5d3f>] __ext3_journal_dirty_metadata+0x13/0x32
 [<c01bbb45>] ext3_mark_iloc_dirty+0x268/0x2c0
 [<c01c0a59>] ext3_mkdir+0x0/0x23f
 [<c01bd950>] ext3_getblk+0x4a/0x15c
 [<c01c92aa>] start_this_handle+0x213/0x26e
 [<c016965f>] permission+0x85/0xc1
 [<c01c0a59>] ext3_mkdir+0x0/0x23f
 [<c01bda75>] ext3_bread+0x13/0x63
 [<c01c0a59>] ext3_mkdir+0x0/0x23f
 [<c01c0b16>] ext3_mkdir+0xbd/0x23f
 [<c01c8191>] ext3_permission+0x0/0xa
 [<c01c0a59>] ext3_mkdir+0x0/0x23f
 [<c016a1b3>] vfs_mkdir+0x54/0x91
 [<c016bc67>] sys_mkdirat+0x84/0xb9
 [<c016bcab>] sys_mkdir+0xf/0x13
 [<c010681a>] syscall_call+0x7/0xb
 =======================
