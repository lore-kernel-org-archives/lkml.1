Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYDZKH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYDZKH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 06:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYDZKHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 06:07:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:46104 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752075AbYDZKHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 06:07:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18sFQh4Gx4s+bkh3TchRPdcxNeO8AJtszG8wLjCO/
	fSFZeSLHJMLpIR
Subject: [v2.6.25-5096-gb1721d0] get_unused_fd_flags() ==> next_zero_bit()
	==> __find_first_zero_bit() ==> Attempted to kill init!
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 12:07:07 +0200
Message-Id: <1209204427.4707.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[    2.059590] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[    2.069531] IP: [<ffffffff80302058>] find_next_zero_bit+0x6c/0x90
[    2.077826] PGD 0 
[    2.082034] Oops: 0000 [1] SMP 
[    2.087454] CPU 3 
[    2.091739] Modules linked in:
[    2.097118] Pid: 1, comm: swapper Not tainted 2.6.26-smp #22
[    2.105248] RIP: 0010:[<ffffffff80302058>]  [<ffffffff80302058>] find_next_zero_bit+0x6c/0x90
[    2.116509] RSP: 0000:ffff8100bf851a90  EFLAGS: 00010286
[    2.124595] RAX: ffffffffffffffff RBX: 0000000000000230 RCX: 0000000002fe147c
[    2.134711] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    2.144868] RBP: ffff8100bf851a90 R08: 0000000000000000 R09: 0000000000000000
[    2.155057] R10: 0000000000000000 R11: ffff8100bf851a80 R12: ffff8100bf851d50
[    2.165230] R13: 00000000fffffff8 R14: ffff8100bf851df0 R15: ffff8100bf888800
[    2.175371] FS:  0000000000000000(0000) GS:ffff8100bf808980(0000) knlGS:0000000000000000
[    2.186715] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    2.195541] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[    2.205839] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.216025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    2.226087] Process swapper (pid: 1, threadinfo ffff8100bf850000, task ffff8100bf84e000)
[    2.237269] Stack:  ffff8100bf851ad0 ffffffff8028c332 00000000fffffff8 0000000000000230
[    2.248562]  0000000000000230 00000000fffffff8 0000000000000000 ffff8100bf888800
[    2.259549]  ffff8100bf851ae0 ffffffff8028c515 ffff8100bf851c00 ffffffff802bf983
[    2.266998] Call Trace:
[    2.275839]  [<ffffffff8028c332>] get_unused_fd_flags+0x4a/0x114
[    2.285362]  [<ffffffff8028c515>] get_unused_fd+0xb/0xd
[    2.293856]  [<ffffffff802bf983>] load_elf_binary+0x139/0x1732
[    2.302950]  [<ffffffff8024564d>] ? autoremove_wake_function+0x0/0x38
[    2.312752]  [<ffffffff8028f181>] ? file_move+0x1e/0x4a
[    2.321307]  [<ffffffff802e6ddb>] ? security_dentry_open+0x11/0x13
[    2.330852]  [<ffffffff8028e6d3>] ? vfs_read+0x11f/0x154
[    2.339467]  [<ffffffff80291bfc>] search_binary_handler+0xb9/0x20e
[    2.348922]  [<ffffffff802bf08b>] load_script+0x1bb/0x1d0
[    2.357500]  [<ffffffff802917f4>] ? get_arg_page+0x4b/0xab
[    2.366117]  [<ffffffff80291af5>] ? copy_strings+0x1b6/0x1c7
[    2.374943]  [<ffffffff80291bfc>] search_binary_handler+0xb9/0x20e
[    2.384299]  [<ffffffff8029307c>] do_execve+0x183/0x22c
[    2.392713]  [<ffffffff8020a4e7>] sys_execve+0x3e/0x59
[    2.401028]  [<ffffffff8020ce97>] kernel_execve+0x67/0xd0
[    2.409474]  [<ffffffff8020901e>] ? _stext+0x1e/0x20
[    2.417391]  [<ffffffff80209082>] init_post+0x62/0xdc
[    2.425383]  [<ffffffff8020ce28>] ? child_rip+0xa/0x12
[    2.433428]  [<ffffffff8020ce1e>] ? child_rip+0x0/0x12
[    2.441450] 
[    2.445739] 
[    2.449993] Code: 04 02 72 49 48 83 c7 08 48 89 f8 31 d2 4c 29 d0 48 c1 e0 03 48 29 c6 48 8d 46 3f 48 89 c1 48 c1 e9 06 74 22 48 83 c8 ff 48 89 fe <f3> 48 af 74 0c 48 33 47 f8 48 83 ef 08 48 0f bc d0 48 29 f7 48 
[    2.478797] RIP  [<ffffffff80302058>] find_next_zero_bit+0x6c/0x90
[    2.488037]  RSP <ffff8100bf851a90>
[    2.494579] CR2: 0000000000000000
[    2.500833] ---[ end trace 009faa12c3f2681d ]---
[    2.508387] Kernel panic - not syncing: Attempted to kill init!

(gdb) list *find_next_zero_bit+0x6c
0xffffffff80302058 is in find_next_zero_bit (arch/x86/lib/bitops_64.c:27).
22               */
23              size += 63;
24              size >>= 6;
25              if (!size)
26                      return 0;
27              asm volatile(
28                      "  repe; scasq\n"
29                      "  je 1f\n"
30                      "  xorq -8(%%rdi),%%rax\n"
31                      "  subq $8,%%rdi\n"

rdi 0

int get_unused_fd_flags(int flags)
{
        struct files_struct * files = current->files;
        int fd, error;
        struct fdtable *fdt;

        error = -EMFILE;
        spin_lock(&files->file_lock);

repeat:
        fdt = files_fdtable(files);
        fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
                                files->next_fd);


Rummaging with gitk, then backing out 4 commits below got it booting.

marge:..tmp/linux-2.6.26.git # quilt applied
patches/Makefile.diff
patches/4b119e2..3925e6f.diff
patches/3925e6f..8075014.diff
patches/8075014..94bc891.diff
patches/94bc891..3dc5063.diff
patches/3dc5063..b69d398.diff
patches/b69d398..b1721d0.diff
patches/hrtick.diff
patches/fix_seq_printf_oops.diff
patches/revert_f8f95702f0c4529b0f59488f4509608f0c160e77.diff
patches/revert_3b1253880b7a9e6db54b943b2d40bcf2202f58ab.diff
patches/revert_fd8328be874f4190a811c58cd4778ec2c74d2c05.diff
patches/revert_6b335d9c80d7f3c2a3f6545f664ae9007a0f3821.diff



