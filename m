Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZEKMM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZEKMM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZEKMMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:12:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:35851 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbZEKMMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:12:47 -0400
Date: Mon, 11 May 2009 14:12:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Max Kellermann <max@duempel.org>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] make splice more generic
Message-ID: <20090511121247.GZ4694@kernel.dk>
References: <20090507133734.450612199@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507133734.450612199@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07 2009, Miklos Szeredi wrote:
> This series makes splice(2) work in more cases:
> 
>   - pipe to pipe splicing (zero copy)
>   - fallback splice_read which uses readv()
>   - fallback splice_write which uses writev()
> 
> Just after cleaning up my patches after a vacation I found Max
> Kellermann's patch on LKML implementing the first part.  I'll still
> post mine, because it's slightly simpler (no ref + unref on the buffer
> if not necessary).

I have applied all three, thanks! However, I think we should be able to
pass in whether or not this is a strict splice or not. Falling back to
readv/writev is a good thing as it may help get the interface adopted
more widely, but I can also easily imagine cases where you'd want to
make sure that splice actually works without copies. It may even just be
for users to retry with alternative code paths, instead of proceeding
with the splice. SPLICE_F_MOVE is a soft flag in that it will move if it
can, but not fail if it can't. Perhaps we should add a flag that does
pass back an error if we can't just move pages around, SPLICE_F_STRICT
or something like that.

-- 
Jens Axboe

