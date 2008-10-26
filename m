Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYJZCVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYJZCVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 22:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYJZCVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 22:21:35 -0400
Received: from main.gmane.org ([80.91.229.2]:33232 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYJZCVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 22:21:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: 2.6.27.3 possible recursive locking detected - hfsplus
Date: Sun, 26 Oct 2008 03:23:25 +0000
Message-ID: <ge0k71$91g$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 84-203-37-182.mysmart.ie
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  271.041479] =============================================
[  271.041488] [ INFO: possible recursive locking detected ]
[  271.041495] 2.6.27.3 #1
[  271.041499] ---------------------------------------------
[  271.041505] rm/8081 is trying to acquire lock:
[  271.041510]  (&sb->s_type->i_mutex_key#11){--..}, at: [<c0246caf>]
hfsplus_block_free+0x4f/0x1a0
[  271.041531]
[  271.041533] but task is already holding lock:
[  271.041538]  (&sb->s_type->i_mutex_key#11){--..}, at: [<c01a8dc6>]
vfs_unlink+0x56/0xd0
[  271.041555]
[  271.041557] other info that might help us debug this:
[  271.041563] 3 locks held by rm/8081:
[  271.041567]  #0:  (&type->i_mutex_dir_key#6/1){--..}, at: [<c01aa846>]
do_unlinkat+0x66/0x150
[  271.041587]  #1:  (&sb->s_type->i_mutex_key#11){--..}, at: [<c01a8dc6>]
vfs_unlink+0x56/0xd0
[  271.041605]  #2:  (&HFSPLUS_I(inode).extents_lock){--..}, at: [<c0241067>]
hfsplus_file_truncate+0x137/0x360
[  271.041622]
[  271.041624] stack backtrace:
[  271.041630] Pid: 8081, comm: rm Not tainted 2.6.27.3 #1
[  271.041637]  [<c0169834>] validate_chain+0xbd4/0xeb0
[  271.041649]  [<c015e044>] ? down+0x14/0x40
[  271.041660]  [<c0169d49>] __lock_acquire+0x239/0x950
[  271.041671]  [<c016a4be>] lock_acquire+0x5e/0x80
[  271.041680]  [<c0246caf>] ? hfsplus_block_free+0x4f/0x1a0
[  271.041691]  [<c04abe30>] mutex_lock_nested+0x90/0x2a0
[  271.041702]  [<c0246caf>] ? hfsplus_block_free+0x4f/0x1a0
[  271.041713]  [<c0246caf>] ? hfsplus_block_free+0x4f/0x1a0
[  271.041724]  [<c0246caf>] hfsplus_block_free+0x4f/0x1a0
[  271.041733]  [<c01685db>] ? trace_hardirqs_on+0xb/0x10
[  271.041744]  [<c0240961>] hfsplus_free_extents+0x61/0xa0
[  271.041754]  [<c024126c>] hfsplus_file_truncate+0x33c/0x360
[  271.041766]  [<c023f6bf>] hfsplus_delete_inode+0x6f/0x80
[  271.041775]  [<c0241fae>] hfsplus_unlink+0x14e/0x190
[  271.041785]  [<c01a8dc6>] ? vfs_unlink+0x56/0xd0
[  271.041796]  [<c01a8dc6>] ? vfs_unlink+0x56/0xd0
[  271.041807]  [<c01a8dda>] vfs_unlink+0x6a/0xd0
[  271.041816]  [<c01b9044>] ? mnt_want_write+0x64/0xa0
[  271.041827]  [<c01aa910>] do_unlinkat+0x130/0x150
[  271.041837]  [<c0131bb7>] ? do_page_fault+0x2c7/0x670
[  271.041849]  [<c01ac4d7>] ? do_vfs_ioctl+0x57/0x2b0
[  271.041860]  [<c02d9f44>] ? trace_hardirqs_on_thunk+0xc/0x10
[  271.041871]  [<c01318f0>] ? do_page_fault+0x0/0x670
[  271.041882]  [<c0168544>] ? trace_hardirqs_on_caller+0xc4/0x150
[  271.041893]  [<c01aaa53>] sys_unlinkat+0x23/0x40
[  271.041902]  [<c011bd09>] sysenter_do_call+0x12/0x35
[  271.041912]  [<c0110000>] ? x86_emulate_insn+0xcd0/0x39d0
[  271.041925]  =======================


