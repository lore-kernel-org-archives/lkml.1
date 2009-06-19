Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZFSJSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZFSJSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZFSJSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:18:33 -0400
Received: from [212.98.175.89] ([212.98.175.89]:49218 "EHLO localdomain.by"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752709AbZFSJSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:18:33 -0400
Date: Fri, 19 Jun 2009 12:20:02 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: blk-settings.c integer truncation
Message-ID: <20090619092002.GB3222@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I was asking
> Should BLK_BOUNCE_ANY be (-1UL)?

No. It should not.

git annotate gives for blkdev.h:
Andi Kleen     2008-04-21 09:51:05 +0200       705)#define BLK_BOUNCE_ANY              (-1ULL)
...

...
(Martin K. Petersen     2009-05-22 17:17:51 -0400       311)    unsigned long           bounce_pfn;
...
(Martin K. Petersen     2009-05-22 17:17:50 -0400       1020)static inline unsigned long queue_bounce_pfn(struct request_queue *q)
(Martin K. Petersen     2009-05-22 17:17:50 -0400       1021){
(Martin K. Petersen     2009-05-22 17:17:51 -0400       1022)   return q->limits.bounce_pfn;
(Martin K. Petersen     2009-05-22 17:17:50 -0400       1023)}
...

I think, commit need to be reworked a bit.

	Sergey
