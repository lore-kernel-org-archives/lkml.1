Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYE0F1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYE0F1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYE0F1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:27:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:8069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYE0F1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=D8TlLVn4zu8q3qi3XYUuiwwkCjN6BN7DxS1uPoxI1/BfGe2VCwaLjRRkN1IC52roN8HxD4jj6Cu5TvbNp96RltHso4yH0hy1kP5tWbgw03cXKvogDyTFJkMru085A+Oar6sNRH48yxvHZ9Hc193zUxbKvOtFrvbREzN5dt+9QSo=
Date: Tue, 27 May 2008 09:23:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080527052318.GA28301@martell.zuzino.mipt.ru>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_RCU is in use, again. And die counter is 2 because of CFQ oops
I haven't noticed earlier.



0xffffffff802447cb is in find_pid_ns (kernel/pid.c:297).
292             struct hlist_node *elem;
293             struct upid *pnr;
294
295             hlist_for_each_entry_rcu(pnr, elem,
296                             &pid_hash[pid_hashfn(nr, ns)], pid_chain)
297                     if (pnr->nr == nr && pnr->ns == ns)
298                             return container_of(pnr, struct pid,
299                                             numbers[ns->level]);
300
301             return NULL;


general protection fault: 0000 [2] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0 
Modules linked in: ext2 nf_conntrack_irc xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
Pid: 15599, comm: profil01 Tainted: G      D   2.6.26-rc4 #1
RIP: 0010:[<ffffffff802447cb>]  [<ffffffff802447cb>] find_pid_ns+0x6b/0xa0
RSP: 0018:ffff810129021ea8  EFLAGS: 00010202
RAX: ffff810130580948 RBX: 0000000000003cef RCX: ffff81017d865278
RDX: 6b6b6b6b6b6b6b6b RSI: ffffffff80566760 RDI: 0000000000003cef
RBP: ffff810129021ea8 R08: 0000000000000000 R09: 00007f9a93987b70
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000000000011 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f9a9397c6f0(0000) GS:ffffffff805c6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000257f2e8 CR3: 0000000102479000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process profil01 (pid: 15599, threadinfo ffff810129020000, task ffff81004bc24500)
Stack:  ffff810129021eb8 ffffffff8024487d ffff810129021f78 ffffffff8023f275
 0000000000000011 0000000000000000 0000000000003cef ffff810129020000
 ffffffff8061b140 00007f9a93989bc0 00007fff9b98a410 ffffffff8045fd63
Call Trace:
 [<ffffffff8024487d>] find_vpid+0x1d/0x20
 [<ffffffff8023f275>] sys_kill+0x85/0x1b0
 [<ffffffff8045fd63>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8045fcf2>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8023d9e1>] ? lock_task_sighand+0x41/0x80
 [<ffffffff8020b68b>] system_call_after_swapgs+0x7b/0x80
Code: c2 48 c1 e0 02 48 01 c2 48 d3 ea 48 c1 e2 03 48 03 15 72 4a 41 00 48 8b 02 48 85 c0 48 89 c2 75 0a eb 30 48 8b 12 48 85 d2 74 28 <3b> 7a f0 48 8b 02 48 8d 4a f0 0f 18 08 75 e9 48 3b 72 f8 75 e3 
RIP  [<ffffffff802447cb>] find_pid_ns+0x6b/0xa0
 RSP <ffff810129021ea8>
---[ end trace 2cae3e148f7cd27c ]---

