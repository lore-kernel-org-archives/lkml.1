Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbXI0HUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbXI0HUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbXI0HUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:20:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbXI0HUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:20:08 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 27 Sep 2007 17:20:01 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 4] Change prototype for bi_end_io
Message-ID: <20070927171111.3251.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,
 here are a few more patches from my set that makes various changes to bio
 submission and handling.

 These change the ->bi_end_io prototype so that
   1/ no 'size' is passed
   2/ there is no return value.

 The 'size' is not really of interest to any bi_end_io handler in existance. 
 It is really only an internal detail to the "request" handling in ll_rw_blk
 and lower levels.
 The return value is completely unused.

 After these patches, ->bi_end_io is only ever called once per bio.

 Note that the last patch makes lots and lots of simple changes.  I
 think I have found all the right places, but any recently added
 device drivers might still be using the old bi_end_io prototype.
 I'll grep again after these patches are in your tree.

 That patches are against linux-block as of an hour ago.

Thanks,
NeilBrown

Net result of the 4 patches:

 46 files changed, 166 insertions(+), 385 deletions(-)


 [PATCH 001 of 4] Remove flush_dry_bio_endio
 [PATCH 002 of 4] Only call bi_end_io once for any bio.
 [PATCH 003 of 4] Don't decrement bi_size in bio_endio.
 [PATCH 004 of 4] Drop 'size' argument from bio_endio and bi_end_io.
