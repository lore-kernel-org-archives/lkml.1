Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbXDZXe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbXDZXe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXDZXe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:34:27 -0400
Received: from holomorphy.com ([66.93.40.71]:33198 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbXDZXeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:34:25 -0400
Date: Thu, 26 Apr 2007 16:34:44 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426233444.GK19966@holomorphy.com>
References: <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <20070426135038.GE19966@holomorphy.com> <m1irbjknxn.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1irbjknxn.fsf@ebiederm.dsl.xmission.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> It's possible to divorce PAGE_SIZE from the binary formats, though I
>> found it difficult to keep up with the update treadmill. 

On Thu, Apr 26, 2007 at 12:09:24PM -0600, Eric W. Biederman wrote:
> On x86_64 the sizes is actually 64K for executable binaries if I
> recall correctly.  It certainly is not PAGE_SIZE, so we have some
> flexibility there.

Not so fast. The x86-64 ABI may allow any power of two size between
4KB and 64KB, but the emulated i386 ABI does not.


William Lee Irwin III <wli@holomorphy.com> writes:
>> Maybe it's
>> like hch says and I just needed to find more and better API cleanups.
>> I've only not tried to resurrect it because it's too much for me to do
>> on my own. I essentially collapsed under the weight of it and my 2.5.x
>> codebase ended up worse than Katrina as a disaster, which I don't want
>> to repeat and think collaborators or a different project lead from
>> myself are needed to avoid that happening again.

On Thu, Apr 26, 2007 at 12:09:24PM -0600, Eric W. Biederman wrote:
> But we still have some issues with mmap. But since we could increase
> PAGE_SIZE on x86_64 and not have to even worry about sub PAGE_SIZE
> mmaps.  It is being suggested that if people really need larger
> physical pages that they just fix PAGE_SIZE.  The everything just
> works.

There's a little more to it than that, plus i386 ABI emulation.


On Thu, Apr 26, 2007 at 12:09:24PM -0600, Eric W. Biederman wrote:
> Thinking about it changing PAGE_SIZE on x86_64 should be about as
> hard as doing the 3-level vs 2-level page table format.  We say
> we have a different page table format that uses a larger PAGE_SIZE.
> All arch code, all code in paths that we expect to change.

It does not resemble 3-level vs. 2-level pagetable format code. It
can be done entirely in arch code if you don't care to emulate the
i386 ABI.


On Thu, Apr 26, 2007 at 12:09:24PM -0600, Eric W. Biederman wrote:
> Boom all done.
> It might be worth implementing just so people can play with different
> PAGE_SIZE values for benchmarking.
> I don't think the larger physical page size is really the issue here
> though.

I'll clean up what I have and post it at some point.


William Lee Irwin III <wli@holomorphy.com> writes:
>> Anyway, if that's being kicked around as an alternative, it could be
>> said that I have some insight into the issues surrounding it.

On Thu, Apr 26, 2007 at 12:09:24PM -0600, Eric W. Biederman wrote:
> Partially but also partially they are very much suggesting going down
> the same path.  Currently mmap doesn't work with order >0 pages because
> they are not yet addressing these issues at all.
> This looks like a more flexible version of the old PAGE_CACHE_SIZE >
> PAGE_SIZE code.  Which makes seriously question the whole idea.

mmap() should be emulatable with the base page size without anything
interesting happening. Of course, there are opportunities for more, if
anyone cares to take them.


-- wli
