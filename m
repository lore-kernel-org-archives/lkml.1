Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYG1Sti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYG1Sti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYG1Sta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:49:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:22596 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYG1St3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=u5iWBVL2aP3Zi8rUDczBQyVeJ/tKvkS1POc/6kQTd9/mQ0h72T3TE9cGhvCeUmj9xt
         WxD/bluaTNVnRRSHHA+wA2bJsNpVmmHBeQP3knI9zDB38EoLBSb6oMRl+/hckd4mXG5N
         5/zqACqOtwZfx+Xr8ZtOkqpp26nkanReXqQbU=
Date: Mon, 28 Jul 2008 22:49:47 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, torvalds@osdl.org
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: 2.6.26-$sha1: RIP gup_pte_range+0x54/0x120
Message-ID: <20080728184947.GA5041@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version: 2.6.26-837b41b5de356aa67abb2cadb5eef3efc7776f91
Core2 Duo, x86_64, 4 GB of RAM.

Kernel is "tainted" with ZFS driver, but it can so little, and
probability of screwup is very little too. :-)


Long LTP session finally ended with

BUG: unable to handle kernel paging request at ffff88012b60c000
IP: [<ffffffff80223ff4>] gup_pte_range+0x54/0x120
PGD 202063 PUD a067 PMD 17cedc163 PTE 800000012b60c160
Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0 
Modules linked in: zfs iptable_raw xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 ip_tables x_tables nf_conntrack_irc nf_conntrack fuse usblp uhci_hcd ehci_hcd usbcore sr_mod cdrom [last unloaded: zfs]
Pid: 16863, comm: vmsplice01 Tainted: G        W 2.6.26-zfs #2
RIP: 0010:[<ffffffff80223ff4>]  [<ffffffff80223ff4>] gup_pte_range+0x54/0x120
RSP: 0018:ffff88012ff57c68  EFLAGS: 00010096
RAX: 0000000000000008 RBX: 00007fff4a800000 RCX: 0000000000000001
RDX: ffffe200040b5f00 RSI: 00007fff4a800310 RDI: ffff88012b60c000
RBP: ffff88012ff57c78 R08: 0000000000000005 R09: ffff88012ff57cec
R10: 0000000000000024 R11: 0000000000000205 R12: ffff88012ff57e58
R13: 00007fff4a807310 R14: 00007fff4a80730f R15: ffff88012ff57e58
FS:  00007fbb4280b6f0(0000) GS:ffffffff805dec40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88012b60c000 CR3: 000000017e294000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vmsplice01 (pid: 16863, threadinfo ffff88012ff56000, task ffff88015f9db360)
Stack:  00007fff4a800000 ffff88010e6cf298 ffff88012ff57d18 ffffffff802243cb
 0000000000000002 ffff88015f9db360 0000000004f23a08 00007fff4a7f7310
 ffff88017d582880 00007fff4a807310 00007fff4a807310 ffff88017e2947f8
