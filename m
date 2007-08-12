Return-Path: <linux-kernel-owner+w=401wt.eu-S1765482AbXHLIXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765482AbXHLIXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXHLIXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:23:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755327AbXHLIXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:23:17 -0400
Date: Sun, 12 Aug 2007 01:23:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russ Dill <Russ.Dill@gmail.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: Process stuck in md_wakeup_thread
Message-Id: <20070812012305.1c717196.akpm@linux-foundation.org>
In-Reply-To: <loom.20070811T042748-157@post.gmane.org>
References: <loom.20070811T042748-157@post.gmane.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007 02:34:34 +0000 (UTC) Russ Dill <Russ.Dill@gmail.com> wrote:

> On 2.6.22 from debian (stock), I have a process (dpkg) stuck with the following
> calltrace:
> 
> SysRq : Show Blocked State
> 
>                          free                        sibling
>   task             PC    stack   pid father child younger older
> dpkg          D 00000003     0 26040  20765 (NOTLB)
>        e57d5e30 00200082 00000000 00000003 dfc48ba8 00000000 dfc48ba8 00000000 
>        00000007 e0af45c0 e8ce17aa 0002827f 00051ec2 e0af46cc c1809980 00000000 
>        e8ce1324 0002827f 00200082 f881cd4c 00200286 f8ba2c85 c1809980 e57d5e60 
> Call Trace:
>  [<f881cd4c>] md_wakeup_thread+0x26/0x28 [md_mod]
>  [<f8ba2c85>] raid5_unplug_device+0x4e/0x5a [raid456]

The above is stack gunk.

>  [<c02a786e>] io_schedule+0x1d/0x27
>  [<c014f3c5>] sync_page+0x0/0x3b
>  [<c014f3fd>] sync_page+0x38/0x3b
>  [<c02a7a6f>] __wait_on_bit_lock+0x2a/0x52
>  [<c014f3b7>] __lock_page+0x58/0x5e
>  [<c01333aa>] wake_bit_function+0x0/0x3c
>  [<c0155daa>] truncate_inode_pages_range+0x201/0x256
>  [<c0155e16>] truncate_inode_pages+0x17/0x1a
>  [<f8c867eb>] reiserfs_delete_inode+0x36/0xdd [reiserfs]
>  [<f8c867b5>] reiserfs_delete_inode+0x0/0xdd [reiserfs]
>  [<c017acc5>] generic_delete_inode+0xa0/0x105
>  [<c017a4ad>] iput+0x60/0x62
>  [<c0172f41>] do_unlinkat+0xb6/0x126
>  [<c0103d7e>] syscall_call+0x7/0xb
>  =======================
> 
> My system is still up and running.
> 

It's stuck waiting for a page to come unlocked.  The most likely
explanation is that an IO got lost.
