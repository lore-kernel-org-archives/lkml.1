Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYGaGEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYGaGEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYGaGEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:04:23 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:21500 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751701AbYGaGEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:04:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=inolIFpd/4noFguNFuTTW6EgbuwcHXruGKzJ7WOmzZ7WNilMYjWXHn88p1FXbo3qaG0wp1dmSIu5tlR5+qbpiivj0NADS/AXrSuaz24wBYmzmL90U1U4jsXtLN5UPVd61B3SIlXQ3vo6nuXbNF1kVJ8OsMXxOrpciD37QCQey4A=  ;
X-YMail-OSG: 20M9yPQVM1kRpjAoUuwHotk9WXxCNRcBhJN6Mt2WZSzG9SJA.7r3inOP9cCqIsehjP9JAuNvX0G.yhHRSvDJZGderOk9nqiRcPQW4kbqejxlf1kwfiC.sdoOYEzJDCo6xGGNsRn3Div2JsUvLcI1eO6j
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Date: Thu, 31 Jul 2008 16:04:14 +1000
User-Agent: KMail/1.9.5
Cc: Mel Gorman <mel@csn.ul.ie>, Eric Munson <ebmunson@us.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net
References: <cover.1216928613.git.ebmunson@us.ibm.com> <20080730172317.GA14138@csn.ul.ie> <20080730103407.b110afc2.akpm@linux-foundation.org>
In-Reply-To: <20080730103407.b110afc2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311604.14349.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 03:34, Andrew Morton wrote:
> On Wed, 30 Jul 2008 18:23:18 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> > On (30/07/08 01:43), Andrew Morton didst pronounce:
> > > On Mon, 28 Jul 2008 12:17:10 -0700 Eric Munson <ebmunson@us.ibm.com> 
wrote:
> > > > Certain workloads benefit if their data or text segments are backed
> > > > by huge pages.
> > >
> > > oh.  As this is a performance patch, it would be much better if its
> > > description contained some performance measurement results!  Please.
> >
> > I ran these patches through STREAM (http://www.cs.virginia.edu/stream/).
> > STREAM itself was patched to allocate data from the stack instead of
> > statically for the test. They completed without any problem on x86,
> > x86_64 and PPC64 and each test showed a performance gain from using
> > hugepages.  I can post the raw figures but they are not currently in an
> > eye-friendly format. Here are some plots of the data though;
> >
> > x86:
> > http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/x86-stream-stac
> >k.ps x86_64:
> > http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/x86_64-stream-s
> >tack.ps ppc64-small:
> > http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/ppc64-small-str
> >eam-stack.ps ppc64-large:
> > http://www.csn.ul.ie/~mel/postings/stack-backing-20080730/ppc64-large-str
> >eam-stack.ps
> >
> > The test was to run STREAM with different array sizes (plotted on X-axis)
> > and measure the average throughput (y-axis). In each case, backing the
> > stack with large pages with a performance gain.
>
> So about a 10% speedup on x86 for most STREAM configurations.  Handy -
> that's somewhat larger than most hugepage-conversions, iirc.

Although it might be a bit unusual to have codes doing huge streaming
memory operations on stack memory...

We can see why IBM is so keen on their hugepages though :)


> Do we expect that this change will be replicated in other
> memory-intensive apps?  (I do).

Such as what? It would be nice to see some numbers with some HPC or java
or DBMS workload using this. Not that I dispute it will help some cases,
but 10% (or 20% for ppc) I guess is getting toward the best case, short
of a specifically written TLB thrasher.
