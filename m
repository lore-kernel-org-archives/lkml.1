Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZEOHcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZEOHcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 03:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbZEOHcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 03:32:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41774 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZEOHcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 03:32:06 -0400
Date: Fri, 15 May 2009 09:32:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Max Kellermann <max@duempel.org>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: [patch 0/3] make splice more generic
Message-ID: <20090515073206.GW4140@kernel.dk>
References: <20090507133734.450612199@szeredi.hu> <20090511121247.GZ4694@kernel.dk> <20090514202706.GB20363@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090514202706.GB20363@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14 2009, Jamie Lokier wrote:
> Jens Axboe wrote:
> > SPLICE_F_MOVE is a soft flag in that it will move if it
> > can, but not fail if it can't.
> 
> According to local man page, it's not even that.
> 
>   SPLICE_F_MOVE      [...] The initial implementation of this flag  was  buggy:
> 		     therefore  starting  in  Linux  2.6.21 it is a *no-op*
> 		     (but is still permitted in a splice() call); in  the
> 		     future, a correct implementation may be restored.

That's a temporary condition, and the statement isn't completely true
either.  What happened was that the stealing of fs pages was disabled.
Other users of splice could still implement it and take advantage of it.

Nick pulled the original code and did promise to work on a replacement,
but so far that hasn't happened.

> > Perhaps we should add a flag that does pass back an error if we
> > can't just move pages around, SPLICE_F_STRICT or something like
> > that.
> 
> What should it do in cases where the kernel would choose to copy data,
> i.e. data that isn't a whole page?

Probably -EINVAL, like O_DIRECT would.

-- 
Jens Axboe

