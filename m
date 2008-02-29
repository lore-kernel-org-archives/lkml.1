Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbYB2Oi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbYB2Oi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 09:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbYB2Oiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 09:38:46 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:10477 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbYB2Oip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 09:38:45 -0500
Subject: Re: [patch 14/21] scan noreclaim list for reclaimable pages
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <20080228154152.9648b7b8.randy.dunlap@oracle.com>
References: <20080228192908.126720629@redhat.com>
	 <20080228192929.203173998@redhat.com>
	 <20080228154152.9648b7b8.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 29 Feb 2008 09:38:54 -0500
Message-Id: <1204295934.5311.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-28 at 15:41 -0800, Randy Dunlap wrote:
> On Thu, 28 Feb 2008 14:29:22 -0500 Rik van Riel wrote:
> 
> > V2 -> V3:
> > + rebase to 23-mm1 atop RvR's split LRU series
> > 
> > New in V2
> > 
> > This patch adds a function to scan individual or all zones' noreclaim
> > lists and move any pages that have become reclaimable onto the respective
> > zone's inactive list, where shrink_inactive_list() will deal with them.
> > 
> > This replaces the function to splice the entire noreclaim list onto the
> > active list for rescan by shrink_active_list().  That method had problems
> > with vmstat accounting and complicated '[__]isolate_lru_pages()'.  Now,
> > __isolate_lru_page() will never isolate a non-reclaimable page.  The
> > only time it should see one is when scanning nearby pages for lumpy
> > reclaim.
> > 
> >   TODO:  This approach may still need some refinement.
> >          E.g., put back to active list?
> > 
> > DEBUGGING ONLY: NOT FOR UPSTREAM MERGE
> > 
> > Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
> > Signed-off-by:  Rik van Riel <riel@redhat.com>
> 
> 
> Hi,
> 
> I haven't looked at all 21 patches, but please use kernel-doc
> notation as it's defined.  See Documentation/kernel-doc-nano-HOWTO.txt
> for details, or ask.

Hi, Randy:

I'll make a pass thru the noreclaim patches and fix up the comment
blocks that are not quite kernel-doc.  I have to update some of the
patch descriptions as well, as some have become stale thanks to
additional work by Kosaki-san [e.g., the page vec cleanup].

I'll discuss with Rik, off-list, how to coordinate for the next
reposting.

Thanks,
Lee

