Return-Path: <linux-kernel-owner+w=401wt.eu-S1761759AbZEMXpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761759AbZEMXpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbZEMXpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:45:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49812 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZEMXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:45:34 -0400
Date: Thu, 14 May 2009 08:44:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, balbir@in.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] memcg: fix deadlock between lock_page_cgroup
 and mapping tree_lock
Message-Id: <20090514084401.0ec3432f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090513115626.57844f28.akpm@linux-foundation.org>
References: <20090513133031.f4be15a8.nishimura@mxp.nes.nec.co.jp>
	<20090513115626.57844f28.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 11:56:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

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
Ah, yes. Special debug option to this can be allowed ?
CONFIG_DEBUG_MEM_CGROUP_SPINLOCK or some.

Thanks,
-Kame

