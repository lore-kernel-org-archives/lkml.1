Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbXHPFNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbXHPFNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbXHPFNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:13:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:51246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbXHPFNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:13:32 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 15:13:25 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 000 of 5] Introductory patches for bio refactor.
Message-ID: <20070816150445.30843.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jens,
 I wonder if you would accept these patches the block layer.
 They are, as far as I can tell, quite uncontroversial and provide
 good cleanups.

 The first is a minor bug-fix.
 The next to replace helper function that take a bio (always the first
 bio of a request), to instead take a request.

 The last two combine to replace rq_for_each_bio with
 rq_for_each_segment which makes blk_recalc_rq_segments a lot
 cleaner, and improves (to a lesser degree) every other place that
 used rq_for_each_bio.

 The net result is a decrease in object code size (for my x86-64 compile)
 for block/built-in.o of 96 bytes, though there is some growth out in
 drivers making and over-all decrease of only 48 bytes.

Thanks,
NeilBrown



 [PATCH 001 of 5] Don't update bi_hw_*_size if we aren't going to merge.
 [PATCH 002 of 5] Replace bio_data with blk_rq_data
 [PATCH 003 of 5] Replace bio_cur_sectors with blk_rq_cur_sectors.
 [PATCH 004 of 5] Introduce rq_for_each_segment replacing rq_for_each_bio
 [PATCH 005 of 5] Merge blk_recount_segments into blk_recalc_rq_segments
