Return-Path: <linux-kernel-owner+w=401wt.eu-S1757030AbYG3TzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030AbYG3TzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYG3TzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:55:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:5260 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbYG3TzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=s0ohh0RpMmHklDqrl3yTW72tH/8tNKOX5fScN6Fpqn9D/TeOAt9t0KfmJUTt+4EYbx
         Guzci8xI5a63EwPvcRvwcTZHUKquQSPf1qsHVAA1ZZIX+uEBG9AkwwSQK9GpveOhkBsP
         DGakYWkNmFSfJoNj2TeCCK6qyCabOGzc7qsSU=
Date: Wed, 30 Jul 2008 23:54:57 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org, akpm@osdl.org, npiggin@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc1: IP: iov_iter_advance+0x2e/0x90
Message-ID: <20080730195457.GA3517@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce:

	# while true; do ./ftest03; done

ftest03 from LTP 20080603

BUG: unable to handle kernel paging request at ffff88017c72a008
IP: [<ffffffff8026190e>] iov_iter_advance+0x2e/0x90
PGD 202063 PUD b067 PMD 17def8163 PTE 800000017c72a160
Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0 
Modules linked in: af_packet ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state iptable_filter iptable_raw ip_tables x_tables nf_conntrack_irc nf_conntrack fuse usblp usbcore
Pid: 3546, comm: ftest03 Not tainted 2.6.27-rc1 #2
RIP: 0010:[<ffffffff8026190e>]  [<ffffffff8026190e>] iov_iter_advance+0x2e/0x90
RSP: 0018:ffff88017c75fad8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000800 RCX: 0000000000000000
RDX: 0000000000000080 RSI: 0000000000000000 RDI: ffff88017c75fb78
RBP: ffff88017c75fad8 R08: ffff88017c72a000 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000001 R12: 0000000000000800
R13: 000000000006e800 R14: ffff88017f6b7ac8 R15: 0000000000000800
FS:  00007f490298d6f0(0000) GS:ffffffff8051f780(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff88017c72a008 CR3: 000000017c631000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ftest03 (pid: 3546, threadinfo ffff88017c75e000, task ffff88017c51e540)
Stack:  ffff88017c75fbd8 ffffffff80263452 000000004890c442 0000000000000246
 000000007faae000 ffff88017c75fd98 000000000006e800 ffff88017c75fd18
 ffff88017efefe00 ffff88017f6b7ac8 ffffffff80422fc0 ffff88017f6b78e0
Call Trace:
 [<ffffffff80263452>] generic_file_buffered_write+0x1e2/0x710
 [<ffffffff8040cfd0>] ? _spin_unlock+0x30/0x60
 [<ffffffff80263e0f>] __generic_file_aio_write_nolock+0x29f/0x450
 [<ffffffff80264026>] generic_file_aio_write+0x66/0xd0
 [<ffffffff802c9506>] ext3_file_write+0x26/0xc0
 [<ffffffff80264250>] ? generic_file_aio_read+0x0/0x670
 [<ffffffff802c94e0>] ? ext3_file_write+0x0/0xc0
 [<ffffffff8028921b>] do_sync_readv_writev+0xeb/0x130
 [<ffffffff8025284d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff802449c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80289055>] ? rw_copy_check_uvector+0x95/0x130
 [<ffffffff80289953>] do_readv_writev+0xc3/0x120
 [<ffffffff8025284d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff802527b5>] ? trace_hardirqs_on_caller+0xd5/0x160
 [<ffffffff8025284d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff802899e9>] vfs_writev+0x39/0x60
 [<ffffffff80289d60>] sys_writev+0x50/0x90
 [<ffffffff8020b65b>] system_call_fastpath+0x16/0x1b
Code: 77 18 48 89 e5 72 11 48 83 7f 08 01 75 11 48 01 77 10 48 29 77 18 c9 c3 0f 0b 0f 1f 00 eb fb 4c 8b 07 48 8b 4f 10 48 85 f6 75 17 <49> 83 78 08 00 75 07 48 83 7f 18 00 75 09 4c 89 07 48 89 4f 10 
RIP  [<ffffffff8026190e>] iov_iter_advance+0x2e/0x90
 RSP <ffff88017c75fad8>
CR2: ffff88017c72a008


0xffffffff8026190e is in iov_iter_advance (mm/filemap.c:1882).
1877
1878                    /*
1879                     * The !iov->iov_len check ensures we skip over unlikely
1880                     * zero-length segments (without overruning the iovec).
1881                     */
1882     ===>           while (bytes || unlikely(!iov->iov_len && i->count)) {
1883                            int copy;
1884
1885                            copy = min(bytes, iov->iov_len - base);
1886                            BUG_ON(!i->count || i->count < copy);

