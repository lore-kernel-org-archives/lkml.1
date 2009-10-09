Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbZJIUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbZJIUXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbZJIUXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:23:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50375 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761421AbZJIUXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:23:43 -0400
Date: Fri, 9 Oct 2009 15:23:04 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Gerald Schaefer <geralds@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linuxppc-dev@ozlabs.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2][v2] mm: add notifier in pageblock isolation for
	balloon drivers
Message-ID: <20091009202304.GB19114@austin.ibm.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Brian King <brking@linux.vnet.ibm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Gerald Schaefer <geralds@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@ozlabs.org,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <20091002184458.GC4908@austin.ibm.com> <20091008163449.00dce972.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008163449.00dce972.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 2 Oct 2009 13:44:58 -0500
> Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> 
> > Memory balloon drivers can allocate a large amount of memory which
> > is not movable but could be freed to accomodate memory hotplug remove.
> > 
> > Prior to calling the memory hotplug notifier chain the memory in the
> > pageblock is isolated.  If the migrate type is not MIGRATE_MOVABLE the
> > isolation will not proceed, causing the memory removal for that page
> > range to fail.
> > 
> > Rather than failing pageblock isolation if the the migrateteype is not
> > MIGRATE_MOVABLE, this patch checks if all of the pages in the pageblock
> > are owned by a registered balloon driver (or other entity) using a
> > notifier chain.  If all of the non-movable pages are owned by a balloon,
> > they can be freed later through the memory notifier chain and the range
> > can still be isolated in set_migratetype_isolate().
> 
> The patch looks sane enough to me.
> 
> I expect that if the powerpc and s390 guys want to work on CMM over the
> next couple of months, they'd like this patch merged into 2.6.32.  It's
> a bit larger and more involved than one would like, but I guess we can
> do that if suitable people (Mel?  Kamezawa?) have had a close look and
> are OK with it.
>
> What do people think?

I'd love to get it in 2.6.32 if that's possible.  I have gone over the 
comments from Mel and Kamezawa I produced a new patchset.  I just
finished testing it (and I also tested with
CONFIG_MEMORY_HOTPLUG_SPARSE=n) and it will be posted shortly.

> 
> Has it been carefully compile- and run-time tested with
> CONFIG_MEMORY_HOTPLUG_SPARSE=n?

Yes, I have compiled the kernel CONFIG_MEMORY_HOTPLUG_SPARSE=n and made
sure that we didn't have any problems.

--Robert Jennings
