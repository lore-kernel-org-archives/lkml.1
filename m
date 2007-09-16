Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbXIPRv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbXIPRv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXIPRvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:51:18 -0400
Received: from lazybastard.de ([212.112.238.170]:37280 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbXIPRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:51:17 -0400
Date: Sun, 16 Sep 2007 19:46:58 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916174657.GA2393@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070915223032.GA6708@v2.random>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 September 2007 00:30:32 +0200, Andrea Arcangeli wrote:
> 
> Movable? I rather assume all slab allocations aren't movable. Then
> slab defrag can try to tackle on users like dcache and inodes. Keep in
> mind that with the exception of updatedb, those inodes/dentries will
> be pinned and you won't move them, which is why I prefer to consider
> them not movable too... since there's no guarantee they are.

I have been toying with the idea of having seperate caches for pinned
and movable dentries.  Downside of such a patch would be the number of
memcpy() operations when moving dentries from one cache to the other.
Upside is that a fair amount of slab cache can be made movable.
memcpy() is still faster than reading an object from disk.

Most likely the current reaction to such a patch would be to shoot it
down due to overhead, so I didn't pursue it.  All I have is an old patch
to seperate never-cached from possibly-cached dentries.  It will
increase the odds of freeing a slab, but provide no guarantee.

But the point here is: dentries/inodes can be made movable if there are
clear advantages to it.  Maybe they should?

Jörn

-- 
Joern's library part 2:
http://www.art.net/~hopkins/Don/unix-haters/tirix/embarrassing-memo.html
