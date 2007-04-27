Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXD0OtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXD0OtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbXD0OtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:49:25 -0400
Received: from holomorphy.com ([66.93.40.71]:51837 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbXD0OtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:49:24 -0400
Date: Fri, 27 Apr 2007 07:49:42 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427144942.GQ19966@holomorphy.com>
References: <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <20070426145310.GH19966@holomorphy.com> <m1ejm7kndn.fsf@ebiederm.dsl.xmission.com> <20070427003216.GM19966@holomorphy.com> <4631CECF.4030301@yahoo.com.au> <20070427125843.GO19966@holomorphy.com> <4631F55C.2040800@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4631F55C.2040800@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 08:22:07PM +1000, Nick Piggin wrote:
>>> Just a random aside question... doesn't Oracle db do direct IO from
>>> hugepages?

William Lee Irwin III wrote:
>> If and when configured to use direct IO and hugepages, yes.

On Fri, Apr 27, 2007 at 11:06:36PM +1000, Nick Piggin wrote:
> Sweet. I wonder if you would see a much improvement for allowing more
> than 128 sglist entries, then.

There should be some. Oracle does its own IO scheduling, so it's able
to submit relatively large IO's (IIRC also configurable). I'm not sure
what's done for the non-aio case, but aio might be tricky to catch the
vectoring with all the blocking on get_request_wait() and the way the
vector elements are handled there. So turning off aio may also help.

Another useful idea is to look at the results from pagemap patches.


William Lee Irwin III wrote:
> >It's also
> >noteworthy thar Oracle has more code than its database.
> 
On Fri, Apr 27, 2007 at 11:06:36PM +1000, Nick Piggin wrote:
> Anything noteworthy in this context, that you care to note?

The RMAN backup utility is often used to back up Oracle databases
and there are always complaints when backups disturb anything.

EM (enterprise management stuff), RAC (clustering affairs), various
database applications (typically in-depth for whatever field they're
pertinent to), ASM middleware (abstraction layer for database file
access), and more are out there.


-- wli
