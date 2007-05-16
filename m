Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbXEPPfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbXEPPfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757668AbXEPPfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:35:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:3034 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbXEPPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=KFQk3EFpa/+G8HxZuJBJU7F9qQuUZV+AiMYN6hyBHlBqiLJ+Oe9oVB2B6DtsJef9NJr9DFZt4vYPUk9wNh0yL89Vuizf0kXxnNT5wQWrly7erlJPev4OXR934fluq/XzdQbBOLpB1W/K9Ak7DSw2R9kCdLcXYegoXCnzKqY2mHI=
Message-ID: <464B2476.2070700@googlemail.com>
Date: Wed, 16 May 2007 17:34:14 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B159B.6060902@googlemail.com>
In-Reply-To: <464B159B.6060902@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Andrew Morton napisał(a):
>   
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
>>
>>
>> - I found some time to look into some writeback problems in
>>   fs/fs-writeback.c.
>>     
>
> This might be related
>
> [   97.740021] BUG: at /home/devel/linux-mm/mm/page-writeback.c:829 __set_page_dirty_nobuffers()
> [   97.748632]  [<c0105276>] dump_trace+0x63/0x1eb
> [   97.753275]  [<c0105418>] show_trace_log_lvl+0x1a/0x30
> [   97.758521]  [<c010605a>] show_trace+0x12/0x14
> [   97.763042]  [<c01060f7>] dump_stack+0x16/0x18
> [   97.767590]  [<c01677b3>] __set_page_dirty_nobuffers+0xfe/0x16e
> [   97.773598]  [<c0167833>] redirty_page_for_writepage+0x10/0x12
> [   97.779491]  [<c01a473a>] __block_write_full_page+0x1dc/0x335
> [   97.785328]  [<c01a495c>] block_write_full_page+0xc9/0xd1
> [   97.790799]  [<c01a781a>] blkdev_writepage+0x12/0x14
> [   97.795829]  [<c01674ea>] __writepage+0xe/0x29
> [   97.800350]  [<c01679b8>] write_cache_pages+0x183/0x29a
> [   97.805683]  [<c0167af1>] generic_writepages+0x22/0x2a
> [   97.810929]  [<c0167b1c>] do_writepages+0x23/0x34
> [   97.815702]  [<c019f0a3>] __writeback_single_inode+0x245/0x472
> [   97.821632]  [<c019f7e6>] generic_sync_sb_inodes+0x347/0x4cc
> [   97.827379]  [<c019f98b>] sync_sb_inodes+0x20/0x24
> [   97.832247]  [<c019fb93>] writeback_inodes+0x79/0xc2
> [   97.837296]  [<c0168173>] wb_kupdate+0x7a/0xdb
> [   97.841833]  [<c01686a0>] pdflush+0xf1/0x189
> [   97.846173]  [<c0137d41>] kthread+0x3b/0x62
> [   97.850461]  [<c0104e3f>] kernel_thread_helper+0x7/0x10
>
>   



This one as well I guess :

