Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbZLKAOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbZLKAOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761891AbZLKAOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:14:14 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47442 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761886AbZLKAOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:14:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Dec 2009 09:11:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-Id: <20091211091114.c5fa4371.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091210185459.GA8697@elte.hu>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210075454.GB25549@elte.hu>
	<20091210172040.37d259d3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210083310.GB6834@elte.hu>
	<alpine.DEB.2.00.0912101134220.5481@router.home>
	<20091210173819.GA5256@elte.hu>
	<alpine.DEB.2.00.0912101203320.5481@router.home>
	<20091210185459.GA8697@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 19:54:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> > [...] Exposing via perf is outside of the scope of his work.
> 
> Please make thoughts about intelligent instrumentation solutions, and 
> please think "outside of the scope" of your usual routine.
> 

I'm sorry that I don't fully understand your suggestion...

This patch is for _usage_ counters (those can increase/decrease and can be
modified in batched manner), but you don't talk about usage counter
but about lack of (useful) _event_ counters under page fault path.

If so, yes, I agree that current events are not enough.
If not, hmm ? 

More event counters I can think of around mm/page-fault is following..

  - fault to new anon pages
    + a new anon page is from remote node.
  - fault to file-backed area
    + a file page is from remote node.
  - copy_on_write
    +  a new anon page is from remote node.
    +  copy-on-write to zero page.
  - make page write (make page dirty)
  - search vma. (find_vma() is called and goes into rb-tree lookup)
  - swap-in (necessary ?)
  - get_user_page() is called to snoop other process's memory.

I wonder adding event and inserting perf_sw_event(PERF_COUNT_SW....) is
enough for adding event coutners...but is there good documentation of
this hook ?

Thanks,
-Kame

