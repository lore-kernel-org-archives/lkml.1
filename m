Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXHPLVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXHPLVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbXHPLUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:20:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbXHPLUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:20:54 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 21:20:47 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 000 of 6] A few block-layer tidy-up patches.
Message-ID: <20070816211551.11839.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 5 patches which - I think - clean up various bits and pieces
in the block layer.

The only part that might be seen as a function change rather than
simply rearranging code is in ps3disk where bvec_kmap_irq is used
instead of bio_kmap_atomic (so interrupts are disabled).

The only other user of bvec_kmap_irq is ide-floppy.c.  If that does
need to disable interrupts, and ps3disk doesn't, make the disabling of
interrupts should be separated from the kmapping??

Thanks,
NeilBrown


 [PATCH 001 of 6] Merge blk_recount_segments into blk_recalc_rq_segments
 [PATCH 002 of 6] Introduce rq_for_each_segment replacing rq_for_each_bio
 [PATCH 003 of 6] Fix various abuse of bio fields in umem.c
 [PATCH 004 of 6] New function blk_req_append_bio
 [PATCH 005 of 6] Stop exporting blk_rq_bio_prep
 [PATCH 006 of 6] Share code between init_request_from_bio and blk_rq_bio_prep
