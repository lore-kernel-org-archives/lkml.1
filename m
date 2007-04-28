Return-Path: <linux-kernel-owner+w=401wt.eu-S1161257AbXD1GxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161257AbXD1GxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161235AbXD1GxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:53:05 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161257AbXD1GxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:53:03 -0400
Date: Fri, 27 Apr 2007 23:52:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070427235247.3576a463.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704272319170.7610@schroedinger.engr.sgi.com>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	<20070427002640.22a71d06.akpm@linux-foundation.org>
	<20070427163620.GI32602149@melbourne.sgi.com>
	<20070427173432.GJ32602149@melbourne.sgi.com>
	<20070427121108.9ee05710.akpm@linux-foundation.org>
	<20070428031739.GK32602149@melbourne.sgi.com>
	<20070427215634.325606a9.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704272158360.7342@schroedinger.engr.sgi.com>
	<20070427223632.52def99e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704272319170.7610@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 23:24:05 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> > Fact is, this change has *costs*.  And you're completely ignoring them,
> > trying to spin them away.  It ain't working and it never will.  I'm seeing
> > no serious attempt to think about how we can reduce those costs while
> > retaining most of the benefits.
> 
> Well okay my work is "no serious attempt".

No.  My point is, you have resisted all attempts to explore less costly
*alternatives* to this work.  Alternatives.

By misunderstanding any suggestions, misrepresenting them, making incorrect
statements about them, by not suggesting any alternatives yourself, all of
it buttressed by a stolid refusal to recognise that this patch has any
costs.

This effectively leaves it up to others to find time to think about and to
implement possible alternative solutions to the problems which you're
observing.


The altenative which is on the table (and there may be others) is
populating pagecache with physically contiguous pages.  This will fix the
HBA problem and is much less costly in terms of maintenance and will
improve all workloads on all machines and doesn't have the additional
runtime costs of pagecache wastage and more memset() overhead with small
files and it doesn't require administrator intervention.

OTOH (yes!  there are tradeoffs!) it will consume an unknown amount more
CPU and it doesn't address the large-fs-blocksize requirement, but I don't
know how important the latter is and given the unrelenting advocacy storm
coming from the SGI direction I don't know how to find that out, frankly.
