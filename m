Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZEKRsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZEKRsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZEKRsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:48:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZEKRsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:48:09 -0400
Message-ID: <4A086467.1080205@redhat.com>
Date: Mon, 11 May 2009 12:46:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
References: <20090508191649.GG9068@unused.rdu.redhat.com> <20090508161318.c73d766c.akpm@linux-foundation.org> <20090511094639.GA7488@infradead.org> <20090511171046.GA21518@mit.edu>
In-Reply-To: <20090511171046.GA21518@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, May 11, 2009 at 05:46:39AM -0400, Christoph Hellwig wrote:
>> Last time I brought the idea of a small in-tree test harness up at KS
>> people weren't too fond of it, but if we get more backing now we could
>> try it, otherwise we can just stick it into xfsqa which will hopefully
>> soon be generalized to a general fs QA suite.
> 
> Two questions --- first of all, has there been any progress with
> respect to fixing the licensing of the xfsqa tree.  (i.e., "All Rights
> Reserved" needs to change to a GPLv2 license)?  

We've had a verbal ack from sgi that it should be under an open-source
license.  But until that is committed to the repo....

> And would you be open to cleaning up xfsqa by for example, moving some
> of the tests out of the top-level directory, adding a modified xfs_io
> to xfsqa (modified to not avoid using XFS-specific ioctl whereever
> possible), etc.

Sure.  xfs_io already can act on non-xfs filesystems, although right now
it takes a flag to do so.  But it can do many ops* that way, and we're
open to add more (I just sent a patch to add fallocate yesterday).

As for directory layout, whatever works is likely fine.

> I've been collecting my own set of test programs for ext4, and I've
> thought about trying to use xfsqa, but it's not obvious to me it would
> be more or less work, since in many ways there are a lot of places
> where a lot of cleanup work and filesystem portability work would be
> needed, and it's not clear that creating a new test framework and
> collection of tests would be more or less work.

Yes, xfsqa would/will take some work to get there I guess.  OTOH so much
of filesystem testing could be shared, it's a shame to duplicate it for
each filesytem, too.

> (For example, of cleanup that I'd love to see, I'd really like to use
> real names for tests and not just random three digit numbers like 107,
> 108, 109, all cluterring the top-level directory along with 107.out,
> 108.out, 109.out, etc.)

Well they're not random, they are sequential ;)

But yeah at least giving each test a description (at least a
DESCRIPTION="tests fubarbaz") would be helpful.

> Of course, until the copyright/licensing situation is cleared up, all
> of these other issues are rather moot....

I'll press SGI on this...

-Eric

> 					- Ted

*fadvise, file, print, freeze, thaw, fsync, fdatasync, getrusage,
madvise, mincore, mmap, mread, msync, munmap, mwrite, open, stat, close,
setfl, statfs, pread, pwrite, sendfile, truncate
