Return-Path: <linux-kernel-owner+w=401wt.eu-S936038AbXGMIjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936038AbXGMIjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXGMIjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:39:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935217AbXGMIi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:38:57 -0400
Date: Fri, 13 Jul 2007 01:38:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: joe.jin@oracle.com, bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, Zwane Mwaikambo <zwane@arm.linux.org.uk>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713013819.0f8bd1ea.akpm@linux-foundation.org>
In-Reply-To: <20070713012906.a6f63c90.pj@sgi.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070712235707.a08f0d42.akpm@linux-foundation.org>
	<20070713012906.a6f63c90.pj@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 01:29:06 -0700 Paul Jackson <pj@sgi.com> wrote:

> > I'm scratching my head over that min_t in __first_node(), too.   I don't think
> > it's possible for find_first_bit(..., N) to return anything >N _anyway_.  And if
> > it does, we want to know about it.
> > 
> > <looks at Paul>
> 
> I'm not sure I've got this right, but looks like that min_t went in after
> Zwane Mwaikambo, then <zwane@fsmlabs.com>, whom I am presuming is the same
> person as now at <zwane@arm.linux.org.uk>, found a problem with the i386
> find_next_bit implementation returning > N when merging i386 cpu hotplug.

Ah, Zwane was involved - say no more ;)

> See the thread:
> 
>   http://lkml.org/lkml/2004/7/31/102
>   [PATCH][2.6] first/next_cpu returns values > NR_CPUS
> 
> I apparently lobbied at the time to mandate that find_first_bit(..., N)
> return exactly N on failure to find a set bit, but gave up, after some
> confusions on my part.

iirc, find_first_bit(..., N) _must_ return N on nothing-found.  It'd be
untidy to return some randomly-larger number.

I wonder which was the culpable architecture?  Oh, i386.

Note how the i386 implementation's documentation carefully avoids describing
the return value.  I don't think _any_ of our find_foo_bit()
implementations have return-value docs, and here we see the result.

Sigh.  What crap.  I guess we leave it as-is.


