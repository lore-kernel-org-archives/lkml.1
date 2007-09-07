Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXIGCPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXIGCPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 22:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXIGCO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 22:14:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59610 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbXIGCO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 22:14:58 -0400
Date: Fri, 7 Sep 2007 11:16:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][-mm] Fix setup_per_zone_pages_min() lock.
Message-Id: <20070907111650.0e0bf01f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1189086781.3834.10.camel@machina.109elm.lan>
References: <20070903194629.aa24ecc5.kamezawa.hiroyu@jp.fujitsu.com>
	<1189086781.3834.10.camel@machina.109elm.lan>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 14:53:01 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> Does it really matter as they routinely do not take zone->lru_lock
> either? pages_min, pages_low and pages_high are currently examined on a
> regular basis by zone_watermark_ok() without any locks held in the page
> allocator and page reclaim path. Glancing through this, it would appear
> that the code in question has the same level of locking protection with
> zone->lru_lock or zone->lock.
> 
At the first look, I thought this should be lock-less. But I noticed that
memory hotplug(See add_memory()) calls  setup_per_zone_pages_min().
Then, logically, there are 2 interfaces which calls  setup_per_zone_pages_min();
So, we need some kind of lock. 

And setup_zone_migrate_reserve() is also called in this function.
This does more than change value. So I thought zone->lock is good here.

> Is memory hotadd specifically taking the lru_lock somewhere? I can only
> think of the seqlock at the moment.
> 
memory hotplug doesn't take lru_lock.


Thanks,
-Kame

