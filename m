Return-Path: <linux-kernel-owner+w=401wt.eu-S1031300AbXDZQMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031300AbXDZQMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031324AbXDZQL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:11:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57367 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031300AbXDZQL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:11:57 -0400
Date: Thu, 26 Apr 2007 17:11:52 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426161152.GC16337@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>, clameter@sgi.com,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46304B9E.5070604@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:50:06PM +1000, Nick Piggin wrote:
> Improving the buffer layer would be a good way. Of course, that is
> a long and difficult task, so nobody wants to do it.

It's also a stupid idea.  We got rid of the buffer layer because it's
a complete pain in the ass, and now you want to reintroduce one that's
even more complex, and most likely even slower than the elegant solution?

> Well, for those architectures (and this would solve your large block
> size and 16TB pagecache size without any core kernel changes), you
> can manage 1<<order hardware ptes as a single Linux pte. There is
> nothing that says you must implement PAGE_SIZE as a single TLB sized
> page.

Well, ppc64 can do that.  And guess what, it really painfull for a lot
of workloads.  Think of a poor ps3 with 256 from which the broken hypervisor
already takes a lot away and now every file in the pagecache takes
64k, every thread stack takes 64k, etc?  It's good to have variable
sized objects in places where it makes sense, and the pagecache is
definitively one of them.

