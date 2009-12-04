Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbZLDRRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbZLDRRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbZLDRRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:17:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115AbZLDRRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:17:15 -0500
Date: Fri, 4 Dec 2009 09:16:40 -0800
From: Chris Wright <chrisw@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-ID: <20091204171640.GE19624@x200.localdomain>
References: <20091202125501.GD28697@random.random>
 <20091203134610.586E.A69D9226@jp.fujitsu.com>
 <20091204135938.5886.A69D9226@jp.fujitsu.com>
 <20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki (kamezawa.hiroyu@jp.fujitsu.com) wrote:
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Windows kernel have zero page thread and it clear the pages in free list
> > periodically. because many windows subsystem prerefer zero filled page.
> > hen, if we use windows guest, zero filled page have plenty mapcount rather
> > than other typical sharing pages, I guess.
> > 
> > So, can we mark as unevictable to zero filled ksm page? 

That's why I mentioned the page of zeroes as the prime example of
something with a high mapcount that shouldn't really ever be evicted.

> Hmm, can't we use ZERO_PAGE we have now ?
> If do so,
>  - no mapcount check
>  - never on LRU
>  - don't have to maintain shared information because ZERO_PAGE itself has
>    copy-on-write nature.

It's a somewhat special case, but wouldn't it be useful to have a generic
method to recognize this kind of sharing since it's a generic issue?

thanks,
-chris
