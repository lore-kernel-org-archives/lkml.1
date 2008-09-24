Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbYIXTXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbYIXTXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYIXTXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:23:25 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56722 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYIXTXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:23:24 -0400
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in
	/proc/pid/smaps
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, agl@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <20080924191107.GA31324@csn.ul.ie>
References: <20080923211140.DC16.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080923194655.GA25542@csn.ul.ie>
	 <20080924210309.8C3B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080924154120.GA10837@csn.ul.ie> <1222272395.15523.3.camel@nimitz>
	 <20080924171003.GD10837@csn.ul.ie> <1222282749.15523.59.camel@nimitz>
	 <20080924191107.GA31324@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 12:23:10 -0700
Message-Id: <1222284190.15523.64.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 20:11 +0100, Mel Gorman wrote:
> I don't get what you mean by it being sprinkled in each smaps file. How
> would you present the data?

1. figure out what the file path is from smaps
2. look up the mount
3. look up the page sizes from the mount's information

> > We should be able to figure out which
> > mount the file is from and, from there, maybe we need some per-mount
> > information exported.  
> 
> Per-mount information is already exported and you can infer the data about
> huge pagesizes. For example, if you know the default huge pagesize (from
> /proc/meminfo), and the file is on hugetlbfs (read maps, then /proc/mounts)
> and there is no pagesize= mount option (mounts again), you could guess what the
> hugepage that is backing a VMA is. Shared memory segments are a little harder
> but again, you can infer the information if you look around for long enough.
> 
> However, this is awkward and not very user-friendly. With the patches (minus
> MMUPageSize as I think we've agreed to postpone that), it's easy to see what
> pagesize is being used at a glance. Without it, you need to know a fair bit
> about hugepages are implemented in Linux to infer the information correctly.

I agree completely.  But, if we consider this a user ABI thing, then
we're stuck with it for a long time, and we better make it flexible
enough to at least contain the gunk we're planning on adding in a small
number of years, like the fallback.  We don't want to be adding this
stuff if it isn't going to be stable.

-- Dave