Call Trace:
 [<ffffffff802243cb>] get_user_pages_fast+0x1db/0x300
 [<ffffffff802b1bfd>] sys_vmsplice+0x32d/0x420
 [<ffffffff80262acd>] ? unlock_page+0x2d/0x40
 [<ffffffff80275d78>] ? __do_fault+0x1c8/0x450
 [<ffffffff8030e20c>] ? __up_read+0x4c/0xb0
 [<ffffffff802495c6>] ? up_read+0x26/0x30
 [<ffffffff802b0780>] ? spd_release_page+0x0/0x20
 [<ffffffff80463f0d>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
Code: 48 b8 00 f0 ff ff ff 3f 00 00 48 ba 00 00 00 00 00 88 ff ff 48 21 c7 48 89 f0 48 c1 e8 09 25 f8 0f 00 00 48 8d 04 07 48 8d 3c 10 <48> 8b 17 4c 89 d8 48 21 d0 49 39 c0 75 46 48 b8 ff ff ff ff ff 
RIP  [<ffffffff80223ff4>] gup_pte_range+0x54/0x120
 RSP <ffff88012ff57c68>
CR2: ffff88012b60c000
---[ end trace ac162de71e287469 ]---


ffffffff80223fa0 <gup_pte_range>:
ffffffff80223fa0:	55                   	push   %rbp
ffffffff80223fa1:	85 c9                	test   %ecx,%ecx		# write
ffffffff80223fa3:	41 bb 07 02 00 00    	mov    $0x207,%r11d		# mask | _PAGE_SPECIAL
ffffffff80223fa9:	48 89 e5             	mov    %rsp,%rbp
ffffffff80223fac:	41 54                	push   %r12
ffffffff80223fae:	4d 89 c4             	mov    %r8,%r12			# pages, pages
ffffffff80223fb1:	41 b8 07 00 00 00    	mov    $0x7,%r8d		# mask = _PAGE_PRESENT|_PAGE_USER | _PAGE_RW;
ffffffff80223fb7:	53                   	push   %rbx
ffffffff80223fb8:	48 89 d3             	mov    %rdx,%rbx		# end, end
ffffffff80223fbb:	75 0c                	jne    ffffffff80223fc9 <gup_pte_range+0x29>
ffffffff80223fbd:	41 b8 05 00 00 00    	mov    $0x5,%r8d		# mask = _PAGE_PRESENT|_PAGE_USER;
ffffffff80223fc3:	41 bb 05 02 00 00    	mov    $0x205,%r11d		# mask | _PAGE_SPECIAL
ffffffff80223fc9:	48 b8 00 f0 ff ff ff 	mov    $0x3ffffffff000,%rax
ffffffff80223fd0:	3f 00 00
ffffffff80223fd3:	48 ba 00 00 00 00 00 	mov    $0xffff880000000000,%rdx
ffffffff80223fda:	88 ff ff 
ffffffff80223fdd:	48 21 c7             	and    %rax,%rdi		# , pmd
ffffffff80223fe0:	48 89 f0             	mov    %rsi,%rax		# addr, tmp83
ffffffff80223fe3:	48 c1 e8 09          	shr    $0x9,%rax		# tmp83
ffffffff80223fe7:	25 f8 0f 00 00       	and    $0xff8,%eax		# tmp83
ffffffff80223fec:	48 8d 04 07          	lea    (%rdi,%rax,1),%rax	# tmp85
ffffffff80223ff0:	48 8d 3c 10          	lea    (%rax,%rdx,1),%rdi	# ptep
ffffffff80223ff4: ===>	48 8b 17             	mov    (%rdi),%rdx		<===
ffffffff80223ff7:	4c 89 d8             	mov    %r11,%rax
ffffffff80223ffa:	48 21 d0             	and    %rdx,%rax
ffffffff80223ffd:	49 39 c0             	cmp    %rax,%r8			# if ((pte_val(pte) & (mask | _PAGE_SPECIAL)) != mask)
ffffffff80224000:	75 46                	jne    ffffffff80224048 <gup_pte_range+0xa8>
ffffffff80224002:	48 b8 ff ff ff ff ff 	mov    $0x3fffffffffff,%rax
ffffffff80224009:	3f 00 00 
ffffffff8022400c:	48 21 d0             	and    %rdx,%rax
ffffffff8022400f:	49 89 c2             	mov    %rax,%r10
ffffffff80224012:	48 89 c1             	mov    %rax,%rcx
ffffffff80224015:	49 c1 ea 1b          	shr    $0x1b,%r10
ffffffff80224019:	48 c1 e9 0c          	shr    $0xc,%rcx
ffffffff8022401d:	49 81 fa ff ff 01 00 	cmp    $0x1ffff,%r10
ffffffff80224024:	77 1e                	ja     ffffffff80224044 <gup_pte_range+0xa4>
ffffffff80224026:	48 c1 e8 23          	shr    $0x23,%rax
ffffffff8022402a:	48 8b 14 c5 00 88 a5 	mov    -0x7f5a7800(,%rax,8),%rdx
ffffffff80224031:	80 
ffffffff80224032:	48 85 d2             	test   %rdx,%rdx
ffffffff80224035:	74 0d                	je     ffffffff80224044 <gup_pte_range+0xa4>
ffffffff80224037:	49 0f b6 c2          	movzbq %r10b,%rax
ffffffff8022403b:	48 c1 e0 04          	shl    $0x4,%rax
ffffffff8022403f:	48 01 d0             	add    %rdx,%rax
ffffffff80224042:	75 0b                	jne    ffffffff8022404f <gup_pte_range+0xaf>
ffffffff80224044:	0f 0b                	ud2a   
ffffffff80224046:	eb fe                	jmp    ffffffff80224046 <gup_pte_range+0xa6>

										# pte_unmap()
ffffffff80224048:	31 c0                	xor    %eax,%eax		# return 0;
ffffffff8022404a:	5b                   	pop    %rbx
ffffffff8022404b:	41 5c                	pop    %r12
ffffffff8022404d:	c9                   	leaveq 
ffffffff8022404e:	c3                   	retq   
ffffffff8022404f:	f6 00 02             	testb  $0x2,(%rax)
ffffffff80224052:	74 f0                	je     ffffffff80224044 <gup_pte_range+0xa4>
ffffffff80224054:	48 8d 04 cd 00 00 00 	lea    0x0(,%rcx,8),%rax
ffffffff8022405b:	00 
ffffffff8022405c:	48 c1 e1 06          	shl    $0x6,%rcx
ffffffff80224060:	48 29 c1             	sub    %rax,%rcx
ffffffff80224063:	48 b8 00 00 00 00 00 	mov    $0xffffe20000000000,%rax
ffffffff8022406a:	e2 ff ff 
ffffffff8022406d:	48 8d 14 01          	lea    (%rcx,%rax,1),%rdx
ffffffff80224071:	f6 42 01 40          	testb  $0x40,0x1(%rdx)
ffffffff80224075:	48 89 d0             	mov    %rdx,%rax
ffffffff80224078:	74 04                	je     ffffffff8022407e <gup_pte_range+0xde>
ffffffff8022407a:	48 8b 42 10          	mov    0x10(%rdx),%rax
ffffffff8022407e:	8b 48 08             	mov    0x8(%rax),%ecx
ffffffff80224081:	85 c9                	test   %ecx,%ecx
ffffffff80224083:	74 23                	je     ffffffff802240a8 <gup_pte_range+0x108>
ffffffff80224085:	f0 ff 40 08          	lock incl 0x8(%rax)
ffffffff80224089:	49 63 01             	movslq (%r9),%rax
ffffffff8022408c:	48 81 c6 00 10 00 00 	add    $0x1000,%rsi
ffffffff80224093:	49 89 14 c4          	mov    %rdx,(%r12,%rax,8)
ffffffff80224097:	41 ff 01             	incl   (%r9)
ffffffff8022409a:	48 39 de             	cmp    %rbx,%rsi
ffffffff8022409d:	74 0d                	je     ffffffff802240ac <gup_pte_range+0x10c>
ffffffff8022409f:	48 83 c7 08          	add    $0x8,%rdi
ffffffff802240a3:	e9 4c ff ff ff       	jmpq   ffffffff80223ff4 <gup_pte_range+0x54>
ffffffff802240a8:	0f 0b                	ud2a   
ffffffff802240aa:	eb fe                	jmp    ffffffff802240aa <gup_pte_range+0x10a>
ffffffff802240ac:	b8 01 00 00 00       	mov    $0x1,%eax
ffffffff802240b1:	eb 97                	jmp    ffffffff8022404a <gup_pte_range+0xaa>

