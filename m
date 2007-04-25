Return-Path: <linux-kernel-owner+w=401wt.eu-S2992561AbXDYKGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992561AbXDYKGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992562AbXDYKGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:06:16 -0400
Received: from wasp.net.au ([203.190.192.17]:48405 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992561AbXDYKGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:06:15 -0400
Message-ID: <462F2810.6000909@wasp.net.au>
Date: Wed, 25 Apr 2007 14:06:08 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Jens Axboe <jens.axboe@oracle.com>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au>	<46220339.9080205@wasp.net.au>	<4623FB29.1000603@redhat.com>	<17956.22235.574867.179016@notabene.brown>	<20070418123757.GC3796@kernel.dk>	<46261ACE.1050407@wasp.net.au>	<20070418132157.GC3720@kernel.dk>	<462B10C3.1030906@wasp.net.au>	<20070423073543.GE5311@kernel.dk>	<462E5D38.5000801@wasp.net.au> <17967.4734.783140.512857@notabene.brown>
In-Reply-To: <17967.4734.783140.512857@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:

> 
> You could test this theory by putting a
>    WARN_ON(cfqq->next_rq == NULL);
> at the end of cfq_reposition_rq_rb, just after the cfq_add_rq_rb call.
> 


[  756.311074] BUG: at block/cfq-iosched.c:543 cfq_reposition_rq_rb()
[  756.329615]  [<c0204fa1>] cfq_merged_request+0x71/0x80
[  756.345046]  [<c0204f30>] cfq_merged_request+0x0/0x80
[  756.360216]  [<c01fb4ae>] elv_merged_request+0x4e/0x50
[  756.375647]  [<c01ff1a7>] __make_request+0x1a7/0x2f0
[  756.390557]  [<c01ff497>] generic_make_request+0x127/0x190
[  756.407025]  [<c02bb011>] chunk_aligned_read+0x111/0x1c0
[  756.422974]  [<c01ff497>] generic_make_request+0x127/0x190
[  756.439443]  [<c02bb448>] make_request+0x388/0x3b0
[  756.453834]  [<c016e027>] __bio_add_page+0x147/0x1c0
[  756.468742]  [<c016dbff>] bio_alloc_bioset+0x7f/0x150
[  756.483913]  [<c02bac50>] raid5_mergeable_bvec+0x0/0x90
[  756.499604]  [<c016e107>] bio_add_page+0x37/0x50
[  756.513473]  [<c01ff497>] generic_make_request+0x127/0x190
[  756.529943]  [<c013586a>] mempool_free+0x2a/0x60
[  756.543812]  [<c016dadd>] bio_free+0x1d/0x40
[  756.556645]  [<c01ff546>] submit_bio+0x46/0xc0
[  756.571389]  [<c020a396>] radix_tree_node_alloc+0x16/0x60
[  756.587610]  [<c020a5c2>] radix_tree_insert+0xe2/0x130
[  756.603039]  [<c0139575>] __pagevec_lru_add+0x75/0x80
[  756.618207]  [<c0171971>] mpage_bio_submit+0x11/0x20
[  756.633117]  [<c01720e0>] mpage_readpages+0x100/0x140
[  756.648287]  [<c0187d50>] ext3_get_block+0x0/0xe0
[  756.662419]  [<c026fc0b>] scsi_end_request+0x9b/0xc0
[  756.677329]  [<c026dd2b>] scsi_delete_timer+0xb/0x20
[  756.692240]  [<c0188ae0>] ext3_readpages+0x0/0x20
[  756.706369]  [<c0138ac1>] read_pages+0xd1/0xe0
[  756.719719]  [<c0187d50>] ext3_get_block+0x0/0xe0
[  756.733853]  [<c0136e24>] __alloc_pages+0x54/0x2d0
[  756.748242]  [<c02704ff>] scsi_softirq_done+0x6f/0xe0
[  756.763413]  [<c02861a1>] sil_interrupt+0x81/0x90
[  756.777544]  [<c01ffa78>] blk_done_softirq+0x58/0x70
[  756.792454]  [<c0138b78>] __do_page_cache_readahead+0xa8/0x110
[  756.809961]  [<c0138d21>] blockable_page_cache_readahead+0x51/0xd0
[  756.828508]  [<c0138e14>] make_ahead_window+0x74/0xc0
[  756.843679]  [<c0138efa>] page_cache_readahead+0x9a/0x180
[  756.859886]  [<c0133704>] file_read_actor+0xc4/0xd0
[  756.874537]  [<c0133637>] do_generic_mapping_read+0x467/0x470
[  756.891786]  [<c0133893>] generic_file_aio_read+0x183/0x1c0
[  756.908514]  [<c0133640>] file_read_actor+0x0/0xd0
[  756.922903]  [<c026fb20>] scsi_next_command+0x30/0x50
[  756.938073]  [<c014e250>] do_sync_read+0xc0/0x100
[  756.952204]  [<c0124120>] autoremove_wake_function+0x0/0x50
[  756.968934]  [<c026bf00>] scsi_finish_command+0x40/0x60
[  756.984622]  [<c03319a5>] schedule+0x2e5/0x590
[  756.997972]  [<c014e316>] vfs_read+0x86/0x110
[  757.011065]  [<c014e5f7>] sys_read+0x47/0x80
[  757.023897]  [<c0102894>] syscall_call+0x7/0xb
[  757.037250]  =======================


I know this is late given a fix has been issued, but just got this in the logs with no other debug 
info at all. This kernel has *all* Jens debugging patches + the snippet from Neil above.

I'll apply the fix now and run it for a couple of days.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
