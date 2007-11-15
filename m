Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbXKOLgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbXKOLgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXKOLgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:36:46 -0500
Received: from brick.kernel.dk ([87.55.233.238]:19042 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbXKOLgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:36:45 -0500
Date: Thu, 15 Nov 2007 12:35:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Attempt to get eject failures back to ioctl(CDROMEJECT)
Message-ID: <20071115113521.GB5035@kernel.dk>
References: <200711141739.46960.rusty@rustcorp.com.au> <200711151335.53053.rusty@rustcorp.com.au> <20071115084705.GE638@kernel.dk> <200711152232.02522.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711152232.02522.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15 2007, Rusty Russell wrote:
> On Thursday 15 November 2007 19:47:05 Jens Axboe wrote:
> > On Thu, Nov 15 2007, Rusty Russell wrote:
> > > If blk_rq_map_sg returns more than was allocated, it's a bug, and
> > > something's already been overwritten.  BUG_ON() is probably the right
> > > thing here.
> >
> > It really just means that it mapped more segments than the block layer
> > said it would. Usually that wont overwrite memory here since scsi rounds
> > up on allocating the sg list, but it indeed can. Similar code has been
> > in scsi_lib.c for ages, I'd suggest covering that in the same patch.
> 
> Good point.  I assume that you've not seen these printks in recent memory?

I have not, they usually show up if we have bugs in the merge accounting
logic in the block layer (the merge functions and blk_rq_map_sg() not
agreeing). It's been ages since that was an issue, so I'm fine with the
bug.

> This covers both cases:
> 
> Subject: [PATCH] scsi: BUG_ON() impossible condition.

You can add my

Acked-by: Jens Axboe <jens.axboe@oracle.com>

when you pass it through James, it should go in that way.

-- 
Jens Axboe

