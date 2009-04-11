Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZDKSzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZDKSzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 14:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbZDKSzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 14:55:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756290AbZDKSzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 14:55:44 -0400
Date: Sat, 11 Apr 2009 11:49:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       lpk@581.spb.su, wli@movementarian.org, torvalds@linux-foundation.org,
       yinghan@google.com, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 6/9] readahead: clean up and simplify the code for
 filemap  page fault readahead
Message-Id: <20090411114920.b9d2493c.akpm@linux-foundation.org>
In-Reply-To: <2f11576a0904110658i4c595f49odbaefda8f8fa95d@mail.gmail.com>
References: <20090410060957.442203404@intel.com>
	<20090410061254.530720232@intel.com>
	<20090410164803.0c6cc25d.akpm@linux-foundation.org>
	<2f11576a0904110658i4c595f49odbaefda8f8fa95d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 22:58:31 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > Ah. __But I have a note here that I didn't like it, because it adds lots
> > of new spinlocking to fastpaths. __So I'll leave things as they stand
> > until we have had a little talk about that.
> 
> add?
> 
> old code: grab zone->lru_lock via mark_page_accessed()
> new code: grab zone->lru_lock via update_reclaim_stat()
> 
> one remove, one add.
> 

mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch adds
new calls to update_page_reclaim_stat() into do_swap_page() and
filemap_fault().  update_page_reclaim_stat() does spin_lock_irq() and
spin_unlock_irq().  It looks like a net slowdown to me.

> But I agree its lock can be removed maybe..

It would be nice to try to do something about it - every little bit
counts.

