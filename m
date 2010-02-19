Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0BSN7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:59:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44893 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab0BSN7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:59:49 -0500
Date: Fri, 19 Feb 2010 13:59:35 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 01/12] mm,migration: Take a reference to the anon_vma
	before migrating
Message-ID: <20100219135934.GF30258@csn.ul.ie>
References: <1266516162-14154-1-git-send-email-mel@csn.ul.ie> <1266516162-14154-2-git-send-email-mel@csn.ul.ie> <20100219091244.2116db73.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100219091244.2116db73.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 09:12:44AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 18 Feb 2010 18:02:31 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > rmap_walk_anon() does not use page_lock_anon_vma() for looking up and
> > locking an anon_vma and it does not appear to have sufficient locking to
> > ensure the anon_vma does not disappear from under it.
> > 
> > This patch copies an approach used by KSM to take a reference on the
> > anon_vma while pages are being migrated. This should prevent rmap_walk()
> > running into nasty surprises later because anon_vma has been freed.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> I have no objection to this direction. But after this patch, you can remove
> rcu_read_lock()/unlock() in unmap_and_move().
> ruc_read_lock() is for guarding against anon_vma replacement.
> 

Thanks. I expected that would be the case but was going to leave at
least one kernel release between when compaction went in and I did that.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
