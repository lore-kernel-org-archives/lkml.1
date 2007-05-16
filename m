Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbXEPObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbXEPObT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbXEPObC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:31:02 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:28042 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbXEPObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=MuRNeimEBMQaWGu/S28YG+q/8Cx6cEHyJ1sMJ9L/S+7S5UKcCPFl64MSnfhtZ1NQ744s56vC3AMTlGmCPqdZo5c1JlLmpHdw3tEd9DX6k2W/BIL9OMh1oDqAyggp/FegeI72XjGVRLKQke9N3H0asZ7WrDUHQFdDsbazFkMyl8Y=
Message-ID: <464B159B.6060902@googlemail.com>
Date: Wed, 16 May 2007 16:30:51 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> 
> 
> - I found some time to look into some writeback problems in
>   fs/fs-writeback.c.

This might be related

[   97.740021] BUG: at /home/devel/linux-mm/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
[   97.748632]  [<c0105276>] dump_trace+0x63/0x1eb
[   97.753275]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
[   97.758521]  [<c010605a>] show_trace+0x12/0x14
[   97.763042]  [<c01060f7>] dump_stack+0x16/0x18
[   97.767590]  [<c01677b3>] __set_page_dirty_nobuffers+0xfe/0x16e
[   97.773598]  [<c0167833>] redirty_page_for_writepage+0x10/0x12
[   97.779491]  [<c01a473a>] __block_write_full_page+0x1dc/0x335
[   97.785328]  [<c01a495c>] block_write_full_page+0xc9/0xd1
[   97.790799]  [<c01a781a>] blkdev_writepage+0x12/0x14
[   97.795829]  [<c01674ea>] __writepage+0xe/0x29
[   97.800350]  [<c01679b8>] write_cache_pages+0x183/0x29a
[   97.805683]  [<c0167af1>] generic_writepages+0x22/0x2a
[   97.810929]  [<c0167b1c>] do_writepages+0x23/0x34
[   97.815702]  [<c019f0a3>] __writeback_single_inode+0x245/0x472
[   97.821632]  [<c019f7e6>] generic_sync_sb_inodes+0x347/0x4cc
[   97.827379]  [<c019f98b>] sync_sb_inodes+0x20/0x24
[   97.832247]  [<c019fb93>] writeback_inodes+0x79/0xc2
[   97.837296]  [<c0168173>] wb_kupdate+0x7a/0xdb
[   97.841833]  [<c01686a0>] pdflush+0xf1/0x189
[   97.846173]  [<c0137d41>] kthread+0x3b/0x62
[   97.850461]  [<c0104e3f>] kernel_thread_helper+0x7/0x10

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/mm-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc1-mm1/mm-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
