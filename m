Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXKOIrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXKOIrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbXKOIrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:47:10 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21956 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbXKOIrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:47:09 -0500
Date: Thu, 15 Nov 2007 09:47:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Attempt to get eject failures back to ioctl(CDROMEJECT)
Message-ID: <20071115084705.GE638@kernel.dk>
References: <200711141739.46960.rusty@rustcorp.com.au> <20071114123931.GF5064@kernel.dk> <200711151335.53053.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711151335.53053.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15 2007, Rusty Russell wrote:
> On Wednesday 14 November 2007 23:39:31 Jens Axboe wrote:
> > On Wed, Nov 14 2007, Rusty Russell wrote:
> > > Hi Jens,
> > >
> > >     As you asked for some time ago.  Of course, it turns out that the
> > > eject command ignores the error anyway, but it's nice that it now errors.
> > >
> > >     Not entirely comfortable with this patch: there's a req->errors but
> > > that seems to have some existing semantics I'm not sure of, so I simply
> > > added a new way of flagging an error.
> >
> > It is a bit of a hack, but it's not really your fault. ->errors is
> > somewhat messy and has different meaning depending on the request type.
> > I'll add your patch and then do a sanitize on top of it, so that we can
> > switch things over to a unified ->errno instead.
> 
> Thanks!
> 
> Oh, I also noticed this in scsi_tgt_lib:
> 
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Fri, 9 Nov 2007 20:04:54 +1100
> Subject: [PATCH] scsi_tgt_lib: BUG_ON() impossible condition.
> 
> If blk_rq_map_sg returns more than was allocated, it's a bug, and something's
> already been overwritten.  BUG_ON() is probably the right thing here.

It really just means that it mapped more segments than the block layer
said it would. Usually that wont overwrite memory here since scsi rounds
up on allocating the sg list, but it indeed can. Similar code has been
in scsi_lib.c for ages, I'd suggest covering that in the same patch.

-- 
Jens Axboe

