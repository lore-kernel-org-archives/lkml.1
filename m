Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276Ab0AFAdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0AFAdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043Ab0AFAdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:33:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47387 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0AFAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:33:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/4] vmstat: remove zone->lock from walk_zones_in_node
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100105101821.GA28975@csn.ul.ie>
References: <20100105105328.96CE.A69D9226@jp.fujitsu.com> <20100105101821.GA28975@csn.ul.ie>
Message-Id: <20100106093257.9E2B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  6 Jan 2010 09:33:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thanks lots comments. 
> > hmm.. I'd like to clarily your point. My point is memory-hotplug don't take zone lock,
> > then zone lock doesn't protect anything. so we have two option
> > 
> > 1) Add zone lock to memroy-hotplug
> > 2) Remove zone lock from zoneinfo
> > 
> > I thought (2) is sufficient. Do you mean you prefer to (1)? Or you prefer to ignore rarely event
> > (of cource, memory hotplug is rarely)?
> > 
> 
> I think (2) will make zoneinfo harder to use for examining all the counters
> properly as I explained above. I haven't looked at memory-hotplug in a
> while but IIRC, fields like present_pages should be protected by a lock on
> the pgdat and a seq lock on the zone. If this is not true at the moment,
> it is a problem.
> 
> For the free lists, memory hotplug should be taking the zone->lock properly as
> the final stage of onlining memory is to walk the sections being hot-added,
> init the memmap and then __free_page() each page individually - i.e. the
> normal free path.
> 
> So, if memory hotplug is not protected by proper locking, it's not intentional.

ok, I drop this patch. thanks.



