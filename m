Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbYKTXGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbYKTXGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKTXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:06:30 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46390 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbYKTXG0 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:06:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Random freeze (Re: mmotm 2008-11-19-02-19 uploaded)
In-Reply-To: Your message of "Thu, 20 Nov 2008 15:09:35 +0900."
             <200811200609.mAK69ZbZ053438@www262.sakura.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <200811200609.mAK69ZbZ053438@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227222347_3127P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Nov 2008 18:05:47 -0500
Message-ID: <4401.1227222347@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227222347_3127P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Nov 2008 15:09:35 +0900, Tetsuo Handa said:
> Hello.
> 
> > The mm-of-the-moment snapshot 2008-11-19-02-19 has been uploaded to
> Recent mmotm randomly freezes on /sbin/modprobe and read(). 2.6.28-rc2-mm1 was OK.

I'm seeing very similar hangs on -mmotm-11-17 as well. I've hit it 3 times
today, all while disk activity was moderately heavy (things like 'yum update',
or a 'find . | xargs grep', and so on).

Managed to catch one while netconsole was active - I didn't have any messages
for bugs/warns/oopsen.  Apparently, somebody is holding a lock. (I also have an
alt-sysrq-t from this incident, but that's about 10 times as big, didn't want
to abuse vger too much.. ;)

