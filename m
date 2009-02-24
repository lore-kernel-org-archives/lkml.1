Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZBXOI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZBXOI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZBXOIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:08:47 -0500
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:39413 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754752AbZBXOIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:08:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mpGRNlfHQrzy3paAn4rwS5/FsCHiItEZCKVEi5YFsZjq5h1TD1dqaKhjBB3sPLBKcU2KfODxDpY4xtcKffeYP74pq0QEKloJXtiZgN9JCNUMmmu/hF78C9tC/HUYlsDqiJ8cwDquRU5+537zXUGrcBSMQD1ry4FGwWw191lxJRE=  ;
X-YMail-OSG: UsoahFkVM1kEuyc4crjBXSpoI_KVG_BrdnqmdOjpwo444UQ0jONdqRoHSpm5F.qQjEiLEptIW5N.B6OFRoi08UOdCBqgPStYLJoKA2nJ9mmHrqSlLVMtWoK2NdqGy6tvY79ct75iiK.o1QSiun53oDK208TbCOLhHGGt6by_M674W6VihZGlIqd7a1lRHA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 11/20] Inline get_page_from_freelist() in the fast-path
Date: Wed, 25 Feb 2009 01:08:10 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <200902240232.39140.nickpiggin@yahoo.com.au> <20090224133253.GB26239@csn.ul.ie>
In-Reply-To: <20090224133253.GB26239@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902250108.11664.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 00:32:53 Mel Gorman wrote:
> On Tue, Feb 24, 2009 at 02:32:37AM +1100, Nick Piggin wrote:
> > On Monday 23 February 2009 10:17:20 Mel Gorman wrote:
> > > In the best-case scenario, use an inlined version of
> > > get_page_from_freelist(). This increases the size of the text but
> > > avoids time spent pushing arguments onto the stack.
> >
> > I'm quite fond of inlining ;) But it can increase register pressure as
> > well as icache footprint as well. x86-64 isn't spilling a lot more
> > registers to stack after these changes, is it?
>
> I didn't actually check that closely so I don't know for sure. Is there a
> handier way of figuring it out than eyeballing the assembly? In the end

I guess the 5 second check is to look at how much stack the function
uses. OTOH I think gcc does do a reasonable job at register allocation.


> I dropped the inline of this function anyway. It means the patches
> reduce rather than increase text size which is a bit more clear-cut.

Cool, clear cut patches for round 1 should help to get things moving.


> > In which case you will get extra icache footprint. What speedup does
> > it give in the cache-hot microbenchmark case?
>
> I wasn't measuring with a microbenchmark at the time of writing so I don't
> know. I was going entirely by profile counts running kernbench and the
> time spent running the benchmark.

OK. Well seeing as you have dropped this for the moment, let's not
dwell on it ;)

