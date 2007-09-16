Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXIPWfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXIPWfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXIPWfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:35:11 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:48886 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbXIPWfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:35:07 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Joern Engel <joern@logfs.org>
Cc: Andrea Arcangeli <andrea@suse.de>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
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
In-Reply-To: <20070916174657.GA2393@lazybastard.org> (Joern Engel's message of
	"Sun, 16 Sep 2007 19:46:58 +0200")
References: <20070911060349.993975297@sgi.com>
	<200709110452.20363.nickpiggin@yahoo.com.au>
	<20070911121225.GE13132@lazybastard.org>
	<20070915014449.4f9cdb51.akpm@linux-foundation.org>
	<87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
	<20070915155100.GA21861@v2.random>
	<87tzpvy9cb.fsf@informatik.uni-tuebingen.de>
	<20070915223032.GA6708@v2.random>
	<20070916174657.GA2393@lazybastard.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
Date: Mon, 17 Sep 2007 00:06:24 +0200
Message-ID: <87d4wi5kpr.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel <joern@logfs.org> writes:

> On Sun, 16 September 2007 00:30:32 +0200, Andrea Arcangeli wrote:
>> 
>> Movable? I rather assume all slab allocations aren't movable. Then
>> slab defrag can try to tackle on users like dcache and inodes. Keep in
>> mind that with the exception of updatedb, those inodes/dentries will
>> be pinned and you won't move them, which is why I prefer to consider
>> them not movable too... since there's no guarantee they are.
>
> I have been toying with the idea of having seperate caches for pinned
> and movable dentries.  Downside of such a patch would be the number of
> memcpy() operations when moving dentries from one cache to the other.
> Upside is that a fair amount of slab cache can be made movable.
> memcpy() is still faster than reading an object from disk.

How probable is it that the dentry is needed again? If you copy it and
it is not needed then you wasted time. If you throw it out and it is
needed then you wasted time too. Depending on the probability one of
the two is cheaper overall. Idealy I would throw away dentries that
haven't been accessed recently and copy recently used ones.

How much of a systems ram is spend on dentires? How much on task
structures? Does anyone have some stats on that? If it is <10% of the
total ram combined then I don't see much point in moving them. Just
keep them out of the way of users memory so the buddy system can work
effectively.

> Most likely the current reaction to such a patch would be to shoot it
> down due to overhead, so I didn't pursue it.  All I have is an old patch
> to seperate never-cached from possibly-cached dentries.  It will
> increase the odds of freeing a slab, but provide no guarantee.
>
> But the point here is: dentries/inodes can be made movable if there are
> clear advantages to it.  Maybe they should?
>
> Jörn

MfG
        Goswin
