Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbZFWWUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbZFWWUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZFWWT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:19:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56299 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZFWWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:19:55 -0400
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: akataria@vmware.com
Cc: Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1245794811.24110.41.camel@alok-dev1>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com>
	 <1245732411.18339.6.camel@alok-dev1>
	 <20090623135017.220D.A69D9226@jp.fujitsu.com>
	 <20090623141147.8f2cef18.kamezawa.hiroyu@jp.fujitsu.com>
	 <1245736441.18339.21.camel@alok-dev1>  <4A41481D.1060607@redhat.com>
	 <1245793331.24110.33.camel@alok-dev1>  <4A414F55.2040808@redhat.com>
	 <1245794811.24110.41.camel@alok-dev1>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 15:19:55 -0700
Message-Id: <1245795595.17685.31320.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 15:06 -0700, Alok Kataria wrote:
> What i meant was that you could always calculate the *maximum* amount of
> memory that is going to be used by page table and can also determine the
> % of memory that will be used by slab caches. 

I'm not really sure what you mean by this.  I actually just wrote a
little userspace program the other day that fills virtually all of ram
in with pagetables.  There's no real upper bound on them, unless you're
restricting the amount of mapped space that all the userspace processes
determine.  In the same way, the right usage pattern can give virtually
all the RAM in the system and put it in a single or set of slabs.  It's
probably evictable most of the time, but sometimes large amounts can be
pinned.

> So that ways you should be statically able to tell that no more than 'X'
> amount of memory is going to be locked here.
> Will again like to stress that "X" is not the exact amount that is
> locked here but the one which can be. 
> 
> OTOH, for hugepages and mlocked pages you need to read the exact counts
> as this can change according to user selection. 

I'm a bit lost.  Could we take a step back here and talk about what
you're trying to do in the first place?

-- Dave

