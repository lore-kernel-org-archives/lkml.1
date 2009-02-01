Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZBAJ5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZBAJ5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 04:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZBAJ5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 04:57:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:43849 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752430AbZBAJ5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 04:57:12 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18wMipUY+kwRtnT4qu8mNu1KUUgTkP3Cu0iOs6ZLR
	9fPpOoCGG1Phzb
Date: Sun, 1 Feb 2009 10:57:07 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: tigran@aivazian.fsnet.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: BFS: Bug during mount of corrupted image
Message-ID: <20090201095707.GA9819@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.29-rc3 (x86_64)
X-Uptime: 10:49:59 up 1 day, 49 min,  9 users,  load average: 0.10, 0.21,
	0.22
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

when mounting the image at
http://www.cccmz.de/~snakebyte/bfs.56.img.bz2

I get this oops:

[  214.577138] attempt to access beyond end of device
[  214.577302] loop0: rw=0, want=40960, limit=8192
[  214.577490] BFS-fs: bfs_fill_super(): Last block not available: 40959
[  214.577729] ------------[ cut here ]------------
[  214.577851] kernel BUG at fs/inode.c:1257!
[  214.577968] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[  214.578054] last sysfs file: /sys/block/ram9/range
[  214.578054] Modules linked in:
[  214.578054] 
[  214.578054] Pid: 4975, comm: mount Not tainted
(2.6.29-rc3-00173-ge4a11bd-dirty #235) System Name
[  214.578054] EIP: 0060:[<c0195507>] EFLAGS: 00010246 CPU: 0
[  214.578054] EIP is at iput+0x13/0x4e
[  214.578054] EAX: c62c000c EBX: c62c000c ECX: c62c0024 EDX: c62c0024
[  214.578054] ESI: c62c000c EDI: 00000000 EBP: c49dee44 ESP: c49dee40
[  214.578054]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  214.578054] Process mount (pid: 4975, ti=c49de000 task=c4991a40
task.ti=c49de000)
[  214.578054] Stack:
[  214.578054]  c627c9c0 c49dee60 c0193eb9 c01889c9 00000001 c49a5920
c07a1dfc c0a01da8
[  214.578054]  c49dee6c c019484c c49a5920 c49dee7c c0188846 c624e3e0
00000003 c49dee8c
[  214.578054]  c0188912 c49a5920 c01b6ada c49deea0 c01889ce 00000000
fffffffb 00000003
[  214.578054] Call Trace:
[  214.578054]  [<c0193eb9>] ?
shrink_dcache_for_umount_subtree+0x16d/0x1b5
[  214.578054]  [<c01889c9>] ? deactivate_super+0x52/0x6a
[  214.578054]  [<c019484c>] ? shrink_dcache_for_umount+0x2c/0x39
[  214.578054]  [<c0188846>] ? generic_shutdown_super+0x15/0xc4
[  214.578054]  [<c0188912>] ? kill_block_super+0x1d/0x31
[  214.578054]  [<c01b6ada>] ? vfs_quota_off+0x0/0x12
[  214.578054]  [<c01889ce>] ? deactivate_super+0x57/0x6a
[  214.578054]  [<c0188e40>] ? get_sb_bdev+0x105/0x13a
[  214.578054]  [<c0170922>] ? kstrdup+0x2a/0x4c
[  214.578054]  [<c0257a38>] ? bfs_get_sb+0x13/0x15
[  214.578054]  [<c025800e>] ? bfs_fill_super+0x0/0x376
[  214.578054]  [<c0188a1c>] ? vfs_kern_mount+0x3b/0x76
[  214.578054]  [<c0188a9b>] ? do_kern_mount+0x32/0xba
[  214.578054]  [<c019985b>] ? do_mount+0x5c7/0x604
[  214.578054]  [<c0198227>] ? copy_mount_options+0x27/0x10d
[  214.578054]  [<c01998fc>] ? sys_mount+0x64/0x9b
[  214.578054]  [<c0102dc1>] ? sysenter_do_call+0x12/0x31
[  214.578054] Code: 05 6c 02 00 00 e8 58 c1 f9 ff 5d c3 55 89 e5 e8 ae
f7 5e 00 31 c0 5d c3 55 85 c0 89 e5 53 89 c3 74 41 83 b8 6c 02 00 00 40
75 04 <0f> 0b eb fe 8d 40 24 ba 10 f8 9f c0 e8 84 52 34 00 85 c0 74 23 
[  214.578054] EIP: [<c0195507>] iput+0x13/0x4e SS:ESP 0068:c49dee40
[  214.592689] ---[ end trace ff72413a06d2e2c2 ]---

The only patch applied is against jfs so this shouldnt have an
effect on this.

The BUG_ON triggered is in iput(): BUG_ON(inode->i_state == I_CLEAR);

(gdb) l *(shrink_dcache_for_umount_subtree+0x16d)
0xc0193eb9 is in shrink_dcache_for_umount_subtree (fs/dcache.c:692).
687
dentry->d_op->d_iput(dentry, inode);
688					else
689						iput(inode);
690				}
691	
692				d_free(dentry);
693	
694				/* finished when we fall off the top of
the tree,
695				 * otherwise we ascend to the parent and
move to the
696				 * next sibling if there is one */
(gdb) l *(deactivate_super+0x52)
0xc01889c9 is in deactivate_super (fs/super.c:187).
182		if (atomic_dec_and_lock(&s->s_active, &sb_lock)) {
183			s->s_count -= S_BIAS-1;
184			spin_unlock(&sb_lock);
185			DQUOT_OFF(s, 0);
186			down_write(&s->s_umount);
187			fs->kill_sb(s);
188			put_filesystem(fs);
189			put_super(s);
190		}
191	}

Greetings, Eric
