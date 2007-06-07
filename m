Return-Path: <linux-kernel-owner+w=401wt.eu-S936096AbXFGBrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936096AbXFGBrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758710AbXFGBrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:47:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455AbXFGBrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:47:16 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 7 Jun 2007 11:46:47 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [PATCH 000 of 2] Fix some bugs with 'read' racing with 'truncate'
Message-ID: <20070607114043.26967.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches fix a couple of bugs which trigger when read
races with truncate.

As there is no locking between read and truncate, we need to be
careful about sequencing.   In some cases were aren't careful enough.

The first patch ensures that we check i_size *after* gaining a
reference to an uptodate page, thus ensuring that we don't unknowingly
returns NUL characters that are beyond the end of the file.

The second ensures that we don't deliver partial reads to more than
one sub-buffer in a readv call.

These bugs have been around for a while and are quite subtle, so I
don't think there is any rush for them to go into 2.6.22.  Rather they
should sit in -mm at least until .23 opens up.

Thanks,
NeilBrown



 [PATCH 001 of 2] Fix read/truncate race.
 [PATCH 002 of 2] Make sure readv stops reading when it hits end-of-file.
