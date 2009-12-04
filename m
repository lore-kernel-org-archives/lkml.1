Return-Path: <linux-kernel-owner+w=401wt.eu-S1751404AbZLDFTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbZLDFTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 00:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZLDFTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 00:19:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49940 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZLDFTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 00:19:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Dec 2009 14:16:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Message-Id: <20091204141617.f4c491e7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091204135938.5886.A69D9226@jp.fujitsu.com>
References: <20091202125501.GD28697@random.random>
	<20091203134610.586E.A69D9226@jp.fujitsu.com>
	<20091204135938.5886.A69D9226@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Dec 2009 14:06:07 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Umm?? Personally I don't like knob. If you have problematic workload,
> > please tell it us. I will try to make reproduce environment on my box.
> > If current code doesn't works on KVM or something-else, I really want
> > to fix it.
> > 
> > I think Larry's trylock idea and your 64 young bit idea can be combinate.
> > I only oppose the page move to inactive list without clear young bit. IOW,
> > if VM pressure is very low and the page have lots young bit, the page should
> > go back active list although trylock(ptelock) isn't contended.
> > 
> > But unfortunatelly I don't have problem workload as you mentioned. Anyway
> > we need evaluate way to your idea. We obviouslly more info.
> 
> [Off topic start]
> 
> Windows kernel have zero page thread and it clear the pages in free list
> periodically. because many windows subsystem prerefer zero filled page.
> hen, if we use windows guest, zero filled page have plenty mapcount rather
> than other typical sharing pages, I guess.
> 
> So, can we mark as unevictable to zero filled ksm page? 
> 

Hmm, can't we use ZERO_PAGE we have now ?
If do so,
 - no mapcount check
 - never on LRU
 - don't have to maintain shared information because ZERO_PAGE itself has
   copy-on-write nature.

Thanks,
-Kame

