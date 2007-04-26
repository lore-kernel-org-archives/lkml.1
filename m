Return-Path: <linux-kernel-owner+w=401wt.eu-S1031141AbXDZOdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031141AbXDZOdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031184AbXDZOdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:33:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38648 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031141AbXDZOdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:33:31 -0400
Date: Fri, 27 Apr 2007 00:33:03 +1000
From: David Chinner <dgc@sgi.com>
To: Avi Kivity <avi@argo.co.il>
Cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426143303.GW65285596@melbourne.sgi.com>
References: <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au> <20070426092014.GT65285596@melbourne.sgi.com> <4630AEBC.4000002@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630AEBC.4000002@argo.co.il>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:53:00PM +0300, Avi Kivity wrote:
> David Chinner wrote:
> >The problem with this approach is that it turns around the whole
> >way we look at bufferheads. Right now we have well defined 1:n
> >mapping of page to bufferheads and so we tpyically lock the
> >page first them iterate all the bufferheads on the page.
> >
> >Going the other way, we need to support m:n which we means
> >the buffer has to become the primary interface for the filesystem
> >to the page cache. i.e. we need to lock the bufferhead first, then
> >iterate all the pages on it. This is messy because the cache indexes
> >via pages, not bufferheads. hence a buffer needs to point to all the
> >pages in it explicitly, and this leads to interesting issues with
> >locking.
> >  
> 
> Why is it necessary to assume that one filesystem block == one buffer?  
> Is it for atomicity, efficiency, or something else?

By definition, really - each filesystem block has it's own state and
it's own disk mapping and so we need something to carry that
information around....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
