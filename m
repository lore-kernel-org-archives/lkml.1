Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYA3A3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYA3A3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYA3A2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:28:54 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39952 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbYA3A2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:28:52 -0500
To: linux-kernel@vger.kernel.org
Subject: task blocked in sync_buffer from ext3_free_branches
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 29 Jan 2008 16:28:35 -0800
Message-ID: <aday7a8cg24.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jan 2008 00:28:36.0296 (UTC) FILETIME=[0D6F7C80:01C862D7]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting the following while building a kernel (with make -j24 on
an 8 CPU system: 4 socket dual-core opteron) with current Linus git
(5b10ca19 is my head).  Once this happens the build is hung, although
I can ssh in and get a new shell OK.

Any ideas or suggestions on what would be useful debugging
information?

[  201.820629] INFO: task mv:7225 blocked for more than 120 seco.
[  201.824624] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  201.828622] mv            D 0000000000000000     0  7225   7055
[  201.840623]  ffff8101c11bdb48 0000000000000086 0000000000000000 ffff810074432360
[  201.857186]  ffff810242822c00 ffff8101c11bdaf8 ffff810074432360 ffffffff80597200
[  201.876624]  ffffffff80597200 ffffffff80593c80 ffffffff80597200 ffff8101c1059120
[  201.892626] Call Trace:
[  201.896647]  [<ffffffff8029acc3>] sync_buffer+0x0/0x40
[  201.900628]  [<ffffffff804239c9>] io_schedule+0x28/0x33
[  201.904628]  [<ffffffff8029acfe>] sync_buffer+0x3b/0x40
[  201.908628]  [<ffffffff80423c1d>] __wait_on_bit+0x40/0x6e
[  201.912629]  [<ffffffff8029acc3>] sync_buffer+0x0/0x40
[  201.916628]  [<ffffffff80423cb7>] out_of_line_wait_on_bit+0x6c/0x78
[  201.920631]  [<ffffffff8023f9b1>] wake_bit_function+0x0/0x23
[  201.924630]  [<ffffffff8029bfa1>] __bread+0x61/0x76
[  201.928632]  [<ffffffff802c10af>] ext3_free_branches+0x90/0x1b8
[  201.932631]  [<ffffffff802c18f4>] ext3_truncate+0x71d/0x871
[  201.936632]  [<ffffffff802ece75>] start_this_handle+0x294/0x304
[  201.940631]  [<ffffffff802ec7dc>] journal_stop+0x192/0x19e
[  201.944632]  [<ffffffff802ecf80>] journal_start+0x9b/0xd2
[  201.948632]  [<ffffffff802c202f>] ext3_delete_inode+0x7a/0xcf
[  201.952631]  [<ffffffff802c1fb5>] ext3_delete_inode+0x0/0xcf
[  201.956632]  [<ffffffff8028df30>] generic_delete_inode+0xa7/0x11d
[  201.960631]  [<ffffffff8028b36d>] d_kill+0x34/0x55
[  201.964632]  [<ffffffff8028b71a>] dput+0x101/0x10b
[  201.968633]  [<ffffffff8028598b>] sys_renameat+0x18d/0x1fc
[  201.972634]  [<ffffffff80426986>] do_page_fault+0x3d8/0x724
[  201.976635]  [<ffffffff8027f461>] sys_newlstat+0x28/0x31
[  201.980636]  [<ffffffff8020bede>] system_call+0x7e/0x83
