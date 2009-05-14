Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbZENC6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbZENC6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761774AbZENC6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:58:00 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50577 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbZENC6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:58:00 -0400
Date: Thu, 14 May 2009 07:18:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] memcg: fix deadlock between
	lock_page_cgroupand mapping tree_lock
Message-ID: <20090514014801.GS13394@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090513133031.f4be15a8.nishimura@mxp.nes.nec.co.jp> <20090513115626.57844f28.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090513115626.57844f28.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-05-13 11:56:26]:

> On Wed, 13 May 2009 13:30:31 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > mapping->tree_lock can be aquired from interrupt context.
> > Then, following dead lock can occur.
> > 
> > Assume "A" as a page.
> > 
> >  CPU0:
> >        lock_page_cgroup(A)
> > 		interrupted
> > 			-> take mapping->tree_lock.
> >  CPU1:
> >        take mapping->tree_lock
> > 		-> lock_page_cgroup(A)
> 
> And we didn't find out about this because lock_page_cgroup() uses
> bit_spin_lock(), and lockdep doesn't handle bit_spin_lock().
> 
> It would perhaps be useful if one of you guys were to add a spinlock to
> struct page, convert lock_page_cgroup() to use that spinlock then run a
> full set of tests under lockdep, see if it can shake out any other bugs.
>

May be under DEBUG_VM we could do that. Good suggestion! 

-- 
	Balbir
