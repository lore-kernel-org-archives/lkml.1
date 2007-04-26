Return-Path: <linux-kernel-owner+w=401wt.eu-S1031372AbXDZRqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031372AbXDZRqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031380AbXDZRqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:46:37 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5412 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031378AbXDZRqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:46:36 -0400
Date: Thu, 26 Apr 2007 19:42:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426174254.GD2017@kernel.dk>
References: <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au> <20070426092014.GT65285596@melbourne.sgi.com> <4630C326.2030906@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630C326.2030906@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27 2007, Nick Piggin wrote:
> Why do we limit drivers to 128 sg entries?

No particular reason, except than to avoid 2^bigger order allocations.
2MiB requests would require 3 contig pages to setup the sg list, which
is (probably) a little troublesome especially since it's sometimes
atomically allocated.

Larger pages are by no means a prerequisite to getting larger requests,
assuming your hardware can handle the bigger sglist. There are other
ways of doing that, I've contemplated doing chained sglists and adding
sg_for_each_segment() macros for iterating these things. Drivers that
want larger sglists would then be required to update their sg mapping
loop to use the provided macros. It wouldn't be too hard.

-- 
Jens Axboe

