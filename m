Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYILBFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYILBFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 21:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYILBF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 21:05:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44391 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYILBF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 21:05:26 -0400
Date: Fri, 12 Sep 2008 10:10:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH] Mark the correct zone as full when scanning zonelists
Message-Id: <20080912101007.ed56780f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080911144155.c70ef145.akpm@linux-foundation.org>
References: <20080911212550.GA18087@csn.ul.ie>
	<20080911144155.c70ef145.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 14:41:55 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 11 Sep 2008 22:25:51 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > The for_each_zone_zonelist() uses a struct zoneref *z cursor when scanning
> > zonelists to keep track of where in the zonelist it is. The zoneref that
> > is returned corresponds to the the next zone that is to be scanned, not
> > the current one as it originally thought of as an opaque list.
> > 
> > When the page allocator is scanning a zonelist, it marks zones that it
> > temporarily full zones to eliminate near-future scanning attempts.
> 
> That sentence needs help.
> 
Hmm, should we rename

 next_zone_zonelist() => get_appropriate_zone_from_list()

or some better name ?

> > It uses
> > the zoneref for the marking and consequently the incorrect zone gets marked
> > full. This leads to a suitable zone being skipped in the mistaken belief
> > it is full. This patch corrects the problem by changing zoneref to be the
> > current zone being scanned instead of the next one.
> 
> Applicable to 2.6.26 as well, yes?
> 
Maybe yes. But it's better to show where this patch really fixes.
Is this a fix for misunderstanding usage of zoneref in
mm/page_alloc.c::get_page_from_freelist() ?

== here ?==
  if (NUMA_BUILD)
	zlc_mark_zone_full(zonelist, z);

Thanks,
-Kame