[ 3932.912494] SysRq : Show Blocked State
[ 3932.913465]   task                        PC stack   pid father
[ 3932.913465] pdflush       D ffff88007e247cf0  5776   303      2
[ 3932.913465]  ffff88007e247c50 0000000000000002 ffff88007e247bb0 ffff88007dcf54d8
[ 3932.913465]  ffff88007e247c00 ffffffff8081c780 ffffffff8081c780 ffff88007f269040
[ 3932.913465]  ffff88007f232040 ffff88007f269398 000000007e247be0 ffff88007f269398
[ 3932.913465] Call Trace:
[ 3932.913465]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3932.913465]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3932.913465]  [<ffffffff8027e44d>] sync_page+0x78/0x7f
[ 3932.913465]  [<ffffffff80568380>] __wait_on_bit+0x47/0x79
[ 3932.913465]  [<ffffffff8027e3d5>] ? sync_page+0x0/0x7f
[ 3932.913465]  [<ffffffff8027e5ed>] wait_on_page_bit+0x6e/0x75
[ 3932.913465]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3932.913465]  [<ffffffff80286343>] ? pagevec_lookup_tag+0x22/0x2b
[ 3932.913465]  [<ffffffff8027eed9>] wait_on_page_writeback_range+0x75/0x13d
[ 3932.913465]  [<ffffffff8027efc1>] filemap_fdatawait+0x20/0x22
[ 3932.913465]  [<ffffffff8027f0cc>] filemap_write_and_wait+0x27/0x33
[ 3932.913465]  [<ffffffff802c7c32>] sync_blockdev+0x1b/0x1d
[ 3932.913465]  [<ffffffff802c2242>] __sync_inodes+0x74/0xbf
[ 3932.913465]  [<ffffffff802c22a6>] sync_inodes+0x19/0x33
[ 3932.913465]  [<ffffffff802c5378>] do_sync+0x1a/0x77
[ 3932.913465]  [<ffffffff80285a4c>] pdflush+0x145/0x1f8
[ 3932.913465]  [<ffffffff802c535e>] ? do_sync+0x0/0x77
[ 3932.913465]  [<ffffffff80285907>] ? pdflush+0x0/0x1f8
[ 3932.913465]  [<ffffffff8024ba10>] kthread+0x49/0x76
[ 3932.913465]  [<ffffffff8020cb79>] child_rip+0xa/0x11
[ 3932.913465]  [<ffffffff8020bfe5>] ? restore_args+0x0/0x30
[ 3932.913465]  [<ffffffff8024b9c7>] ? kthread+0x0/0x76
[ 3932.913465]  [<ffffffff8020cb6f>] ? child_rip+0x0/0x11
[ 3932.913465] pdflush       D 0000000000000246  5056   304      2
[ 3932.913465]  ffff88007e275d50 0000000000000002 ffffe200016b1698 ffffe20001612f48
[ 3932.913465]  ffffe20000d66ea8 ffffffff8081c780 ffffffff8081c780 ffff88007f25c040
[ 3932.913465]  ffff88007f2697f0 ffff88007f25c398 000000007e275cf0 ffff88007f25c398
[ 3932.913465] Call Trace:
[ 3932.913465]  [<ffffffff8022f968>] ? account_group_exec_runtime+0x26/0x64
[ 3932.913465]  [<ffffffff8022fa79>] ? update_curr+0xd3/0xdc
[ 3932.913465]  [<ffffffff8056883e>] __mutex_lock_common+0x280/0x406
[ 3932.913465]  [<ffffffff80569f44>] ? _spin_unlock_irq+0x47/0x52
[ 3932.913465]  [<ffffffff80568a56>] __mutex_lock_slowpath+0x14/0x16
[ 3932.913465]  [<ffffffff80568a7d>] mutex_lock+0x25/0x29
[ 3932.913465]  [<ffffffff802a8172>] lock_super+0x27/0x29
[ 3932.913465]  [<ffffffff802a85db>] sync_supers+0x48/0xb6
[ 3932.913465]  [<ffffffff80284ebe>] wb_kupdate+0x35/0x128
[ 3932.913465]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3932.913465]  [<ffffffff80285a4c>] pdflush+0x145/0x1f8
[ 3932.913465]  [<ffffffff80284e89>] ? wb_kupdate+0x0/0x128
[ 3932.913465]  [<ffffffff80285907>] ? pdflush+0x0/0x1f8
[ 3932.913465]  [<ffffffff8024ba10>] kthread+0x49/0x76
[ 3932.913465]  [<ffffffff8020cb79>] child_rip+0xa/0x11
[ 3932.913465]  [<ffffffff8020bfe5>] ? restore_args+0x0/0x30
[ 3932.913465]  [<ffffffff8024b9c7>] ? kthread+0x0/0x76
[ 3932.913465]  [<ffffffff8020cb6f>] ? child_rip+0x0/0x11
[ 3932.913465] kjournald     D ffff88007e08c480  5696  1508      2
[ 3932.913465]  ffff88007dc47c60 0000000000000002 ffff88007dcf54d8 ffff88007dcf54d8
[ 3932.913465]  ffff88007dc47bd0 ffffffff8081c780 ffffffff8081c780 ffff88007e1a2040
[ 3932.913465]  ffff88007906d040 ffff88007e1a2398 000000017dc47c00 ffff88007e1a2398
[ 3932.913465] Call Trace:
[ 3932.913465]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3932.913465]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3932.913465]  [<ffffffff802c7e91>] sync_buffer+0x3e/0x42
[ 3932.913465]  [<ffffffff80568380>] __wait_on_bit+0x47/0x79
[ 3932.913465]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3932.913465]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3932.913465]  [<ffffffff8056841c>] out_of_line_wait_on_bit+0x6a/0x77
[ 3932.913465]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3932.913465]  [<ffffffff803636fb>] ? submit_bio+0xc4/0xcd
[ 3932.913465]  [<ffffffff802c7dc0>] __wait_on_buffer+0x36/0x3a
[ 3932.913465]  [<ffffffff802c7e01>] wait_on_buffer+0x3d/0x41
[ 3932.913465]  [<ffffffff802c8477>] sync_dirty_buffer+0x84/0xd3
[ 3932.913465]  [<ffffffff80315357>] journal_commit_transaction+0xd22/0x11cb
[ 3932.913465]  [<ffffffff80569fad>] ? _spin_unlock_irqrestore+0x5e/0x6c
[ 3932.913465]  [<ffffffff80241178>] ? try_to_del_timer_sync+0x5e/0x6a
[ 3932.913465]  [<ffffffff80318cf4>] kjournald+0xe2/0x23c
[ 3932.913465]  [<ffffffff8024be3f>] ? autoremove_wake_function+0x0/0x38
[ 3933.879285]  [<ffffffff80318c12>] ? kjournald+0x0/0x23c
[ 3933.879285]  [<ffffffff8024ba10>] kthread+0x49/0x76
[ 3933.879285]  [<ffffffff8020cb79>] child_rip+0xa/0x11
[ 3933.879285]  [<ffffffff8020bfe5>] ? restore_args+0x0/0x30
[ 3933.879285]  [<ffffffff805680f2>] ? preempt_schedule+0x43/0x81
[ 3933.879285]  [<ffffffff8024b9c7>] ? kthread+0x0/0x76
[ 3933.879285]  [<ffffffff8020cb6f>] ? child_rip+0x0/0x11
[ 3933.879285] kjournald     D ffff880077c51d10  5264  1509      2
[ 3933.879285]  ffff880077c51c80 0000000000000002 ffff88007dcf54d8 ffff88007dcf54d8
[ 3933.879285]  ffff880077c51bf0 ffffffff8081c780 ffffffff8081c780 ffff88007e2dc7f0
[ 3933.879285]  ffff88007f30a7f0 ffff88007e2dcb48 0000000177c51c20 ffff88007e2dcb48
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3933.879285]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3933.879285]  [<ffffffff802c7e91>] sync_buffer+0x3e/0x42
[ 3933.879285]  [<ffffffff80568380>] __wait_on_bit+0x47/0x79
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff8056841c>] out_of_line_wait_on_bit+0x6a/0x77
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff803636fb>] ? submit_bio+0xc4/0xcd
[ 3933.879285]  [<ffffffff802c7dc0>] __wait_on_buffer+0x36/0x3a
[ 3933.879285]  [<ffffffff80314536>] wait_on_buffer+0x3d/0x41
[ 3933.879285]  [<ffffffff80314c27>] journal_commit_transaction+0x5f2/0x11cb
[ 3933.879285]  [<ffffffff80569fad>] ? _spin_unlock_irqrestore+0x5e/0x6c
[ 3933.879285]  [<ffffffff80241178>] ? try_to_del_timer_sync+0x5e/0x6a
[ 3933.879285]  [<ffffffff80318cf4>] kjournald+0xe2/0x23c
[ 3933.879285]  [<ffffffff8024be3f>] ? autoremove_wake_function+0x0/0x38
[ 3933.879285]  [<ffffffff80318c12>] ? kjournald+0x0/0x23c
[ 3933.879285]  [<ffffffff8024ba10>] kthread+0x49/0x76
[ 3933.879285]  [<ffffffff8020cb79>] child_rip+0xa/0x11
[ 3933.879285]  [<ffffffff8020bfe5>] ? restore_args+0x0/0x30
[ 3933.879285]  [<ffffffff805680f2>] ? preempt_schedule+0x43/0x81
[ 3933.879285]  [<ffffffff8024b9c7>] ? kthread+0x0/0x76
[ 3933.879285]  [<ffffffff8020cb6f>] ? child_rip+0x0/0x11
[ 3933.879285] kjournald     D ffff88007e41b080  5264  1511      2
[ 3933.879285]  ffff8800770adc80 0000000000000002 ffff88007dcf54d8 ffff88007dcf54d8
[ 3933.879285]  ffff8800770adbf0 ffffffff8081c780 ffffffff8081c780 ffff88007e1a4040
[ 3933.879285]  ffff88007d5897f0 ffff88007e1a4398 00000000770adc20 ffff88007e1a4398
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3933.879285]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3933.879285]  [<ffffffff802c7e91>] sync_buffer+0x3e/0x42
[ 3933.879285]  [<ffffffff80568380>] __wait_on_bit+0x47/0x79
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff8056841c>] out_of_line_wait_on_bit+0x6a/0x77
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff803636fb>] ? submit_bio+0xc4/0xcd
[ 3933.879285]  [<ffffffff802c7dc0>] __wait_on_buffer+0x36/0x3a
[ 3933.879285]  [<ffffffff80314536>] wait_on_buffer+0x3d/0x41
[ 3933.879285]  [<ffffffff80315125>] journal_commit_transaction+0xaf0/0x11cb
[ 3933.879285]  [<ffffffff80569fad>] ? _spin_unlock_irqrestore+0x5e/0x6c
[ 3933.879285]  [<ffffffff80241178>] ? try_to_del_timer_sync+0x5e/0x6a
[ 3933.879285]  [<ffffffff80318cf4>] kjournald+0xe2/0x23c
[ 3933.879285]  [<ffffffff8024be3f>] ? autoremove_wake_function+0x0/0x38
[ 3933.879285]  [<ffffffff80318c12>] ? kjournald+0x0/0x23c
[ 3933.879285]  [<ffffffff8024ba10>] kthread+0x49/0x76
[ 3933.879285]  [<ffffffff8020cb79>] child_rip+0xa/0x11
[ 3933.879285]  [<ffffffff8020bfe5>] ? restore_args+0x0/0x30
[ 3933.879285]  [<ffffffff8024b9c7>] ? kthread+0x0/0x76
[ 3933.879285]  [<ffffffff8020cb6f>] ? child_rip+0x0/0x11
[ 3933.879285] syslog-ng     D 00000000ffffffff  4616  2021      1
[ 3933.879285]  ffff88007e67fae8 0000000000000046 ffff88007dcf54d8 ffff88007dcf54d8
[ 3933.879285]  ffff88007e67fa58 ffffffff8081c780 ffffffff8081c780 ffff88007e0d57f0
[ 3933.879285]  ffffffff807093b0 ffff88007e0d5b48 000000007e67fa88 ffff88007e0d5b48
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3933.879285]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3933.879285]  [<ffffffff802c7e91>] sync_buffer+0x3e/0x42
[ 3933.879285]  [<ffffffff8056828e>] __wait_on_bit_lock+0x45/0x79
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff8056832c>] out_of_line_wait_on_bit_lock+0x6a/0x77
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff802c7001>] ? __find_get_block+0x1c7/0x1d9
[ 3933.879285]  [<ffffffff802c8364>] __lock_buffer+0x25/0x27
[ 3933.879285]  [<ffffffff8031283d>] lock_buffer+0x44/0x48
[ 3933.879285]  [<ffffffff80313511>] do_get_write_access+0x72/0x4c7
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80317a12>] ? bit_spin_unlock+0x6b/0x79
[ 3933.879285]  [<ffffffff80313988>] journal_get_write_access+0x22/0x33
[ 3933.879285]  [<ffffffff8030f77e>] __ext3_journal_get_write_access+0x1f/0x48
[ 3933.879285]  [<ffffffff80302ca4>] ext3_reserve_inode_write+0x3f/0x76
[ 3933.879285]  [<ffffffff80302d11>] ext3_mark_inode_dirty+0x36/0x53
[ 3933.879285]  [<ffffffff80302e7c>] ext3_dirty_inode+0x71/0x88
[ 3933.879285]  [<ffffffff802c23e7>] __mark_inode_dirty+0x33/0x1a4
[ 3933.879285]  [<ffffffff802ba2f0>] inode_setattr+0x11b/0x125
[ 3933.879285]  [<ffffffff8030302d>] ext3_setattr+0x19a/0x201
[ 3933.879285]  [<ffffffff802ba510>] notify_change+0x216/0x35e
[ 3933.879285]  [<ffffffff802a52dc>] chown_common+0x69/0x80
[ 3933.879285]  [<ffffffff802a525f>] ? audit_inode+0x43/0x57
[ 3933.879285]  [<ffffffff802a5342>] sys_fchown+0x4f/0x6f
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] console-kit-d D ffff88007e08c480  4952  2109      1
[ 3933.879285]  ffff88007d505a78 0000000000000046 ffff88007dcf54d8 ffff88007dcf54d8
[ 3933.879285]  ffff88007d5059e8 ffffffff8081c780 ffffffff8081c780 ffff88007e1a37f0
[ 3933.879285]  ffff88007906d040 ffff88007e1a3b48 000000007d505a18 ffff88007e1a3b48
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3933.879285]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3933.879285]  [<ffffffff802c7e91>] sync_buffer+0x3e/0x42
[ 3933.879285]  [<ffffffff8056828e>] __wait_on_bit_lock+0x45/0x79
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff8056832c>] out_of_line_wait_on_bit_lock+0x6a/0x77
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff802c667f>] ? put_bh+0x49/0x56
[ 3933.879285]  [<ffffffff802c8364>] __lock_buffer+0x25/0x27
[ 3933.879285]  [<ffffffff8031283d>] lock_buffer+0x44/0x48
[ 3933.879285]  [<ffffffff80313511>] do_get_write_access+0x72/0x4c7
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80317a12>] ? bit_spin_unlock+0x6b/0x79
[ 3933.879285]  [<ffffffff80313988>] journal_get_write_access+0x22/0x33
[ 3933.879285]  [<ffffffff8030f77e>] __ext3_journal_get_write_access+0x1f/0x48
[ 3933.879285]  [<ffffffff80301676>] ext3_new_inode+0x4d9/0x9fd
[ 3933.879285]  [<ffffffff803088a4>] ext3_create+0x99/0x11b
[ 3933.879285]  [<ffffffff802b0cbf>] vfs_create+0x79/0xa0
[ 3933.879285]  [<ffffffff802b10c6>] do_filp_open+0x27c/0x806
[ 3933.879285]  [<ffffffff802aa156>] ? cp_new_stat+0xe2/0xef
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569ffc>] ? _spin_unlock+0x41/0x4c
[ 3933.879285]  [<ffffffff802bb067>] ? alloc_fd+0x11d/0x12e
[ 3933.879285]  [<ffffffff802a4bf6>] do_sys_open+0x6b/0xff
[ 3933.879285]  [<ffffffff802a4cb3>] sys_open+0x1b/0x1d
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] e16           D 00000000ffffffff  3752  2699   2640
[ 3933.879285]  ffff880077173b88 0000000000000046 ffff88007f4a2da8 0000000000000001
[ 3933.879285]  ffff880077173b08 ffffffff8081c780 ffffffff8081c780 ffff880077d6a040
[ 3933.879285]  ffffffff807093b0 ffff880077d6a398 0000000077173b38 ffff880077d6a398
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569fad>] ? _spin_unlock_irqrestore+0x5e/0x6c
[ 3933.879285]  [<ffffffff8031371b>] do_get_write_access+0x27c/0x4c7
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff80313988>] journal_get_write_access+0x22/0x33
[ 3933.879285]  [<ffffffff8030f77e>] __ext3_journal_get_write_access+0x1f/0x48
[ 3933.879285]  [<ffffffff8030177d>] ext3_new_inode+0x5e0/0x9fd
[ 3933.879285]  [<ffffffff803088a4>] ext3_create+0x99/0x11b
[ 3933.879285]  [<ffffffff802b0cbf>] vfs_create+0x79/0xa0
[ 3933.879285]  [<ffffffff802b10c6>] do_filp_open+0x27c/0x806
[ 3933.879285]  [<ffffffff8024be3f>] ? autoremove_wake_function+0x0/0x38
[ 3933.879285]  [<ffffffff8024f26a>] ? ktime_get_ts+0x59/0x5e
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569ffc>] ? _spin_unlock+0x41/0x4c
[ 3933.879285]  [<ffffffff802bb067>] ? alloc_fd+0x11d/0x12e
[ 3933.879285]  [<ffffffff802a4bf6>] do_sys_open+0x6b/0xff
[ 3933.879285]  [<ffffffff802a4cb3>] sys_open+0x1b/0x1d
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] festival_serv D 00000000ffffffff  4920  2918   2699
[ 3933.879285]  ffff880077dddb68 0000000000000046 000000030006dac8 0000000000000001
[ 3933.879285]  ffff880077dddad8 ffffffff8081c780 ffffffff8081c780 ffff88007f2617f0
[ 3933.879285]  ffff88007f2327f0 ffff88007f261b48 0000000100000000 ffff88007f261b48
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff8034092d>] ? avc_has_perm+0x4e/0x60
[ 3933.879285]  [<ffffffff8056883e>] __mutex_lock_common+0x280/0x406
[ 3933.879285]  [<ffffffff80314062>] ? start_this_handle+0x3b3/0x3d0
[ 3933.879285]  [<ffffffff80568a56>] __mutex_lock_slowpath+0x14/0x16
[ 3933.879285]  [<ffffffff80568a7d>] mutex_lock+0x25/0x29
[ 3933.879285]  [<ffffffff802a8172>] lock_super+0x27/0x29
[ 3933.879285]  [<ffffffff80308d65>] ext3_orphan_add+0x28/0x17d
[ 3933.879285]  [<ffffffff8031423e>] ? journal_start+0xb7/0xef
[ 3933.879285]  [<ffffffff80302ff5>] ext3_setattr+0x162/0x201
[ 3933.879285]  [<ffffffff802ba510>] notify_change+0x216/0x35e
[ 3933.879285]  [<ffffffff802a5ae0>] do_truncate+0x63/0x81
[ 3933.879285]  [<ffffffff802ae39d>] ? vfs_dq_init+0x5e/0x68
[ 3933.879285]  [<ffffffff802b0c0b>] may_open+0x19f/0x1da
[ 3933.879285]  [<ffffffff802b1259>] do_filp_open+0x40f/0x806
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569ffc>] ? _spin_unlock+0x41/0x4c
[ 3933.879285]  [<ffffffff802bb067>] ? alloc_fd+0x11d/0x12e
[ 3933.879285]  [<ffffffff802a4bf6>] do_sys_open+0x6b/0xff
[ 3933.879285]  [<ffffffff802a4cb3>] sys_open+0x1b/0x1d
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] firefox-bin   D 00000000ffffffff  4888  4737   4680
[ 3933.879285]  ffff880079c09668 0000000000000046 0000000000000000 0002005079c095e8
[ 3933.879285]  ffff880079c095d8 ffffffff8081c780 ffffffff8081c780 ffff88007afc4040
[ 3933.879285]  ffffffff807093b0 ffff88007afc4398 0000000079c09618 ffff88007afc4398
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569fad>] ? _spin_unlock_irqrestore+0x5e/0x6c
[ 3933.879285]  [<ffffffff8031371b>] do_get_write_access+0x27c/0x4c7
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff80313988>] journal_get_write_access+0x22/0x33
[ 3933.879285]  [<ffffffff8030f77e>] __ext3_journal_get_write_access+0x1f/0x48
[ 3933.879285]  [<ffffffff80300063>] ext3_new_blocks+0x33f/0x5b9
[ 3933.879285]  [<ffffffff805689b3>] ? __mutex_lock_common+0x3f5/0x406
[ 3933.879285]  [<ffffffff803044fc>] ext3_get_blocks_handle+0x3bc/0x891
[ 3933.879285]  [<ffffffff8036867f>] ? blk_rq_map_sg+0x1cf/0x2ed
[ 3933.879285]  [<ffffffff80367cdb>] ? blk_recalc_rq_segments+0x36/0x1a3
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff80304a94>] ext3_get_block+0xc3/0x101
[ 3933.879285]  [<ffffffff802c8be5>] __block_prepare_write+0x21b/0x3ca
[ 3933.879285]  [<ffffffff803049d1>] ? ext3_get_block+0x0/0x101
[ 3933.879285]  [<ffffffff802c8f06>] block_write_begin+0x9e/0x102
[ 3933.879285]  [<ffffffff80303f96>] ext3_write_begin+0xeb/0x1e1
[ 3933.879285]  [<ffffffff803049d1>] ? ext3_get_block+0x0/0x101
[ 3933.879285]  [<ffffffff8027d13e>] ? iov_iter_fault_in_readable+0x3d/0x83
[ 3933.879285]  [<ffffffff8027f21b>] generic_file_buffered_write+0x143/0x35b
[ 3933.879285]  [<ffffffff803817a1>] ? _raw_spin_lock+0xcf/0x18a
[ 3933.879285]  [<ffffffff8027f860>] __generic_file_aio_write_nolock+0x274/0x2a8
[ 3933.879285]  [<ffffffff802b8ab7>] ? file_update_time+0xc6/0x101
[ 3933.879285]  [<ffffffff802800f9>] generic_file_aio_write+0x78/0xd4
[ 3933.879285]  [<ffffffff80300cd4>] ext3_file_write+0x1e/0x9e
[ 3933.879285]  [<ffffffff802a6714>] do_sync_write+0xe7/0x12d
[ 3933.879285]  [<ffffffff8024be3f>] ? autoremove_wake_function+0x0/0x38
[ 3933.879285]  [<ffffffff8033c97f>] ? security_file_permission+0x11/0x13
[ 3933.879285]  [<ffffffff802a696b>] ? rw_verify_area+0xe4/0x10c
[ 3933.879285]  [<ffffffff802a7123>] vfs_write+0xd9/0x137
[ 3933.879285]  [<ffffffff802a7242>] sys_write+0x47/0x6c
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] yum-updatesd- D 00000000ffffffff  4536  6218   2539
[ 3933.879285]  ffff880079e23bb8 0000000000000046 ffff880079e23b18 ffff88007dcf54d8
[ 3933.879285]  ffff880079e23b68 ffffffff8081c780 ffffffff8081c780 ffff8800784f97f0
[ 3933.879285]  ffffffff807093b0 ffff8800784f9b48 0000000079e23b48 ffff8800784f9b48
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3933.879285]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3933.879285]  [<ffffffff8027e44d>] sync_page+0x78/0x7f
[ 3933.879285]  [<ffffffff8027e462>] sync_page_killable+0xe/0x56
[ 3933.879285]  [<ffffffff8056828e>] __wait_on_bit_lock+0x45/0x79
[ 3933.879285]  [<ffffffff8027e454>] ? sync_page_killable+0x0/0x56
[ 3933.879285]  [<ffffffff8027e2d2>] __lock_page_killable+0x63/0x6a
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff8027e1ec>] ? find_get_page+0xe8/0x101
[ 3933.879285]  [<ffffffff8027e31f>] lock_page_killable+0x46/0x4e
[ 3933.879285]  [<ffffffff8027fc77>] generic_file_aio_read+0x3e3/0x605
[ 3933.879285]  [<ffffffff80257b2e>] ? debug_mutex_free_waiter+0x2a/0x64
[ 3933.879285]  [<ffffffff802a6841>] do_sync_read+0xe7/0x12d
[ 3933.879285]  [<ffffffff80376b5e>] ? _atomic_dec_and_lock+0x5a/0x98
[ 3933.879285]  [<ffffffff8024be3f>] ? autoremove_wake_function+0x0/0x38
[ 3933.879285]  [<ffffffff8033c97f>] ? security_file_permission+0x11/0x13
[ 3933.879285]  [<ffffffff802a696b>] ? rw_verify_area+0xe4/0x10c
[ 3933.879285]  [<ffffffff802a733d>] vfs_read+0xd6/0x133
[ 3933.879285]  [<ffffffff802a73f6>] sys_pread64+0x5c/0x7a
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] GrabWeather   D 00000000ffffffff  5624  6239   3250
[ 3933.879285]  ffff880079e2fb28 0000000000000046 ffff88007f2e3cc0 00000000000006d0
[ 3933.879285]  ffff880079e2fb38 ffffffff8081c780 ffffffff8081c780 ffff880079dbf040
[ 3933.879285]  ffffffff807093b0 ffff880079dbf398 0000000079e2fad8 ffff880079dbf398
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569fad>] ? _spin_unlock_irqrestore+0x5e/0x6c
[ 3933.879285]  [<ffffffff8031371b>] do_get_write_access+0x27c/0x4c7
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff80313988>] journal_get_write_access+0x22/0x33
[ 3933.879285]  [<ffffffff8030f77e>] __ext3_journal_get_write_access+0x1f/0x48
[ 3933.879285]  [<ffffffff80308dde>] ext3_orphan_add+0xa1/0x17d
[ 3933.879285]  [<ffffffff8031423e>] ? journal_start+0xb7/0xef
[ 3933.879285]  [<ffffffff80302ff5>] ext3_setattr+0x162/0x201
[ 3933.879285]  [<ffffffff802ba510>] notify_change+0x216/0x35e
[ 3933.879285]  [<ffffffff802a5ae0>] do_truncate+0x63/0x81
[ 3933.879285]  [<ffffffff802ae39d>] ? vfs_dq_init+0x5e/0x68
[ 3933.879285]  [<ffffffff802b0c0b>] may_open+0x19f/0x1da
[ 3933.879285]  [<ffffffff802b1259>] do_filp_open+0x40f/0x806
[ 3933.879285]  [<ffffffff802b5dc6>] ? __d_free+0x76/0x7b
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569ffc>] ? _spin_unlock+0x41/0x4c
[ 3933.879285]  [<ffffffff802bb067>] ? alloc_fd+0x11d/0x12e
[ 3933.879285]  [<ffffffff802a4bf6>] do_sys_open+0x6b/0xff
[ 3933.879285]  [<ffffffff802a4cb3>] sys_open+0x1b/0x1d
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] refile        D 00000000ffffffff  5992  6248   6247
[ 3933.879285]  ffff880079d3bb68 0000000000000046 000000030006bac8 0000000000000001
[ 3933.879285]  ffff880079d3bad8 ffffffff8081c780 ffffffff8081c780 ffff880079dbf7f0
[ 3933.879285]  ffff88007f2327f0 ffff880079dbfb48 0000000100000000 ffff880079dbfb48
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff8034092d>] ? avc_has_perm+0x4e/0x60
[ 3933.879285]  [<ffffffff8056883e>] __mutex_lock_common+0x280/0x406
[ 3933.879285]  [<ffffffff80314062>] ? start_this_handle+0x3b3/0x3d0
[ 3933.879285]  [<ffffffff80568a56>] __mutex_lock_slowpath+0x14/0x16
[ 3933.879285]  [<ffffffff80568a7d>] mutex_lock+0x25/0x29
[ 3933.879285]  [<ffffffff802a8172>] lock_super+0x27/0x29
[ 3933.879285]  [<ffffffff80308d65>] ext3_orphan_add+0x28/0x17d
[ 3933.879285]  [<ffffffff8031423e>] ? journal_start+0xb7/0xef
[ 3933.879285]  [<ffffffff80302ff5>] ext3_setattr+0x162/0x201
[ 3933.879285]  [<ffffffff802ba510>] notify_change+0x216/0x35e
[ 3933.879285]  [<ffffffff802a5ae0>] do_truncate+0x63/0x81
[ 3933.879285]  [<ffffffff802ae39d>] ? vfs_dq_init+0x5e/0x68
[ 3933.879285]  [<ffffffff802b0c0b>] may_open+0x19f/0x1da
[ 3933.879285]  [<ffffffff802b1259>] do_filp_open+0x40f/0x806
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569ffc>] ? _spin_unlock+0x41/0x4c
[ 3933.879285]  [<ffffffff802bb067>] ? alloc_fd+0x11d/0x12e
[ 3933.879285]  [<ffffffff802a4bf6>] do_sys_open+0x6b/0xff
[ 3933.879285]  [<ffffffff802a4cb3>] sys_open+0x1b/0x1d
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] sendmail      D ffff88007e755c00  5624  6266   2416
[ 3933.879285]  ffff880079e5fa78 0000000000000046 ffff88007dcf54d8 ffff88007dcf54d8
[ 3933.879285]  ffff880079e5f9e8 ffffffff8081c780 ffffffff8081c780 ffff880077bb9040
[ 3933.879285]  ffff8800790a3040 ffff880077bb9398 0000000079e5fa18 ffff880077bb9398
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3933.879285]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3933.879285]  [<ffffffff802c7e91>] sync_buffer+0x3e/0x42
[ 3933.879285]  [<ffffffff8056828e>] __wait_on_bit_lock+0x45/0x79
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff8056832c>] out_of_line_wait_on_bit_lock+0x6a/0x77
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff802c8364>] __lock_buffer+0x25/0x27
[ 3933.879285]  [<ffffffff8031283d>] lock_buffer+0x44/0x48
[ 3933.879285]  [<ffffffff80313511>] do_get_write_access+0x72/0x4c7
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80317a12>] ? bit_spin_unlock+0x6b/0x79
[ 3933.879285]  [<ffffffff80313988>] journal_get_write_access+0x22/0x33
[ 3933.879285]  [<ffffffff8030f77e>] __ext3_journal_get_write_access+0x1f/0x48
[ 3933.879285]  [<ffffffff8030177d>] ext3_new_inode+0x5e0/0x9fd
[ 3933.879285]  [<ffffffff803088a4>] ext3_create+0x99/0x11b
[ 3933.879285]  [<ffffffff802b0cbf>] vfs_create+0x79/0xa0
[ 3933.879285]  [<ffffffff802b10c6>] do_filp_open+0x27c/0x806
[ 3933.879285]  [<ffffffff802aa156>] ? cp_new_stat+0xe2/0xef
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569ffc>] ? _spin_unlock+0x41/0x4c
[ 3933.879285]  [<ffffffff802bb067>] ? alloc_fd+0x11d/0x12e
[ 3933.879285]  [<ffffffff802a4bf6>] do_sys_open+0x6b/0xff
[ 3933.879285]  [<ffffffff802a4cb3>] sys_open+0x1b/0x1d
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b
[ 3933.879285] hal-acl-tool  D 00000000ffffffff  5896  6295   2110
[ 3933.879285]  ffff8800773fda78 0000000000000046 ffff88007dcf54d8 ffff88007dcf54d8
[ 3933.879285]  ffff8800773fd9e8 ffffffff8081c780 ffffffff8081c780 ffff880079118040
[ 3933.879285]  ffff88007f2327f0 ffff880079118398 00000001773fda18 ffff880079118398
[ 3933.879285] Call Trace:
[ 3933.879285]  [<ffffffff80252a1a>] ? getnstimeofday+0x4a/0xa6
[ 3933.879285]  [<ffffffff80567f2e>] io_schedule+0x63/0xa5
[ 3933.879285]  [<ffffffff802c7e91>] sync_buffer+0x3e/0x42
[ 3933.879285]  [<ffffffff8056828e>] __wait_on_bit_lock+0x45/0x79
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff802c7e53>] ? sync_buffer+0x0/0x42
[ 3933.879285]  [<ffffffff8056832c>] out_of_line_wait_on_bit_lock+0x6a/0x77
[ 3933.879285]  [<ffffffff8024be77>] ? wake_bit_function+0x0/0x2a
[ 3933.879285]  [<ffffffff802c667f>] ? put_bh+0x49/0x56
[ 3933.879285]  [<ffffffff802c8364>] __lock_buffer+0x25/0x27
[ 3933.879285]  [<ffffffff8031283d>] lock_buffer+0x44/0x48
[ 3933.879285]  [<ffffffff80313511>] do_get_write_access+0x72/0x4c7
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80317a12>] ? bit_spin_unlock+0x6b/0x79
[ 3933.879285]  [<ffffffff80313988>] journal_get_write_access+0x22/0x33
[ 3933.879285]  [<ffffffff8030f77e>] __ext3_journal_get_write_access+0x1f/0x48
[ 3933.879285]  [<ffffffff80301676>] ext3_new_inode+0x4d9/0x9fd
[ 3933.879285]  [<ffffffff803088a4>] ext3_create+0x99/0x11b
[ 3933.879285]  [<ffffffff802b0cbf>] vfs_create+0x79/0xa0
[ 3933.879285]  [<ffffffff802b10c6>] do_filp_open+0x27c/0x806
[ 3933.879285]  [<ffffffff8023a6ea>] ? do_wait+0x33c/0x464
[ 3933.879285]  [<ffffffff8022f7fc>] ? get_parent_ip+0x11/0x41
[ 3933.879285]  [<ffffffff8056cfc9>] ? sub_preempt_count+0x35/0x49
[ 3933.879285]  [<ffffffff80569ffc>] ? _spin_unlock+0x41/0x4c
[ 3933.879285]  [<ffffffff802bb067>] ? alloc_fd+0x11d/0x12e
[ 3933.879285]  [<ffffffff802a4bf6>] do_sys_open+0x6b/0xff
[ 3933.879285]  [<ffffffff802a4cb3>] sys_open+0x1b/0x1d
[ 3933.879285]  [<ffffffff8020b9db>] system_call_fastpath+0x16/0x1b


--==_Exmh_1227222347_3127P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJJe1LcC3lWbTT17ARAlmnAKDY9gfzfBTLJQDEeXX8qBTlGuzJ5gCgocO9
nkEbs0f+D9UnA6KIHpNsiOI=
=GEJJ
-----END PGP SIGNATURE-----

--==_Exmh_1227222347_3127P--
