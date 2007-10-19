Return-Path: <linux-kernel-owner+w=401wt.eu-S1764145AbXJSGJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764145AbXJSGJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbXJSGJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:09:17 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34475 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbXJSGJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:09:16 -0400
Date: Fri, 19 Oct 2007 02:05:46 -0400
Message-Id: <200710190605.l9J65kDe008069@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: dwmw2@infradead.org, jffs-dev@axis.com, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: BUG at mm/filemap.c:1749 (2.6.24, jffs2, unionfs)
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I'm testing unionfs on top of jffs2, using 2.6.24 as of linus's commit
4fa4d23fa20de67df919030c1216295664866ad7.  All of my unionfs tests pass when
unionfs is stacked on top of jffs2, other than my truncate test -- whic
tries to truncate files up/down (through the union, which then is passed
through to the lower jffs2 f/s).  The same truncate test passes on all other
file systems I've tried unionfs/2.6.24 with, as well as all of the earlier
kernels that unionfs runs on (2.6.9--2.6.23).  So I tend to think this bug
is more probably due to something else going on in 2.6.24, possibly wrt
jffs2/mtd.  (Of course, it's still possible that unionfs isn't doing
something right -- any pointers?)

The oops trace is included below.  Is this a known issue and if so, any
fixes?  If this is the first you hear of this problem, let me know and I'll
try to narrow it down further.

Thanks,
Erez.

------------[ cut here ]------------
kernel BUG at mm/filemap.c:1749!
invalid opcode: 0000 [#1] DEBUG_PAGEALLOC
Modules linked in: block2mtd mtdblock jffs2 mtd_blkdevs mtd zlib_deflate
zlib_inflate nfsd exportfs auth_rpcgss nfs lockd nfs_acl sunrpc pcnet32
CPU:    0
EIP:    0060:[<c012f03d>]    Not tainted VLI
EFLAGS: 00010287   (2.6.23-unionfs2-2.6.24-rc0-pre #9)
EIP is at iov_iter_advance+0x13/0x5d
eax: c538fdec   ebx: 00001000   ecx: c538fdec   edx: 00001000
esi: 00000fa0   edi: 00000000   ebp: c538fd7c   esp: c538fd6c
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process dd (pid: 11484, ti=c538e000 task=c4cb05b0 task.ti=c538e000)
Stack: 00001000 00001000 00000fa0 00000000 c538fe10 c01307b7 00000fa0 00000000 
       00000060 00000060 c16fb0c0 c690edc8 c690eed4 00000000 c538fed4 6238f40 
       c690eed4 f890a4c0 c690edc8 00000000 00000060 00000fa0 f890a4c0 c16fb0a0 
Call Trace:
 [<c0102bc2>] show_trace_log_lvl+0x1a/0x2f
 [<c0102c72>] show_stack_log_lvl+0x9b/0xa3
 [<c0102e2e>] show_registers+0x1b4/0x285
 [<c0102fff>] die+0x100/0x21d
 [<c01031a5>] do_trap+0x89/0xa2
 [<c010347d>] do_invalid_op+0x88/0x92
 [<c026a412>] error_code+0x6a/0x70
 [<c01307b7>] generic_file_buffered_write+0x163/0x51d
 [<c0130f60>] __generic_file_aio_write_nolock+0x3ef/0x43f
 [<c0131008>] generic_file_aio_write+0x58/0xb6
 [<c01498f8>] do_sync_write+0xc4/0x101
 [<c014a04b>] vfs_write+0x90/0x119
 [<c014a500>] sys_write+0x3d/0x61
 [<c0102586>] sysenter_past_esp+0x5f/0x91
 =======================
Code: ff 39 c2 74 0c 89 da 8a 41 ff 88 45 f7 89 d0 eb 02 31 c0 5a 5b 5e 5d
c3 55 89 c1 89 e5 57 56 53 83 ec 04 89 55 f0 39 50 0c 73 04 <0f> 0b eb fe 83
78 04 01 75 08 8b 45 f0 01 41 08 eb 2c 8b 38 8b 
EIP: [<c012f03d>] iov_iter_advance+0x13/0x5d SS:ESP 0068:c538fd6c
