Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbXEPMjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbXEPMjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXEPMji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:39:38 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:34350 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757241AbXEPMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:39:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=tlYDBTTQnQaXFrokZ7c2WrZZCICoHiQUAsndfzckmM/dblJZFhV7NJoXQ3BXBIKY8wYGCrR3hkqdmMFhomPvvNH979qGxpGHGW10/httiuLdUzJogbDJq95UORNp86Ja1czlbOFvvtQWypvU4Y5XbNJhlCReIAaU7jHTkbD22ds=  ;
X-YMail-OSG: un4ZTFcVM1l9ufjJ.sZ7Zgkh3RyD.qsRK6BJ8U9DuPk28h3cz0wsF.mBdzZ_0guWaC5rXG.OutdWuxl3nWCCbYHDPzs.t4owTOgiqyDq_LXt7oNTQ80C4jEXsAJaLg--
Message-ID: <464AFB81.5050109@yahoo.com.au>
Date: Wed, 16 May 2007 22:39:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trond.myklebust@fys.uio.no
Subject: Re: (NFS) BUG: at page-writeback.c:829 [Was: 2.6.22-rc1-mm1]
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464AF4A6.5060000@gmail.com>
In-Reply-To: <464AF4A6.5060000@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Andrew Morton napsal(a):
> 
>>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> 
> 
> I've got this in dmesg:
> 
> BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
>  [<c010531e>] dump_trace+0x1ce/0x200
>  [<c010536a>] show_trace_log_lvl+0x1a/0x30
>  [<c0106012>] show_trace+0x12/0x20
>  [<c0106086>] dump_stack+0x16/0x20
>  [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
>  [<c0155690>] redirty_page_for_writepage+0x10/0x20
>  [<c01938fc>] __block_write_full_page+0x20c/0x330
>  [<c0193b0a>] block_write_full_page+0xea/0x100
>  [<c0196c82>] blkdev_writepage+0x12/0x20
>  [<c015539e>] __writepage+0xe/0x30
>  [<c01558c2>] write_cache_pages+0x222/0x340
>  [<c0155a03>] generic_writepages+0x23/0x30
>  [<c0155a3e>] do_writepages+0x2e/0x50
>  [<c018decb>] __writeback_single_inode+0x8b/0x470
>  [<c018e75b>] generic_sync_sb_inodes+0x24b/0x470
>  [<c018e9a7>] sync_sb_inodes+0x27/0x30
>  [<c018ec33>] writeback_inodes+0xb3/0xe0
>  [<c01560f2>] wb_kupdate+0x82/0xf0
>  [<c015660b>] pdflush+0xeb/0x1b0
>  [<c0132e72>] kthread+0x42/0x70
>  [<c0104d4b>] kernel_thread_helper+0x7/0x1c

Do you have any messages before this one? Seems like it is probably metadata,
but we've only caught it at the last minute...


>  =======================
> BUG: at /local/xslaby/xxx/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
>  [<c010531e>] dump_trace+0x1ce/0x200
>  [<c010536a>] show_trace_log_lvl+0x1a/0x30
>  [<c0106012>] show_trace+0x12/0x20
>  [<c0106086>] dump_stack+0x16/0x20
>  [<c015566d>] __set_page_dirty_nobuffers+0x11d/0x130
>  [<f8b1fc5b>] nfs_updatepage+0x7b/0x200 [nfs]
>  [<f8b156df>] nfs_commit_write+0x2f/0x50 [nfs]
>  [<c0150911>] generic_file_buffered_write+0x2a1/0x660
>  [<c0150f52>] __generic_file_aio_write_nolock+0x282/0x520
>  [<c0151252>] generic_file_aio_write+0x62/0xd0
>  [<f8b15def>] nfs_file_write+0xef/0x1c0 [nfs]
>  [<c01715e0>] do_sync_write+0xd0/0x110
>  [<c0171e04>] vfs_write+0x94/0x130
>  [<c017248d>] sys_write+0x3d/0x70
>  [<c01040e8>] syscall_call+0x7/0xb
>  [<b7eb7b3e>] 0xb7eb7b3e
>  =======================

This one is NFS, setting the page dirty while it is not uptodate. Trond,
is this because NFS keeps track of dirty regions of the page with private
data? It might make sense to avoid this warning if PagePrivate is set...
would that fix the NFS case?

-- 
SUSE Labs, Novell Inc.
