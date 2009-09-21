Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZIUTng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZIUTng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZIUTnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:43:35 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:35889 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbZIUTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:43:34 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/3] block: Add blk_queue_copy_limits()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4AB3B43D.9000802@ce.jp.nec.com>
	<yq1eiq46ohz.fsf@sermon.lab.mkp.net> <4AB4F74E.7000908@ce.jp.nec.com>
	<yq1k4zt5o2f.fsf@sermon.lab.mkp.net> <4AB7AAE2.8000404@ce.jp.nec.com>
Date: Mon, 21 Sep 2009 15:43:19 -0400
In-Reply-To: <4AB7AAE2.8000404@ce.jp.nec.com> (Jun'ichi Nomura's message of
	"Tue, 22 Sep 2009 01:33:38 +0900")
Message-ID: <yq1iqfc3wyw.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AB7D75A.00F3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:

Jun'ichi> If we aren't sure, shouldn't we set its default to -1 or
Jun'ichi> putting comments in blk_set_default_limits() at least to avoid
Jun'ichi> possible confusion in future?

Jens, what do you think about this?  Goes on top of what you have
queued...


block: Do not clamp max_hw_sectors for stacking devices

Stacking devices do not have an inherent max_hw_sector limit.  Set the
default to INT_MAX so we are bounded only by capabilities of the
underlying storage.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/block/blk-settings.c b/block/blk-settings.c
index cd9b730..eaf122f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -111,7 +111,8 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_hw_segments = MAX_HW_SEGMENTS;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = MAX_SEGMENT_SIZE;
-	lim->max_sectors = lim->max_hw_sectors = BLK_DEF_MAX_SECTORS;
+	lim->max_sectors = BLK_DEF_MAX_SECTORS;
+	lim->max_hw_sectors = INT_MAX;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
