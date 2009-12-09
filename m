Return-Path: <linux-kernel-owner+w=401wt.eu-S967073AbZLIBEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967073AbZLIBEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 20:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967057AbZLIBE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 20:04:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967053AbZLIBE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 20:04:27 -0500
Date: Tue, 8 Dec 2009 17:04:19 -0800
From: Chris Wright <chrisw@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Chris Wright <chrisw@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-ID: <20091209010419.GG28655@x200.localdomain>
References: <20091202125501.GD28697@random.random>
 <20091203134610.586E.A69D9226@jp.fujitsu.com>
 <20091204135938.5886.A69D9226@jp.fujitsu.com>
 <20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
 <20091204171640.GE19624@x200.localdomain>
 <20091209094331.a1f53e6d.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209094331.a1f53e6d.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki (kamezawa.hiroyu@jp.fujitsu.com) wrote:
> On Fri, 4 Dec 2009 09:16:40 -0800
> Chris Wright <chrisw@redhat.com> wrote:
> > * KAMEZAWA Hiroyuki (kamezawa.hiroyu@jp.fujitsu.com) wrote:
> > > Hmm, can't we use ZERO_PAGE we have now ?
> > > If do so,
> > >  - no mapcount check
> > >  - never on LRU
> > >  - don't have to maintain shared information because ZERO_PAGE itself has
> > >    copy-on-write nature.
> > 
> > It's a somewhat special case, but wouldn't it be useful to have a generic
> > method to recognize this kind of sharing since it's a generic issue?
> 
> I just remembered that why ZERO_PAGE was removed (in past). It was becasue
> cache-line ping-pong at fork beacause of page->mapcount. And KSM introduces
> zero-pages which have mapcount again. If no problems in realitsitc usage of
> KVM, ignore me.

KVM is not exactly fork heavy (although it's not the only possible user
of KSM).  And the CoW path has fault + copy already.

Semi-related...it can make good sense to make the KSM trees per NUMA
node.  Would mean things like page of zeroes would collapse to number
of NUMA nodes pages rather than a single page, but has the benefit of
not adding remote access (although, probably more useful for text pages
than zero pages).

thanks,
-chris
