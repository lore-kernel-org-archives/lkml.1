Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZLBCCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZLBCCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 21:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZLBCCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 21:02:37 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53647 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbZLBCCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 21:02:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] high system time & lock contention running large mixed workload
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20091201124619.GO30235@random.random>
References: <20091201212357.5C3A.A69D9226@jp.fujitsu.com> <20091201124619.GO30235@random.random>
Message-Id: <20091202102111.5C43.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Dec 2009 11:02:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > Avoiding lock contention on light VM pressure is important than
> > strict lru order. I guess we don't need knob.
> 
> Hope so indeed. It's not just lock contention, that is exacerbated by
> certain workloads, but even in total absence of any lock contention I
> generally dislike the cpu waste itself of the pte loop to clear the
> young bit, and the interruption of userland as well when it receives a
> tlb flush for no good reason because 99% of the time plenty of
> unmapped clean cache is available. I know this performs best, even if
> there will be always someone that will want mapped and unmapped cache
> to be threat totally equal in lru terms (which then make me wonder why
> there are still & VM_EXEC magics in vmscan.c if all pages shall be
> threaded equal in the lru... especially given VM_EXEC is often
> meaningless [because potentially randomly set] unlike page_mapcount
> [which is never randomly set]), which is the reason I mentioned the
> knob.

Umm?? I'm puzlled. if almost pages in lru are unmapped file cache, pte walk
is not costly. reverse, if almost pages in lru are mapped pages, we have
to do pte walk, otherwise any pages don't deactivate and system cause
big latency trouble.

I don't want vmscan focus to peak speed and ignore worst case. it isn't proper
behavior in memory shortage situation. Then I hope to focus to solve lock
contention issue. 

Of course, if this cause any trouble to KVM or other usage in real world,
I'll fix it. 
if you have any trouble experience about current VM, please tell us.

[I (and Hugh at least) dislike VM_EXEC logic too. but it seems off topic.]