[14649.407909] BUG: at mm/page-writeback.c:829 __set_page_dirty_nobuffers()
[14649.407945]  [<c0156bb3>] __set_page_dirty_nobuffers+0x9a/0x104
[14649.407976]  [<c018cfea>] __block_write_full_page+0x1b7/0x2f1
[14649.407999]  [<e8ba89b4>] ext3_get_block+0x0/0xd0 [ext3]
[14649.408039]  [<c018d1f2>] block_write_full_page+0xce/0xd6
[14649.408054]  [<e8ba743a>] walk_page_buffers+0x4d/0x67 [ext3]
[14649.408072]  [<e8ba89b4>] ext3_get_block+0x0/0xd0 [ext3]
[14649.408096]  [<e8ba9f52>] ext3_ordered_writepage+0xdc/0x189 [ext3]
[14649.408115]  [<e8ba7454>] bget_one+0x0/0x7 [ext3]
[14649.408142]  [<c01569cf>] __writepage+0xb/0x26
[14649.408153]  [<c0156d88>] write_cache_pages+0x161/0x274
[14649.408166]  [<c01569c4>] __writepage+0x0/0x26
[14649.408187]  [<e8beaa03>] rtl8139_interrupt+0x3cd/0x3d7 [8139too]
[14649.408217]  [<c01c97c3>] __next_cpu+0x15/0x26
[14649.408229]  [<c011b561>] find_busiest_group+0x1c9/0x54a
[14649.408251]  [<c0156eba>] generic_writepages+0x1f/0x27
[14649.408263]  [<c0156eee>] do_writepages+0x2c/0x34
[14649.408275]  [<c018845d>] __writeback_single_inode+0x1c3/0x3aa
[14649.408295]  [<c0188235>] __check_dirty_inode_list+0x21/0x86
[14649.408321]  [<c0188a46>] generic_sync_sb_inodes+0x267/0x3a8
[14649.408347]  [<c0188f49>] writeback_inodes+0x63/0xaa
[14649.408355]  [<c0132db8>] autoremove_wake_function+0x0/0x35
[14649.408368]  [<c015777a>] pdflush+0x0/0x1a3
[14649.408377]  [<c01574c1>] wb_kupdate+0x7f/0xe3
[14649.408410]  [<c0157887>] pdflush+0x10d/0x1a3
[14649.408425]  [<c0157442>] wb_kupdate+0x0/0xe3
[14649.408440]  [<c0132ce6>] kthread+0x3b/0x61
[14649.408447]  [<c0132cab>] kthread+0x0/0x61
[14649.408455]  [<c0104a27>] kernel_thread_helper+0x7/0x10
[14649.408473]  =======================
[24270.804919] BUG: at mm/page-writeback.c:829 __set_page_dirty_nobuffers()
[24270.804955]  [<c0156bb3>] __set_page_dirty_nobuffers+0x9a/0x104
[24270.804986]  [<c018cfea>] __block_write_full_page+0x1b7/0x2f1
[24270.805014]  [<e8ba89b4>] ext3_get_block+0x0/0xd0 [ext3]
[24270.805055]  [<c018d1f2>] block_write_full_page+0xce/0xd6
[24270.805069]  [<e8ba743a>] walk_page_buffers+0x4d/0x67 [ext3]
[24270.805086]  [<e8ba89b4>] ext3_get_block+0x0/0xd0 [ext3]
[24270.805110]  [<e8ba9f52>] ext3_ordered_writepage+0xdc/0x189 [ext3]
[24270.805131]  [<e8ba7454>] bget_one+0x0/0x7 [ext3]
[24270.805159]  [<c01569cf>] __writepage+0xb/0x26
[24270.805171]  [<c0156d88>] write_cache_pages+0x161/0x274
[24270.805183]  [<c01569c4>] __writepage+0x0/0x26
[24270.805244]  [<c0156eba>] generic_writepages+0x1f/0x27
[24270.805256]  [<c0156eee>] do_writepages+0x2c/0x34
[24270.805267]  [<c018845d>] __writeback_single_inode+0x1c3/0x3aa
[24270.805287]  [<c0188235>] __check_dirty_inode_list+0x21/0x86
[24270.805313]  [<c0188a46>] generic_sync_sb_inodes+0x267/0x3a8
[24270.805339]  [<c0188f49>] writeback_inodes+0x63/0xaa
[24270.805347]  [<c0132db8>] autoremove_wake_function+0x0/0x35
[24270.805358]  [<c015777a>] pdflush+0x0/0x1a3
[24270.805367]  [<c01574c1>] wb_kupdate+0x7f/0xe3
[24270.805401]  [<c0157887>] pdflush+0x10d/0x1a3
[24270.805416]  [<c0157442>] wb_kupdate+0x0/0xe3
[24270.805431]  [<c0132ce6>] kthread+0x3b/0x61
[24270.805438]  [<c0132cab>] kthread+0x0/0x61
[24270.805445]  [<c0104a27>] kernel_thread_helper+0x7/0x10
[24270.805463]  =======================


http://crazy.dev.frugalware.org/MM/2.6.22-rc1-mm1.dmesg
http://crazy.dev.frugalware.org/MM/2.6.22-rc1-mm1.config

Gabriel

