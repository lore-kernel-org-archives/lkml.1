Return-Path: <linux-kernel-owner+w=401wt.eu-S1762600AbXEPMKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762600AbXEPMKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759187AbXEPMJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:09:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:27296 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbXEPMJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X2ZOaS4Q7Tj323rlQLvKG9g9hogZ62/8pvo8ew9w6SdouWqp/2tNXyR9/pQRbrD8TQa30uW2bxBDuGVs9voomgIOTjD4mjgr90oO9uICxvZMlYrY8Oock4R1DzAMUgXKuIHww13fbJ675SHQVkMyfjiafyNvpp1tv6TM/S0O2mY=
Message-ID: <464AF4A6.5060000@gmail.com>
Date: Wed, 16 May 2007 14:10:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: (NFS) BUG: at page-writeback.c:829 [Was: 2.6.22-rc1-mm1]
References: <20070515201914.16944e04.akpm@linux-foundation.org>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/

I've got this in dmesg:

BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
 [<c010531e>] dump_trace+0x1ce/0x200
 [<c010536a>] show_trace_log_lvl+0x1a/0x30
 [<c0106012>] show_trace+0x12/0x20
 [<c0106086>] dump_stack+0x16/0x20
 [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
 [<c0155690>] redirty_page_for_writepage+0x10/0x20
 [<c01938fc>] __block_write_full_page+0x20c/0x330
 [<c0193b0a>] block_write_full_page+0xea/0x100
 [<c0196c82>] blkdev_writepage+0x12/0x20
 [<c015539e>] __writepage+0xe/0x30
 [<c01558c2>] write_cache_pages+0x222/0x340
 [<c0155a03>] generic_writepages+0x23/0x30
 [<c0155a3e>] do_writepages+0x2e/0x50
 [<c018decb>] __writeback_single_inode+0x8b/0x470
 [<c018e75b>] generic_sync_sb_inodes+0x24b/0x470
 [<c018e9a7>] sync_sb_inodes+0x27/0x30
 [<c018ec33>] writeback_inodes+0xb3/0xe0
 [<c01560f2>] wb_kupdate+0x82/0xf0
 [<c015660b>] pdflush+0xeb/0x1b0
 [<c0132e72>] kthread+0x42/0x70
 [<c0104d4b>] kernel_thread_helper+0x7/0x1c
 =======================
BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
 [<c010531e>] dump_trace+0x1ce/0x200
 [<c010536a>] show_trace_log_lvl+0x1a/0x30
 [<c0106012>] show_trace+0x12/0x20
 [<c0106086>] dump_stack+0x16/0x20
 [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
 [<f8b1fc5b>] nfs_updatepage+0x7b/0x200 [nfs]
 [<f8b156df>] nfs_commit_write+0x2f/0x50 [nfs]
 [<c0150911>] generic_file_buffered_write+0x2a1/0x660
 [<c0150f52>] __generic_file_aio_write_nolock+0x282/0x520
 [<c0151252>] generic_file_aio_write+0x62/0xd0
 [<f8b15def>] nfs_file_write+0xef/0x1c0 [nfs]
 [<c01715e0>] do_sync_write+0xd0/0x110
 [<c0171e04>] vfs_write+0x94/0x130
 [<c017248d>] sys_write+0x3d/0x70
 [<c01040e8>] syscall_call+0x7/0xb
 [<b7eb7b3e>] 0xb7eb7b3e
 =======================

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
