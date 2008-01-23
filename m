Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbYAWWbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbYAWWbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYAWWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:31:35 -0500
Received: from smtpout.bnl.gov ([130.199.3.136]:42543 "EHLO smtpout.bnl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYAWWbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:31:34 -0500
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2008 17:31:34 EST
Message-ID: <4797BD62.1070608@bnl.gov>
Date: Wed, 23 Jan 2008 17:19:14 -0500
From: Sev Binello <sev@bnl.gov>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.13pre) Gecko/20071018 Red Hat/1.0.9-6.el4 SeaMonkey/1.0.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Many processes stuck in blk_congestion_wait
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BNL-MailScanner-Information: Please contact the ITD Service Desk for more information
X-BNL-MailScanner: Found to be clean
X-BNL-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-3.85, required 5,
	autolearn=disabled, BAYES_00 -3.60, BNL_OK_FROMDOTGOV -0.25)
X-BNL-MailScanner-From: sev@bnl.gov
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are experiencing numerous hangs/slow downs on our WS4 U5 nfs client 
machines (not seen on WS3).
Many processes end up in a D state for long periods of time
and are in  blk_congestion_wait().

Time in this state can vary,
not sure what triggers them to come out, some don't
But time in this state can be quite lengthy.
Machines are running 2.6.9-55.0.9.ELsmp

Below is a sample trace, they all look pretty much the same....

Any clues how to debug this ?
Thanks
-Sev

-- 

Sev Binello
Brookhaven National Laboratory
Upton, New York
631-344-5647
sev@bnl.gov

Jan 23 12:39:27 acnmcr4p kernel: RampEditor    D C02D6EB4  1288 
21855      1         21857 22139 (NOTLB)
Jan 23 12:39:27 acnmcr4p kernel: f6e5ec94 00200086 65cc8b98 c02d6eb4 
f56a9430 e3923830 00200200 00000000 Jan 23 12:39:27 acnmcr4p kernel: 
c35c4860 00000000 c35bc780 c35bbde0 00000000 00000000 0d1d4140 001553b9 
Jan 23 12:39:27 acnmcr4p kernel:e3923830 e8fd93f0 e8fd955c 00000000 
00200246 65cef381 65cef381 f6e5ed04 Jan 23 12:39:27 acnmcr4p kernel: 
Call Trace:
Jan 23 12:39:27 acnmcr4p kernel:  [<c02d6eb4>] common_interrupt+0x18/0x20
Jan 23 12:39:27 acnmcr4p kernel:  [<c02d4c5a>] schedule_timeout+0x139/0x154
Jan 23 12:39:27 acnmcr4p kernel:  [<c012a73a>] process_timeout+0x0/0x5
Jan 23 12:39:27 acnmcr4p kernel:  [<c02d4b17>] 
io_schedule_timeout+0x26/0x30
Jan 23 12:39:27 acnmcr4p kernel:  [<c02267f8>] 
blk_congestion_wait+0x64/0x78
Jan 23 12:39:27 acnmcr4p kernel:  [<c012052d>] 
autoremove_wake_function+0x0/0x2d
Jan 23 12:39:27 acnmcr4p kernel:  [<c0145038>] 
get_writeback_state+0x30/0x35
Jan 23 12:39:27 acnmcr4p kernel:  [<c012052d>] 
autoremove_wake_function+0x0/0x2d
Jan 23 12:39:27 acnmcr4p kernel:  [<c0145291>] 
balance_dirty_pages+0xbe/0x11c
Jan 23 12:39:27 acnmcr4p kernel:  [<f8f86105>] 
nfs_commit_write+0x43/0x72 [nfs]
Jan 23 12:39:27 acnmcr4p kernel:  [<c0142517>] 
generic_file_buffered_write+0x41f/0x501
Jan 23 12:39:27 acnmcr4p kernel:  [<c01ac299>] inode_has_perm+0x4c/0x54
Jan 23 12:39:27 acnmcr4p kernel:  [<c011dd34>] move_tasks+0x19d/0x202
Jan 23 12:39:27 acnmcr4p kernel:  [<c0142982>] 
__generic_file_aio_write_nolock+0x389/0x3b7
Jan 23 12:39:27 acnmcr4p kernel:  [<c01429e9>] 
generic_file_aio_write_nolock+0x39/0x7f
Jan 23 12:39:27 acnmcr4p kernel:  [<c0142bd3>] 
generic_file_aio_write+0x72/0xc6
Jan 23 12:39:27 acnmcr4p kernel:  [<f8f86212>] nfs_file_write+0xde/0xf9 
[nfs]
Jan 23 12:39:27 acnmcr4p kernel:  [<c015b5b8>] do_sync_write+0x9e/0xcb
Jan 23 12:39:27 acnmcr4p kernel:  [<c016be58>] poll_freewait+0x33/0x38
Jan 23 12:39:27 acnmcr4p kernel:  [<c01adf3a>] 
selinux_file_permission+0x117/0x120
Jan 23 12:39:27 acnmcr4p kernel:  [<c012052d>] 
autoremove_wake_function+0x0/0x2d
Jan 23 12:39:27 acnmcr4p kernel:  [<c015b69b>] vfs_write+0xb6/0xe2
Jan 23 12:39:27 acnmcr4p kernel:  [<c015b765>] sys_write+0x3c/0x62
Jan 23 12:39:27 acnmcr4p kernel:  [<c02d64db>] syscall_call+0x7/0xb
Jan 23 12:39:27 acnmcr4p kernel:  [<c02d007b>] 
unix_dgram_sendmsg+0x23c/0x45d


