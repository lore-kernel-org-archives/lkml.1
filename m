Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbXIRSD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbXIRSD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbXIRSDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:03:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760336AbXIRSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:03:47 -0400
Date: Tue, 18 Sep 2007 11:03:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: use pagevec to rotate reclaimable page
Message-Id: <20070918110337.7d23b3aa.akpm@linux-foundation.org>
In-Reply-To: <200709181147.45006.nickpiggin@yahoo.com.au>
References: <6.0.0.20.2.20070907113025.024dfbb8@172.19.0.2>
	<200709181129.50253.nickpiggin@yahoo.com.au>
	<20070918104435.2ba25ff3.akpm@linux-foundation.org>
	<200709181147.45006.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 11:47:44 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 19 September 2007 03:44, Andrew Morton wrote:
> > On Tue, 18 Sep 2007 11:29:50 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
> wrote:
> > > It would be interesting to test -mm kernels. They have a patch which
> > > reduces zone lock contention quite a lot.
> >
> > They do?  Which patch?
> 
> Hmm... mm-buffered-write-cleanup.patch.

hmm.

> 
> > > I think your patch is a nice idea, and with less zone lock contention in
> > > other areas, it is possible that it might produce a relatively larger
> > > improvement.
> >
> > I'm a bit wobbly about this patch - it adds additional single-cpu overhead
> > to reduce multiple-cpu overhead and latency.
> 
> Yeah, that's true. Although maybe it gets significantly more after the
> patch in -mm.
> 
> Possibly other page batching sites have similar issues on UP... I wonder
> if a type of pagevec that turns into a noop on UP would be interesting...
> probably totally unmeasurable and not worth the cost of code
> maintenance ;)

Yes, I wonder that.  Some of the additional overhead will come from
the additional get_page/put_page which is needed for pagevec ownership.
