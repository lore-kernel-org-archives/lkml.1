Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZFWVZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZFWVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZFWVZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:25:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40737 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbZFWVZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:25:15 -0400
Message-ID: <4A41481D.1060607@redhat.com>
Date: Tue, 23 Jun 2009 17:24:45 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: akataria@vmware.com
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>	 <1245732411.18339.6.camel@alok-dev1>	 <20090623135017.220D.A69D9226@jp.fujitsu.com>	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com> <1245736441.18339.21.camel@alok-dev1>
In-Reply-To: <1245736441.18339.21.camel@alok-dev1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:

> Both, while working on an module I noticed that there is no way direct
> way to get any information regarding the total number of unrecliamable
> (unevictable) pages in the system. While reading through the kernel
> sources i came across this unevictalbe LRU framework and thought that
> this should actually work towards providing  total unevictalbe pages in
> the system irrespective of where they reside.

The unevictable count tells you how many _userspace_
pages are not evictable.

There are countless accounted and unaccounted kernel
allocations that show up (or not) in other fields in
/proc/meminfo.

I can see something reasonable on both sides of this
particular debate.  However, even with this patch the
"unevictable" statistic does not reclaim the total
number of pages that are unevictable pages from a
zone, so I am not sure how it helps you achieve your
goal.

-- 
All rights reversed.
