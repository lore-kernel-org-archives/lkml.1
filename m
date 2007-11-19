Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbXKSPPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbXKSPPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXKSPOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:14:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41238 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbXKSPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:14:54 -0500
Date: Mon, 19 Nov 2007 16:14:52 +0100
From: Jan Kara <jack@suse.cz>
To: Wang Yu <wangyuict@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about ext3_readpage
Message-ID: <20071119151452.GD14481@atrey.karlin.mff.cuni.cz>
References: <3182720c0711131917i1596e883qb27041d830ba39b3@mail.gmail.com> <3182720c0711131934t328440aey6e42a400a1c73a51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3182720c0711131934t328440aey6e42a400a1c73a51@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> when I read ext3_readpage function following
> ext3_readpage->mpage_readpage->do_mpage_readpage, there are:
> 
> nblocks = map_bh->b_size >> blkbits;
>         if (buffer_mapped(map_bh) && block_in_file > *first_logical_block &&
>                         block_in_file < (*first_logical_block + nblocks)) {
>                 unsigned map_offset = block_in_file - *first_logical_block;
>                 unsigned last = nblocks - map_offset;
> 
>                 for (relative_block = 0; ; relative_block++) {
>                         if (relative_block == last) {
>                                 clear_buffer_mapped(map_bh);
>                                 break;
>                         }
>                         if (page_block == blocks_per_page)
>                                 break;
>                         blocks[page_block] = map_bh->b_blocknr + map_offset +
>                                                 relative_block;
>                         page_block++;
>                         block_in_file++;
>                 }
>                 bdev = map_bh->b_bdev;
>         }
> 
> Since map_bh->b_size is the size of the block buffer, and blkbits is
> associated with the block in inode, why does he do the operation >> ?
> And what is the meaning and usage of  first_logical_block? the initial
> value of it is 0.
  Hmm, the code is quite "inventive" in the way it uses struct
buffer_head - does anybody know if we have this documented anywhere BTW?
  In b_size it keeps the size of area it would like to map, filesystem
on the other hand returns in it how much it managed to map from the
required area. This number is in bytes, thus it has to be divided by the
size of the block ( >>blkbits is just a more effective way to code
division). Variable first_logical_block keeps offset (in blocks) at
which the last call to get_block() happened.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
