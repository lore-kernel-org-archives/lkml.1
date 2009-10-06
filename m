Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZJFHpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZJFHpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZJFHpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:45:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44127 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbZJFHpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:45:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [rfc patch 3/3] mm: munlock COW pages on truncation unmap
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091005193200.GA13040@cmpxchg.org>
References: <2f11576a0910030656l73c9811w18e0f224fb3d98af@mail.gmail.com> <20091005193200.GA13040@cmpxchg.org>
Message-Id: <20091006163748.1263.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Oct 2009 16:44:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> On Sat, Oct 03, 2009 at 10:56:55PM +0900, KOSAKI Motohiro wrote:
> > >> Umm..
> > >> I haven't understand this.
> > >>
> > >> (1) unmap_mapping_range() is called twice.
> > >>
> > >>       unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > >>       truncate_inode_pages(mapping, new);
> > >>       unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
> > >>
> > >> (2) PG_mlock is turned on from mlock() and vmscan.
> > >> (3) vmscan grab anon_vma, but mlock don't grab anon_vma.
> > >
> > > You are right, I was so focused on the LRU side that I missed an
> > > obvious window here: an _explicit_ mlock can still happen between the
> > > PG_mlocked clearing section and releasing the page.
> 
> Okay, so what are the opinions on this?  Would you consider my patches
> to fix the most likely issues?  Dropping them in favor of looking for
> a complete fix?  Revert the warning on freeing PG_mlocked pages?

Honestly, I don't have any good idea. but luckly, we have enough time.
the false-positve warning is not so big problem. then, I prefer looking for
complete solusion.

Thanks.

