Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbZDLXRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbZDLXRN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 19:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZDLXRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 19:17:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41842 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZDLXQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 19:16:59 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/9] readahead: clean up and simplify the code for filemap  page fault readahead
Cc: kosaki.motohiro@jp.fujitsu.com, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org, lpk@581.spb.su, wli@movementarian.org,
       torvalds@linux-foundation.org, yinghan@google.com,
       Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20090411114920.b9d2493c.akpm@linux-foundation.org>
References: <2f11576a0904110658i4c595f49odbaefda8f8fa95d@mail.gmail.com> <20090411114920.b9d2493c.akpm@linux-foundation.org>
Message-Id: <20090413081024.F451.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 13 Apr 2009 08:16:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 11 Apr 2009 22:58:31 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > Ah. __But I have a note here that I didn't like it, because it adds lots
> > > of new spinlocking to fastpaths. __So I'll leave things as they stand
> > > until we have had a little talk about that.
> > 
> > add?
> > 
> > old code: grab zone->lru_lock via mark_page_accessed()
> > new code: grab zone->lru_lock via update_reclaim_stat()
> > 
> > one remove, one add.
> > 
> 
> mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch adds
> new calls to update_page_reclaim_stat() into do_swap_page() and
> filemap_fault().  update_page_reclaim_stat() does spin_lock_irq() and
> spin_unlock_irq().  It looks like a net slowdown to me.

Ah, I compared with the code before Nick's mark_page_accessed() removing.
but you don't.

but I agree this patch reduce the worth of nick's work.
I have to improve more.

> > But I agree its lock can be removed maybe..
> 
> It would be nice to try to do something about it - every little bit
> counts.

Yes. I can't opoose it.




