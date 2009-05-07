Return-Path: <linux-kernel-owner+w=401wt.eu-S1760396AbZEGQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760396AbZEGQnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZEGQnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:43:31 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:45113 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752299AbZEGQna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:43:30 -0400
Date: Thu, 7 May 2009 12:32:40 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class
 citizen
In-Reply-To: <1241712000.18617.7.camel@lts-notebook>
Message-ID: <alpine.DEB.1.10.0905071231090.10171@qirst.com>
References: <20090430072057.GA4663@eskimo.com>  <20090430174536.d0f438dd.akpm@linux-foundation.org>  <20090430205936.0f8b29fc@riellaptop.surriel.com>  <20090430181340.6f07421d.akpm@linux-foundation.org>  <20090430215034.4748e615@riellaptop.surriel.com> 
 <20090430195439.e02edc26.akpm@linux-foundation.org>  <49FB01C1.6050204@redhat.com>  <20090501123541.7983a8ae.akpm@linux-foundation.org>  <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>  <20090507121101.GB20934@localhost> 
 <alpine.DEB.1.10.0905070935530.24528@qirst.com>  <1241705702.11251.156.camel@twins>  <alpine.DEB.1.10.0905071016410.24528@qirst.com> <1241712000.18617.7.camel@lts-notebook>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Lee Schermerhorn wrote:

> > Another possibility may be to put the exec pages on the mlock list
> > and scan the list if under extreme duress?
>
> Actually, you don't need to go thru the overhead of mucking with the
> PG_mlocked flag which incurs the rmap walk on unlock, etc.  If one sets
> the the AS_UNEVICTABLE flag, the pages will be shuffled off the the
> unevictable LRU iff we ever try to reclaim them.  And, we do have the
> function to scan the unevictable lru to "rescue" pages in a given
> mapping should we want to bring them back under extreme load.  We'd need
> to remove the AS_UNEVICTABLE flag, first.  This is how
> SHM_LOCK/SHM_UNLOCK works.

We need some way to control this. If there would be a way to simply switch
off eviction of exec pages (via /proc/sys/vm/never_reclaim_exec_pages or
so) I'd use it.


