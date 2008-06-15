Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYFOQik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYFOQik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbYFOQid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:38:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29803 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758449AbYFOQic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:38:32 -0400
Date: Sun, 15 Jun 2008 09:33:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       shaggy@austin.ibm.com
Subject: Re: linux-next: Tree for June 13 (soft lockup)
Message-Id: <20080615093335.fa57f6cb.randy.dunlap@oracle.com>
In-Reply-To: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUG: soft lockup - CPU#2 stuck for 61s! [udevd:30563]
CPU 2:
Modules linked in: jfs(-) parport_pc lp parport tg3 cciss ehci_hcd ohci_hcd uhci_hcd [last unloaded: jfs]
Pid: 30563, comm: udevd Not tainted 2.6.26-rc6-next-20080613 #1
RIP: 0010:[<ffffffff8021d43a>]  [<ffffffff8021d43a>] native_flush_tlb_others+0x6c/0x92
RSP: 0018:ffff810170127c38  EFLAGS: 00000202
RAX: 00000000000008f2 RBX: ffff810170127c68 RCX: 00007fff0fffffff
RDX: 00000000000008f2 RSI: 00000000000000f2 RDI: 0000000000000001
RBP: 00007fff10000000 R08: ffff81017fc02eac R09: ffff810170127c48
R10: 00000000636148a1 R11: 00000000af8ad1dc R12: ffffffff80224b1c
R13: ffff810170127bb8 R14: ffff8100010338c0 R15: 0000000000000282
FS:  00007fd407f48710(0000) GS:ffff81017fc02c80(0000) knlGS:00000000f7fb76c0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fd40765e090 CR3: 0000000172983000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8021d436>] ? native_flush_tlb_others+0x68/0x92
 [<ffffffff8021d67f>] ? flush_tlb_mm+0x63/0x6c
 [<ffffffff80281e19>] ? exit_mmap+0xac/0xef
 [<ffffffff80231961>] ? mmput+0x42/0x98
 [<ffffffff8029f6d2>] ? flush_old_exec+0x4b2/0x7d0
 [<ffffffff802cd20d>] ? load_elf_binary+0x36c/0x1736
 [<ffffffff8029e4f3>] ? put_arg_page+0x9/0xb
 [<ffffffff8029e84b>] ? copy_strings+0x1cc/0x1dd
 [<ffffffff8029e94d>] ? search_binary_handler+0xa9/0x1fe
 [<ffffffff8029fcd9>] ? do_execve+0x14d/0x1da
 [<ffffffff8020a474>] ? sys_execve+0x3e/0x58
 [<ffffffff8020c24a>] ? stub_execve+0x6a/0xc0



This is on x86_64, 4 procs, 8 GB RAM.
Test running was fsx_linux on JFS.  fsx_linux terminated.
Looks like jfs module was being unloaded.

---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
