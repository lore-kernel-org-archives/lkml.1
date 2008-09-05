Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbYIEM7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbYIEM7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYIEM71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:59:27 -0400
Received: from frankvm.xs4all.nl ([80.126.170.174]:36203 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750739AbYIEM70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:59:26 -0400
Date: Fri, 5 Sep 2008 14:59:24 +0200
From: Frank van Maarseveen <frankvm@frankvm.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.4 ext3 umount triggered kernel BUG at fs/buffer.c:2869
Message-ID: <20080905125923.GA20033@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

umount /dev/md8 holding an ext3 fs triggered this:

Sep  5 12:36:59 nfs4 kernel: kernel BUG at fs/buffer.c:2869!
Sep  5 12:36:59 nfs4 kernel: invalid opcode: 0000 [#1] SMP
Sep  5 12:36:59 nfs4 kernel: Modules linked in:
Sep  5 12:36:59 nfs4 kernel:
Sep  5 12:36:59 nfs4 kernel: Pid: 1368, comm: umount Not tainted (2.6.24.4-x179 #1)
Sep  5 12:36:59 nfs4 kernel: EIP: 0060:[<c019e8e0>] EFLAGS: 00010246 CPU: 1
Sep  5 12:36:59 nfs4 kernel: EIP is at submit_bh+0x160/0x170
Sep  5 12:36:59 nfs4 kernel: EAX: 00000005 EBX: f17e0e38 ECX: c019b679 EDX: f17e0e38
Sep  5 12:36:59 nfs4 kernel: ESI: 00000000 EDI: ea2b6000 EBP: e7fd3d1c ESP: e7fd3cec
Sep  5 12:36:59 nfs4 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Sep  5 12:36:59 nfs4 kernel: Process umount (pid: 1368, ti=e7fd2000 task=e7dbb500 task.ti=e7fd2000)
Sep  5 12:36:59 nfs4 kernel: Stack: d5feb54c 00000000 e7fd3d1c c019b685 00000010 00000000 00000000 f17e0e38
Sep  5 12:36:59 nfs4 kernel:        00000001 f17e0e38 00000000 ea2b6000 e7fd3d3c c019ea28 e7fd3d3c c05bb563
Sep  5 12:36:59 nfs4 kernel:        f3db6014 e7fd3d3c f3db6000 f3db6014 e7fd3d68 c01d66b8 00000202 c2a28e1c
Sep  5 12:36:59 nfs4 kernel: Call Trace:
Sep  5 12:36:59 nfs4 kernel:  [<c010562a>] show_trace_log_lvl+0x1a/0x30
Sep  5 12:36:59 nfs4 kernel:  [<c01056fa>] show_stack_log_lvl+0x9a/0xc0
Sep  5 12:36:59 nfs4 kernel:  [<c01058a8>] show_registers+0xc8/0x1d0
Sep  5 12:36:59 nfs4 kernel:  [<c0105b1c>] die+0x10c/0x230
Sep  5 12:36:59 nfs4 kernel:  [<c0105cd1>] do_trap+0x91/0xd0
Sep  5 12:36:59 nfs4 kernel:  [<c0105f79>] do_invalid_op+0x89/0xa0
Sep  5 12:36:59 nfs4 kernel:  [<c05bba62>] error_code+0x72/0x80
Sep  5 12:36:59 nfs4 kernel:  [<c019ea28>] sync_dirty_buffer+0x58/0x110
Sep  5 12:36:59 nfs4 kernel:  [<c01d66b8>] journal_update_superblock+0xb8/0x1a0
Sep  5 12:36:59 nfs4 kernel:  [<c01d4253>] cleanup_journal_tail+0x133/0x180
Sep  5 12:36:59 nfs4 kernel:  [<c01d3f2a>] log_do_checkpoint+0x2a/0x220
Sep  5 12:36:59 nfs4 kernel:  [<c01d69c9>] journal_destroy+0x39/0x120
Sep  5 12:36:59 nfs4 kernel:  [<c01ca7bc>] ext3_put_super+0x1c/0x130
Sep  5 12:36:59 nfs4 kernel:  [<c017b16a>] generic_shutdown_super+0xea/0xf0
Sep  5 12:36:59 nfs4 kernel:  [<c017bb6f>] kill_block_super+0xf/0x20
Sep  5 12:36:59 nfs4 kernel:  [<c017aef2>] deactivate_super+0x52/0x70
Sep  5 12:36:59 nfs4 kernel:  [<c018ff04>] mntput_no_expire+0x44/0x60
Sep  5 12:36:59 nfs4 kernel:  [<c0180e35>] path_release_on_umount+0x15/0x20
Sep  5 12:36:59 nfs4 kernel:  [<c0190627>] sys_umount+0x37/0x80
Sep  5 12:36:59 nfs4 kernel:  [<c0190687>] sys_oldumount+0x17/0x20
Sep  5 12:36:59 nfs4 kernel:  [<c0104292>] syscall_call+0x7/0xb
Sep  5 12:36:59 nfs4 kernel:  =======================
Sep  5 12:36:59 nfs4 kernel: Code: e8 83 c4 24 5b 5e 5f 5d c3 83 7d f0 01 0f 85 01 ff ff ff c7 45 f0 05 00 00 00 e9 f5 fe ff ff 0f 0b eb fe 0f 0b eb fe 8d 74 26

int submit_bh(int rw, struct buffer_head * bh)
{
	struct bio *bio;
	int ret = 0;

	BUG_ON(!buffer_locked(bh));
=>	BUG_ON(!buffer_mapped(bh));
	BUG_ON(!bh->b_end_io);

The crash situation is a bit complicated but not unique. It is
probably not easy to reproduce. FWIW (and I'm not sure it matters):

At the time of the crash /dev/md8 was reconstructing as part of a
ext3fs+NFS server migration. /proc/mdstat said:

Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
md8 : active raid1 nbd8[2](W) dm-13[0]
      67108864 blocks super non-persistent [2/1] [U_]
      [>....................]  recovery =  4.9% (3289472/67108864) finish=996.1min speed=1065K/sec
      bitmap: 2/512 pages [8KB], 64KB chunk, file: /tmp/move-export.J31800

md4 : active raid1 sda4[0] sdb4[1]
      367494784 blocks [2/2] [UU]

md1 : active raid1 sda1[0] sdb1[1]
      2056192 blocks [2/2] [UU]

md2 : active raid1 sda2[0] sdb2[1]
      16008704 blocks [2/2] [UU]

nbd8 was connected to a remote machine and dm-13 is a logical volume
from /dev/md4. The logical volume was in the process of being migrated
to another NFS server machine over the network using raid-1 with
write-behind/write-mostly options. This has been done many times before
but in this case something ate the NFS server performance so I decided
to abort the migration. An ext3 umount command was part of that and it
triggered the BUG.

-- 
Frank
