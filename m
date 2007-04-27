Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbXD0EG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbXD0EG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbXD0EG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:06:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54740 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbXD0EG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:06:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com>
	<20070426180358.GG2017@kernel.dk>
	<20070426180932.GA10642@infradead.org>
	<20070426181249.GH2017@kernel.dk>
	<Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com>
	<20070426182945.GJ2017@kernel.dk>
	<Pine.LNX.4.64.0704261134080.3656@schroedinger.engr.sgi.com>
	<20070426183935.GK2017@kernel.dk>
	<m1irbjj5ej.fsf@ebiederm.dsl.xmission.com>
	<20070426194234.GL2017@kernel.dk>
Date: Thu, 26 Apr 2007 22:05:43 -0600
In-Reply-To: <20070426194234.GL2017@kernel.dk> (Jens Axboe's message of "Thu,
	26 Apr 2007 21:42:36 +0200")
Message-ID: <m1ejm6jwbs.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Thu, Apr 26 2007, Eric W. Biederman wrote:
>
> Yep, if you could just have > PAGE_CACHE_SIZE blocks in the filesystem
> easily, the problem would basically be solved for cd and dvd packet
> writing.

Ok.  I'm not in a position to do this work.  But I will keep it in
mind and look at it.

>> Am I correct in assuming that the problem is primarily about getting
>> filesystems (and other upper layers) to submit BIOs that take into
>> consideration the larger block size of the underlying device, so
>> that read/modify write is not needed in the pktcdvd layer?
>
> Yes, that is exactly the problem. Once you have that, pktcdvd is pretty
> much reduced to setup and init code, the actual data handling can be
> done by sr or ide-cd directly. You could merge it into cdrom.c, it would
> not be very different from mt-rainier handling (which basically does RMW
> in firmware, so it works for any write, but performance is of course
> horrible if you don't do it right).

Thanks for the clarification.

So we do have a clear problem that we do not have generic support for
large sector sizes residing in the page cache.

There is one place where this is a direct effect fs/block_dev.c

We have an indirect affect in the filesystems because there a few
bits of generic support missing and there is no linux convention
on how to handle this case.

I expect if we can enhance fs/block_dev.c to handle this case the
other parts will fall out naturally.

Eric



