Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbZCDHY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbZCDHY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZCDHYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:24:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:47127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbZCDHYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:24:04 -0500
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Lin Ming <ming.m.lin@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1236132307.2567.25.camel@ymzhang>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
	 <1235639427.11390.11.camel@minggr> <20090226110336.GC32756@csn.ul.ie>
	 <1235647139.16552.34.camel@penberg-laptop>
	 <20090226112232.GE32756@csn.ul.ie> <1235724283.11610.212.camel@minggr>
	 <20090302112122.GC21145@csn.ul.ie>  <1236132307.2567.25.camel@ymzhang>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 08:23:34 +0100
Message-Id: <1236151414.5330.6692.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 10:05 +0800, Zhang, Yanmin wrote:
> FAIR_GROUP_SCHED is a feature to support configurable cpu weight for different users.
> We did find it takes lots of time to check/update the share weight which might create
> lots of cache ping-pang. With sysbench(oltp)+mysql, that becomes more severe because
> mysql runs as user mysql and sysbench runs as another regular user. When starting
> the testing with 1 thread in command line, there are 2 mysql threads and 1 sysbench
> thread are proactive.

cgroup based group scheduling doesn't bother with users. So unless you
create sched-cgroups your should all be in the same (root) group.

