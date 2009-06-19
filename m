Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZFSJCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZFSJCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZFSJCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:02:38 -0400
Received: from [212.98.175.89] ([212.98.175.89]:50219 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752807AbZFSJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:02:37 -0400
Date: Fri, 19 Jun 2009 12:04:05 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: blk-settings.c integer truncation
Message-ID: <20090619090405.GA3222@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

commit e475bba2fdee9c3dbfe25f026f8fb8de69508ad2
introduced 'void blk_set_default_limits(struct queue_limits *lim)'

blkdev.h
...
#endif
#define BLK_BOUNCE_ANY		(-1ULL)
#define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)


struct queue_limits {
	unsigned long		bounce_pfn;
	unsigned long		seg_boundary_mask;
....
};

Assignment at block/blk-settings.c:115 (4 bytes = 8 bytes):
lim->bounce_pfn = BLK_BOUNCE_ANY;

leads to truncation:
block/blk-settings.c: In function ‘blk_set_default_limits’:
block/blk-settings.c:115: warning: large integer implicitly truncated to unsigned type


Should BLK_BOUNCE_ANY be (-1UL)?


Thanks.

	Sergey

p.s.
In case it's already fixed - let me know.
