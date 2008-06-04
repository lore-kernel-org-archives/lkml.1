Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbYFDRwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbYFDRwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbYFDRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:52:05 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:37962 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbYFDRwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:52:04 -0400
Message-ID: <4846D62B.4030103@krogh.cc>
Date: Wed, 04 Jun 2008 19:51:39 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs@linux.kernel.org
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Unrelated to the 2 other reports against the 2.6.26-rc4 kernel. I got 
this message. The system still operates fine so it is not critical in 
anyway. I thought I'd report it anyway. CC'ing the autofs-mailing list
since it seems autofs related.

[43071687.620727] INFO: task automount:23131 blocked for more than 120 
seconds.
[43071687.740715] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[43071687.862459] automount     D ffff810103a2b380     0 23131   7655
[43071687.862466]  ffff8101fb5d9b28 0000000000000082 0000000000000000 
0000000000000000
[43071687.862472]  ffffffff8069e380 ffffffff8069e380 ffffffff8069a4c0 
ffffffff8069e380
[43071687.862475]  ffff8101e8d1af00 ffff8101fb5d9ae8 ffff8101fb5d9ad8 
ffff8101fb5d9af4
[43071687.862480] Call Trace:
[43071687.862556]  [<ffffffffa03c47c0>] 
:sunrpc:rpc_wait_bit_killable+0x0/0x40
[43071687.862570]  [<ffffffffa03c47dc>] 
:sunrpc:rpc_wait_bit_killable+0x1c/0x40
[43071687.862581]  [<ffffffff804764bf>] __wait_on_bit+0x4f/0x80
[43071687.862594]  [<ffffffffa03c47c0>] 
:sunrpc:rpc_wait_bit_killable+0x0/0x40
[43071687.862600]  [<ffffffff8047656a>] out_of_line_wait_on_bit+0x7a/0xa0
[43071687.862606]  [<ffffffff8024c060>] wake_bit_function+0x0/0x30
[43071687.862618]  [<ffffffffa03c0e13>] :sunrpc:xprt_connect+0x83/0x170
[43071687.862633]  [<ffffffffa03c4e69>] :sunrpc:__rpc_execute+0xc9/0x270
[43071687.862645]  [<ffffffffa03bded4>] :sunrpc:rpc_run_task+0x34/0x70
[43071687.862657]  [<ffffffffa03bdfac>] :sunrpc:rpc_call_sync+0x3c/0x60
[43071687.862667]  [<ffffffff802b9379>] __follow_mount+0x29/0xa0
[43071687.862696]  [<ffffffffa042220a>] :nfs:nfs3_rpc_wrapper+0x3a/0x60
[43071687.862711]  [<ffffffffa04225e1>] :nfs:nfs3_proc_getattr+0x51/0x90
[43071687.862724]  [<ffffffffa0415273>] 
:nfs:__nfs_revalidate_inode+0x183/0x2b0
[43071687.862733]  [<ffffffff802ca0b1>] mntput_no_expire+0x21/0x140
[43071687.862738]  [<ffffffff802ca0b1>] mntput_no_expire+0x21/0x140
[43071687.862744]  [<ffffffff802bc2e1>] path_walk+0xb1/0xd0
[43071687.862759]  [<ffffffffa0415c9a>] :nfs:nfs_getattr+0x7a/0x120
[43071687.862765]  [<ffffffff802b4d53>] vfs_lstat_fd+0x43/0x70
[43071687.862774]  [<ffffffff802c3e88>] d_kill+0x48/0x70
[43071687.862780]  [<ffffffff802c417f>] dput+0x1f/0xf0
[43071687.862784]  [<ffffffff802d1440>] dcache_dir_close+0x10/0x20
[43071687.862788]  [<ffffffff802b4da7>] sys_newlstat+0x27/0x50
[43071687.862792]  [<ffffffff802ca0b1>] mntput_no_expire+0x21/0x140
[43071687.862798]  [<ffffffff802aef04>] filp_close+0x54/0x90
[43071687.862802]  [<ffffffff802b0694>] sys_close+0x94/0xe0
[43071687.862808]  [<ffffffff8020c2bb>] system_call_after_swapgs+0x7b/0x80
[43071687.862816]

The system is a "quite hard" loaded 8x dual-core Sun X4600 server
(amd64).

Jesper
-- 
Jesper Krogh
