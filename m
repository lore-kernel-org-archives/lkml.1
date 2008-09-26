Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYIZPSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYIZPSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbYIZPSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:18:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:55740 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYIZPSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:18:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=i7h1M6h9JRLF9iErhoHnCK/gevYFPENlCPIWL4sLwnCEcm0PX3ZNI14hTzFKPPXpqM
         kc9wiyZGxU9VIxaJ61Ek++RA1aK/TVFFhYf/16eXVaQAgqEOTX2uV8zzZaymU3oeaaY8
         P5duzG1yJogpSZtb44S1QoF12DkIHdNMAXs+c=
Date: Fri, 26 Sep 2008 19:20:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: viro@zeniv.linux.org.uk, ebiederm@xmission.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
Message-ID: <20080926152031.GA30831@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gentlemen, this happened while script was slowly rebuilding 300+ configs
sequentially. Very little recompling activity itself, much seeking.

This is first time I see this. No debugging was on, no preemption.

Version: 2.6.27-rc7-c0f4d6d4b14a75a341d972ff73fb9740e1ceb634 +
	atl1 fixlet + "notes" kobject fixlet, but they don't matter.


ffffffff802bc690 <proc_sys_compare>:
ffffffff802bc690:	48 83 ec 08          	sub    $0x8,%rsp
ffffffff802bc694:	8b 46 04             	mov    0x4(%rsi),%eax
ffffffff802bc697:	3b 42 04             	cmp    0x4(%rdx),%eax
ffffffff802bc69a:	49 89 f0             	mov    %rsi,%r8
ffffffff802bc69d:	74 11                	je     ffffffff802bc6b0 <proc_sys_compare+0x20>
ffffffff802bc69f:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff802bc6a4:	48 83 c4 08          	add    $0x8,%rsp
ffffffff802bc6a8:	c3                   	retq   
ffffffff802bc6a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
ffffffff802bc6b0:	48 8b 76 08          	mov    0x8(%rsi),%rsi
ffffffff802bc6b4:	48 8b 7a 08          	mov    0x8(%rdx),%rdi
ffffffff802bc6b8:	89 c1                	mov    %eax,%ecx
ffffffff802bc6ba:	fc                   	cld    
ffffffff802bc6bb:	48 39 c9             	cmp    %rcx,%rcx
ffffffff802bc6be:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
ffffffff802bc6c0:	75 dd                	jne    ffffffff802bc69f <proc_sys_compare+0xf>
ffffffff802bc6c2:	49 8b 40 e0          	mov    -0x20(%r8),%rax
ffffffff802bc6c6: ===>	48 8b 78 f0          	mov    -0x10(%rax),%rdi		<===
ffffffff802bc6ca:	e8 71 96 f7 ff       	callq  ffffffff80235d40 <sysctl_is_seen>
ffffffff802bc6cf:	85 c0                	test   %eax,%eax
ffffffff802bc6d1:	0f 94 c0             	sete   %al
ffffffff802bc6d4:	48 83 c4 08          	add    $0x8,%rsp
ffffffff802bc6d8:	0f b6 c0             	movzbl %al,%eax
ffffffff802bc6db:	c3                   	retq   
ffffffff802bc6dc:	0f 1f 40 00          	nopl   0x0(%rax)


[16526.029537] BUG: unable to handle kernel paging request at fffffffffffffff0
[16526.029643] IP: [<ffffffff802bc6c6>] proc_sys_compare+0x36/0x50
[16526.029709] PGD 203067 PUD 204067 PMD 0 
[16526.029769] Oops: 0000 [1] SMP 
[16526.029824] CPU 1 
[16526.029872] Modules linked in: af_packet iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables ext2 nls_utf8 ntfs fuse sr_mod cdrom
[16526.030079] Pid: 20385, comm: sh Not tainted 2.6.27-rc7 #1
[16526.030140] RIP: 0010:[<ffffffff802bc6c6>]  [<ffffffff802bc6c6>] proc_sys_compare+0x36/0x50
[16526.030246] RSP: 0018:ffff880108929c58  EFLAGS: 00010246
[16526.030306] RAX: 0000000000000000 RBX: ffff88005246e000 RCX: 0000000000000000
[16526.030374] RDX: ffff880108929d28 RSI: ffff88005246e0af RDI: ffff88017b4fb01c
[16526.030442] RBP: ffff88005246e018 R08: ffff88005246e030 R09: ffff88017b4fb011
[16526.030509] R10: 0000000000000000 R11: 0000000000000005 R12: 0000000032fdb346
[16526.030577] R13: ffff88005246e0c8 R14: ffff880108929d28 R15: 000000000000000b
[16526.030645] FS:  00002b014ad9af40(0000) GS:ffff88017f809680(0000) knlGS:0000000000000000
[16526.030748] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[16526.030811] CR2: fffffffffffffff0 CR3: 000000006a2d6000 CR4: 00000000000006e0
[16526.030879] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16526.030946] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[16526.031014] Process sh (pid: 20385, threadinfo ffff880108928000, task ffff88017f8bab80)
[16526.031118] Stack:  0000000000000000 ffffffff80293242 0000000080555ec0 0000000b7f429320
[16526.031233]  ffff88017b4fb011 ffff880108929d28 ffff88017b4fb01c ffff880108929e68
[16526.031345]  ffff880108929d28 ffff880108929d38 ffff88017b4fb000 ffffffff8028900c
[16526.031419] Call Trace:
[16526.031506]  [<ffffffff80293242>] ? __d_lookup+0xe2/0x120
[16526.031568]  [<ffffffff8028900c>] ? do_lookup+0x3c/0x220
[16526.031629]  [<ffffffff8028a895>] ? __link_path_walk+0x815/0xd90
[16526.031693]  [<ffffffff80266ce7>] ? __do_fault+0x1b7/0x400
[16526.031755]  [<ffffffff8028ae64>] ? path_walk+0x54/0xb0
[16526.033334]  [<ffffffff8028af8a>] ? do_path_lookup+0x7a/0x150
[16526.033397]  [<ffffffff8028bdca>] ? __path_lookup_intent_open+0x6a/0xd0
[16526.033464]  [<ffffffff8028c082>] ? do_filp_open+0xc2/0x820
[16526.033526]  [<ffffffff80296bbf>] ? alloc_fd+0x3f/0x130
[16526.033587]  [<ffffffff8027ed88>] ? do_sys_open+0x58/0xb0
[16526.033648]  [<ffffffff8020b65b>] ? system_call_fastpath+0x16/0x1b
[16526.033711] 
[16526.033754] 
[16526.033797] Code: 89 f0 74 11 b8 01 00 00 00 48 83 c4 08 c3 0f 1f 80 00 00 00 00 48 8b 76 08 48 8b 7a 08 89 c1 fc 48 39 c9 f3 a6 75 dd 49 8b 40 e0 <48> 8b 78 f0 e8 71 96 f7 ff 85 c0 0f 94 c0 48 83 c4 08 0f b6 c0 
[16526.034186] RIP  [<ffffffff802bc6c6>] proc_sys_compare+0x36/0x50
[16526.034251]  RSP <ffff880108929c58>
[16526.034301] CR2: fffffffffffffff0
[16526.034622] ---[ end trace ca38d5cc981185f5 ]---
