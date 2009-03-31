Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZCaQYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZCaQYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbZCaQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:23:50 -0400
Received: from sandeen.net ([209.173.210.139]:15299 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760480AbZCaQXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:23:50 -0400
X-Greylist: delayed 2039 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 12:23:50 EDT
Message-ID: <49D23B9C.2000000@sandeen.net>
Date: Tue, 31 Mar 2009 10:49:48 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <49D13123.7040007@rtr.ca>
In-Reply-To: <49D13123.7040007@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jens Axboe wrote:
>> On Mon, Mar 30 2009, Linus Torvalds wrote:
>>> On Mon, 30 Mar 2009, Jens Axboe wrote:
>>>> Sorry, I just don't see much point to doing it this way instead. So now
>>>> the fs will have to check a queue bit after it has issued the flush, how
>>>> is that any better than having the 'error' returned directly?
>>> No.
>>>
>>> Now the fs SHOULD NEVER CHECK AT ALL.
>>>
>>> Either it did the ordering, or the FS cannot do anything about it. 
>>>
>>> That's the point. EOPNOTSUPP is n ot a useful error message. You can't 
>>> _do_ anything about it.
>> My point is that some file systems may or may not have different paths
>> or optimizations depending on whether barriers are enabled and working
>> or not. Apparently that's just reiserfs and Chris says we can remove it,
>> so it is probably a moot point.
> ..
> 
> XFS appears to have something along those lines.
> I believe it tries to disable the drive write caches
> if it discovers that it cannot do cache flushes.

No, it just stops issuing barriers if the initial mount-time test finds
that they're not supported.  ext3/4/reiserfs do similar.

> I'll check next time my MythTV box boots up.
> It has a RAID0 under XFS, and the md raid0 code doesn't
> appear to pass the cache flushes to libata for raid0,
> so XFS complains and tries to turn off the write caches.

doesn't touch write caches; just complains and stops issuing barriers.

> And I have a script to damn well turn them back ON again
> after it does so.  Stupid thing tries to override user policy again.

It does not do this.

-Eric
