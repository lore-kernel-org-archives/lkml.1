Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbYHNOGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbYHNOGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbYHNOGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:06:16 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26074 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292AbYHNOGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:06:15 -0400
Date: Thu, 14 Aug 2008 16:06:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Alex Dubov <oakad@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: can block drivers get non-fs requests?
Message-ID: <20080814140612.GC20055@kernel.dk>
References: <20080814133810.746751cf@mjolnir.drzeus.cx> <20080814114209.GB20055@kernel.dk> <20080814143935.7033631e@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814143935.7033631e@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14 2008, Pierre Ossman wrote:
> On Thu, 14 Aug 2008 13:42:09 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > 
> > You should check in the driver whether the request type is supported. So
> > if you can only handle fs requests, you should do a check for
> > !blk_fs_request() after elv_next_request() and call
> > end_(de)queued_request() appropriately.
> > 
> 
> So killing off the request with -EOPNOTSUPP is preferred over having a
> prepare function and stopping it there?

Nope, that doesn't matter. If you already have a prep function, using
BLKPREP_KILL is the easiest solution.

-- 
Jens Axboe

