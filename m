Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbXGRU2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbXGRU2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXGRU2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:28:06 -0400
Received: from brick.kernel.dk ([80.160.20.94]:11196 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbXGRU2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:28:05 -0400
Date: Wed, 18 Jul 2007 22:27:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Message-ID: <20070718202740.GN11657@kernel.dk>
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com> <alpine.LFD.0.999.0707181238500.27353@woody.linux-foundation.org> <20070718200835.GK11657@kernel.dk> <alpine.LFD.0.999.0707181313100.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707181313100.27353@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18 2007, Linus Torvalds wrote:
> 
> 
> On Wed, 18 Jul 2007, Jens Axboe wrote:
> > 
> > I think your analysis is pretty good, however you'd probably want to
> > incorporate that direct in ide_end_request().
> 
> Ok, that makes sense too.
> 
> And yes, the further cleanup would be:
> 
> > Better still would be to make __ide_end_request() take a byte count
> > instead and use end_that_request_chunk(). Then you can get rid of the
> > rounding as well.
> 
> and that sounds fine, but is an independent issue and not strictly 
> necessary.

Oh yeah, it's just a further improvement, not strictly necessary for
fixing this bug. So it could be done at a later time, all up to Bart...

-- 
Jens Axboe

