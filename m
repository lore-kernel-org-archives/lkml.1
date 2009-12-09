Return-Path: <linux-kernel-owner+w=401wt.eu-S967025AbZLIAqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967025AbZLIAqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966998AbZLIAqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:46:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32806 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966996AbZLIAqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:46:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Dec 2009 09:43:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Chris Wright <chrisw@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-Id: <20091209094331.a1f53e6d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091204171640.GE19624@x200.localdomain>
References: <20091202125501.GD28697@random.random>
	<20091203134610.586E.A69D9226@jp.fujitsu.com>
	<20091204135938.5886.A69D9226@jp.fujitsu.com>
	<20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
	<20091204171640.GE19624@x200.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009 09:16:40 -0800
Chris Wright <chrisw@redhat.com> wrote:

> * KAMEZAWA Hiroyuki (kamezawa.hiroyu@jp.fujitsu.com) wrote:
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > Windows kernel have zero page thread and it clear the pages in free list
> > > periodically. because many windows subsystem prerefer zero filled page.
> > > hen, if we use windows guest, zero filled page have plenty mapcount rather
> > > than other typical sharing pages, I guess.
> > > 
> > > So, can we mark as unevictable to zero filled ksm page? 
> 
> That's why I mentioned the page of zeroes as the prime example of
> something with a high mapcount that shouldn't really ever be evicted.
> 
> > Hmm, can't we use ZERO_PAGE we have now ?
> > If do so,
> >  - no mapcount check
> >  - never on LRU
> >  - don't have to maintain shared information because ZERO_PAGE itself has
> >    copy-on-write nature.
> 
> It's a somewhat special case, but wouldn't it be useful to have a generic
> method to recognize this kind of sharing since it's a generic issue?
> 

I just remembered that why ZERO_PAGE was removed (in past). It was becasue
cache-line ping-pong at fork beacause of page->mapcount. And KSM introduces
zero-pages which have mapcount again. If no problems in realitsitc usage of
KVM, ignore me.

Thanks,
-Kame

