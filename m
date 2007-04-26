Return-Path: <linux-kernel-owner+w=401wt.eu-S1031257AbXDZPSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031257AbXDZPSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031259AbXDZPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:18:48 -0400
Received: from holomorphy.com ([66.93.40.71]:60839 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031257AbXDZPSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:18:47 -0400
Date: Thu, 26 Apr 2007 08:19:03 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andy Whitcroft <apw@shadowen.org>, Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426151903.GI19966@holomorphy.com>
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <46309D16.70109@shadowen.org> <4630C061.10309@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630C061.10309@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
>> To my knowledge, moving to a higher base page size has its advantages in
>> TLB reach, but brings with it some pretty serious downsides.  Especially
>> in caching small files.  Internal fragmentation in the page cache
>> significantly affecting system performance.  So much so that development
>> is ongoing to see if supporting sub-base-page objects in the buffer
>> cache could be beneficial.

On Fri, Apr 27, 2007 at 01:08:17AM +1000, Nick Piggin wrote:
> I think 16K would be pretty reasonable (ia64 tends to use it). I guess
> powerpc went to 64k either because that's what databases want or because
> their TLB refills are too slow, so the internal fragmentation bites
> them a lot harder.
> But that was more of a side comment, because I still think io controllers
> should be easily capable of operation on 4K pages. Graphics cards are,
> aren't they?

Base page size need only be a power-of-two multiple of the MMU pagesize.
ISTR the 64KB PAGE_SIZE in ppc64 being motivated by TLB considerations.

There is not going to be a way to improve how well IO controllers deal
with 4K pages. The scatter/gather lists for smaller fragments will
require more device communication overhead no matter what, and
furthermore, the more discontiguity, the more seekiness.


-- wli
