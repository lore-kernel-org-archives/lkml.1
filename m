Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbXKNDeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbXKNDeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbXKNDeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:34:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:21844 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbXKNDeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:34:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=muBVlwh+ul2fsXg893VyIkvKQa3LaddC18TnEMnMeaugRgqlU9uXLVlXatG3g7qXNdxamar5Vrjscal0Q2+rMsdi6F/Bn5ovTrYFAbLxkdTTAXXJt62K3cfbTVGWsoIRTvqX9sOXUEfEICjyUcZfYUxnvJB35wUHnqZ6E6tRakc=
Message-ID: <3182720c0711131934t328440aey6e42a400a1c73a51@mail.gmail.com>
Date: Wed, 14 Nov 2007 11:34:10 +0800
From: "Wang Yu" <wangyuict@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: about ext3_readpage
In-Reply-To: <3182720c0711131917i1596e883qb27041d830ba39b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3182720c0711131917i1596e883qb27041d830ba39b3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
when I read ext3_readpage function following
ext3_readpage->mpage_readpage->do_mpage_readpage, there are:

nblocks = map_bh->b_size >> blkbits;
        if (buffer_mapped(map_bh) && block_in_file > *first_logical_block &&
                        block_in_file < (*first_logical_block + nblocks)) {
                unsigned map_offset = block_in_file - *first_logical_block;
                unsigned last = nblocks - map_offset;

                for (relative_block = 0; ; relative_block++) {
                        if (relative_block == last) {
                                clear_buffer_mapped(map_bh);
                                break;
                        }
                        if (page_block == blocks_per_page)
                                break;
                        blocks[page_block] = map_bh->b_blocknr + map_offset +
                                                relative_block;
                        page_block++;
                        block_in_file++;
                }
                bdev = map_bh->b_bdev;
        }

Since map_bh->b_size is the size of the block buffer, and blkbits is
associated with the block in inode, why does he do the operation >> ?
And what is the meaning and usage of  first_logical_block? the initial
value of it is 0.

Hope someone will help me!
Thanks!

-- 
National Research Center for Intelligent Computing Systems
Institute of Computing Technology, Chinese Academy of Sciences
