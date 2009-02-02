Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbZBBWOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbZBBWOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBBWOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:14:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751598AbZBBWOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:14:34 -0500
Date: Mon, 2 Feb 2009 14:12:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <20090202215042.GD9840@csn.ul.ie>
Message-ID: <alpine.LFD.2.00.0902021410460.3247@localhost.localdomain>
References: <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0902021215060.18750@blonde.anvils> <20090202224410.EC95.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090202185810.GC9840@csn.ul.ie> <alpine.LFD.2.00.0902021121120.3247@localhost.localdomain>
 <20090202215042.GD9840@csn.ul.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Feb 2009, Mel Gorman wrote:
> 
> Lets say someone does the following
> 
> 1. mmap(PROT_READ, MAP_PRIVATE) on a hugetlbfs file
> 	VM_ACCOUNT is not set for hugetlbfs
> 	VM_NORESERVE is not set because MAP_NORESERVE was not there

But isn't this exactly the thing that we have that odd "accountable" flag 
for, and we do the whole

	if (!accountable)
		vm_flags |= VM_NORESERVE;

in mmap_region() for?

So VM_NORESERVE _will_ be set.

				Linus
