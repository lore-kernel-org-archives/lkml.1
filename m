Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXLJKlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXLJKlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbXLJKlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:41:10 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24073 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXLJKlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:41:09 -0500
Date: Mon, 10 Dec 2007 11:37:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What does "ordering by draining" mean?
Message-ID: <20071210103753.GB5008@kernel.dk>
References: <4104961b0712100149h69b1e1fas355b770f93affd03@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4104961b0712100149h69b1e1fas355b770f93affd03@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, jidong xiao wrote:
> Hi,
> 
> I am reading the source code of block I/O layer, and now seeing there
> saying "ordering by draining" or "ordering by tag" in
> include/blkdev.h,and the comments in that file says: "Hardbarrier is
> supported with one of the following methods", but what do these two
> methods exactly mean?

ordering by draining means that you empty the pending queue of requests
and then flush the cache to prevent a later issue of a new request to
reach the platter before the older ones. order by tag means that the hw
has a way of being told not to reorder beyond the barrier, in which case
you don't have to drain the queue.

-- 
Jens Axboe

