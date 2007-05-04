Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXEDNfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXEDNfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXEDNfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:35:51 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33886 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbXEDNfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:35:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<20070427060921.GA77450368@melbourne.sgi.com>
	<20070427000403.6013d1fa.akpm@linux-foundation.org>
	<20070427080321.GG32602149@melbourne.sgi.com>
	<20070427014849.41f383f7.akpm@linux-foundation.org>
	<20070427164535.GH24852@thunk.org>
Date: Fri, 04 May 2007 07:33:54 -0600
In-Reply-To: <20070427164535.GH24852@thunk.org> (Theodore Tso's message of
	"Fri, 27 Apr 2007 12:45:35 -0400")
Message-ID: <m1abwku30d.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> On Fri, Apr 27, 2007 at 01:48:49AM -0700, Andrew Morton wrote:
>> And other filesystems (ie: ext4) _might_ use it.  But ext4 is extent-based,
>> so perhaps it's not work churning the on-disk format to get a bit of a
>> boost in the block allocator.
>
> Well, ext3 could definitely use it; there are people using 8k and 16k
> blocksizes on ia64 systems today.  Those filesystems can't be mounted
> on x86 or x86_64 systems because our pagesize is 4k, though.
>
> And I imagine that ext4 might want to use a large blocksize too ---
> after all, XFS is extent based as well, and not _all_ of the
> advantages of using a larger blocksize are related to brain-damaged
> storage subsystems with short SG list support.  Whether the advantages
> offset the internal fragmentation overhead or the complexity of adding
> fragments support is a different question, of course.
>
> So while the jury is out about how many other filesystems might use
> it, I suspect it's more than you might think.  At the very least,
> there may be some IA64 users who might be trying to transition their
> way to x86_64, and have existing filesystems using a 8k or 16k
> block filesystems.  :-)

How much of a problem would it be if those blocks were not necessarily
contiguous in RAM, but placed in normal 4K pages in the page cache?

I expect meta data operations would have to be modified but that otherwise
you would not care.

Eric
