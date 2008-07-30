Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbYG3Rev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbYG3Rev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbYG3Rem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:34:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbYG3Rem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:34:42 -0400
Date: Wed, 30 Jul 2008 10:34:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Eric Munson <ebmunson@us.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-Id: <20080730103407.b110afc2.akpm@linux-foundation.org>
In-Reply-To: <20080730172317.GA14138@csn.ul.ie>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	<20080730014308.2a447e71.akpm@linux-foundation.org>
	<20080730172317.GA14138@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 18:23:18 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> On (30/07/08 01:43), Andrew Morton didst pronounce:
> > On Mon, 28 Jul 2008 12:17:10 -0700 Eric Munson <ebmunson@us.ibm.com> wrote:
> > 
> > > Certain workloads benefit if their data or text segments are backed by
> > > huge pages.
> > 
> > oh.  As this is a performance patch, it would be much better if its
> > description contained some performance measurement results!  Please.
> > 
> 
> I ran these patches through STREAM (http://www.cs.virginia.edu/stream/).
> STREAM itself was patched to allocate data from the stack instead of statically
> for the test. They completed without any problem on x86, x86_64 and PPC64
> and each test showed a performance gain from using hugepages.  I can post
> the raw figures but they are not currently in an eye-friendly format. Here
> are some plots of the data though;
> 
> x86: http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/x86-stream-stack.ps
> x86_64: http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/x86_64-stream-stack.ps
> ppc64-small: http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/ppc64-small-stream-stack.ps
> ppc64-large: http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/ppc64-large-stream-stack.ps
> 
> The test was to run STREAM with different array sizes (plotted on X-axis)
> and measure the average throughput (y-axis). In each case, backing the stack
> with large pages with a performance gain.

So about a 10% speedup on x86 for most STREAM configurations.  Handy -
that's somewhat larger than most hugepage-conversions, iirc.

Do we expect that this change will be replicated in other
memory-intensive apps?  (I do).

