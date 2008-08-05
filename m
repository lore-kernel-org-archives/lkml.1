Return-Path: <linux-kernel-owner+w=401wt.eu-S1763542AbYHERx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763542AbYHERx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763393AbYHERxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:53:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60608 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761710AbYHERxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:53:40 -0400
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebmunson@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net,
       abh@cray.com
In-Reply-To: <20080805162800.GJ20243@csn.ul.ie>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	 <20080730014308.2a447e71.akpm@linux-foundation.org>
	 <20080730172317.GA14138@csn.ul.ie>
	 <20080730103407.b110afc2.akpm@linux-foundation.org>
	 <20080730193010.GB14138@csn.ul.ie>
	 <20080730130709.eb541475.akpm@linux-foundation.org>
	 <20080731103137.GD1704@csn.ul.ie> <1217884211.20260.144.camel@nimitz>
	 <20080805111147.GD20243@csn.ul.ie> <1217952748.10907.18.camel@nimitz>
	 <20080805162800.GJ20243@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 10:53:25 -0700
Message-Id: <1217958805.10907.45.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 17:28 +0100, Mel Gorman wrote:
> Ok sure, you could do direct inserts for MAP_PRIVATE as conceptually it
> suits this patch.  However, I don't see what you gain. By reusing hugetlbfs,
> we get things like proper reservations which we can do for MAP_PRIVATE these
> days. Again, we could call that sort of thing directly if the reservation
> layer was split out separate from hugetlbfs but I still don't see the gain
> for all that churn.
> 
> What am I missing?

This is good for getting us incremental functionality.  It is probably
the smallest amount of code to get it functional.

My concern is that we're going down a path that all large page usage
should be through the one and only filesystem.  Once we establish that
dependency, it is going to be awfully hard to undo it; just think of all
of the inherent behavior in hugetlbfs.  So, we better be sure that the
filesystem really is the way to go, especially if we're going to start
having other areas of the kernel depend on it internally.

That said, this particular patch doesn't appear *too* bound to hugetlb
itself.  But, some of its limitations *do* come from the filesystem,
like its inability to handle VM_GROWS...  

-- Dave

