Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZGEKjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZGEKjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 06:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZGEKiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 06:38:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54836 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZGEKiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 06:38:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: Found the commit that causes the OOMs
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <20090705095520.GA31587@localhost>
References: <4A4AD07E.2040508@redhat.com> <20090705095520.GA31587@localhost>
Message-Id: <20090705193551.090E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  5 Jul 2009 19:38:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> OK. thanks.
> >> I plan to submit this patch after small more tests. it is useful for OOM analysis.
> >
> > It is also useful for throttling page reclaim.
> >
> > If more than half of the inactive pages in a zone are
> > isolated, we are probably beyond the point where adding
> > additional reclaim processes will do more harm than good.
> 
> Maybe we can try limiting the isolation phase of direct reclaims to
> one per CPU?
> 
>         mutex_lock(per_cpu_lock);
>         isolate_pages();
>         shrink_page_list();
>         put_back_pages();
>         mutex_unlock(per_cpu_lock);
> 
> This way the isolated pages as well as major parts of direct reclaims
> will be bounded by CPU numbers. The added overheads should be trivial
> comparing to the reclaim costs.

hm, this idea makes performance degression on few CPU machine, I think.

e.g.
if system have only one cpu and sysmtem makes lumpy reclaim, lumpy reclaim
makes synchronous pageout and it makes very long waiting time.

I suspect per-cpu decision is not useful in this area.

thanks.


