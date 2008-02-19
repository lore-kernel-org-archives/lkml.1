Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYBSJkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYBSJkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYBSJkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:40:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYBSJkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:40:02 -0500
Reply-To: <kmpark@infradead.org>
From: "Kyungmin Park" <kmpark@infradead.org>
To: "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>
Cc: "'Linux Filesystem Mailing List'" <linux-fsdevel@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
References: <9c9fda240802182148m6fd632pa7988530c5387245@mail.gmail.com> <20080219091608.1da174c1@crazy>
Subject: RE: Question about synchronous write on SSD
Date: Tue, 19 Feb 2008 18:39:43 +0900
Organization: infradead
Message-ID: <002f01c872db$69c854c0$1fa9580a@swcenter.sec.samsung.co.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-index: Achyz8w2U76OTu8STQyj8Ku0FcGtHgACfIhQ
In-reply-to: <20080219091608.1da174c1@crazy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Le Tue, 19 Feb 2008 14:48:18 +0900,
> "Kyungmin Park" <kmpark@infradead.org> a écrit :
> 
> > +               /* Write synchronous */
> > +               bio->bi_rw |= (1 << BIO_RW_SYNC);
> 
> Adding BIO_RW_SYNC doesn't make generic_make_request() synchronous as
> in "generic_make_request() returns only after write completion".
> BIO_RW_SYNC only asks the I/O layer to unplug immediatly. But
> generic_make_request() still returns before the completion of the I/O,
> and the completion is notified asynchronously.
> 

Agree, however see the following sequence.

__generic_make_request call q->make_request_fn(q, bio);
It was set by blk_init_queue_node with __make_request.
There are two ways in __make_request.
Case 1, get_rq
Case 2, out or merged (otherwise you mean unplug case)

In case 1, if the BIO_RW_SYNC is set, the request gets the REQ_RW_SYNC
And REQ_RW_SYNC says 
"include/linux/blkdev.h":112: __REQ_RW_SYNC,          /* request is sync (O_DIRECT) */
It means it acts as O_DIRECT flag. Is it right?
And it also is same as case 2. Unplug the device.
So next time it hasn't chance to merge???

Is it right?

BR,
Kyungmin Park

