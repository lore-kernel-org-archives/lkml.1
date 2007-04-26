Return-Path: <linux-kernel-owner+w=401wt.eu-S933102AbXDZGqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbXDZGqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbXDZGqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:46:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40679 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933094AbXDZGqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:46:07 -0400
Date: Wed, 25 Apr 2007 23:46:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <463048FE.5000600@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com>
 <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> Yeah. IMO anti-fragmentation and defragmentation is the hack, and we
> should stay away from higher order allocations whenever possible.

Right and we need to create series of other approaches that we then label 
"non-hack" to replace it. 

> Hardware is built to handle many small pages efficintly, and I don't
> understand how it could be an SGI-only issue. Sure, you may have an
> order of magnitude or more memory than anyone else, but even my lowly
> desktop _already_ has orders of magnitude more pages than it has TLB
> entries or cache -- if a workload is cache-nice for me, it probably
> will be on a 1TB machine as well, and if it is bad for the 1TB machine,
> it is also bad on mine.

There have been numbers of people that have argued the same point. Just 
because we have developed a way of thinking to defend our traditional 4k 
values does not make them right.

> If this is instead an issue of io path or reclaim efficiency, then it
> would be really nice to see numbers... but I don't think making these
> fundamental paths more complex and slower is a nice way to fix it
> (larger PAGE_SIZE would be, though).

The code paths can stay the same. You can switch CONFIG_LARGE pages off
if you do not want it and it is as it was.

If you would have a look the patches: The code is significantly cleanup 
and easier to read.
