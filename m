Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZBZRk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZBZRk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZBZRkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:40:19 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:44283 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751430AbZBZRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:40:18 -0500
Date: Thu, 26 Feb 2009 12:30:45 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       penberg@cs.helsinki.fi, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       hannes@cmpxchg.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 20/20] Get rid of the concept of hot/cold page freeing
In-Reply-To: <20090226171549.GH32756@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0902261226370.26440@qirst.com>
References: <1235344649-18265-21-git-send-email-mel@csn.ul.ie> <20090223013723.1d8f11c1.akpm@linux-foundation.org> <20090223233030.GA26562@csn.ul.ie> <20090223155313.abd41881.akpm@linux-foundation.org> <20090224115126.GB25151@csn.ul.ie>
 <20090224160103.df238662.akpm@linux-foundation.org> <20090225160124.GA31915@csn.ul.ie> <20090225081954.8776ba9b.akpm@linux-foundation.org> <20090226163751.GG32756@csn.ul.ie> <alpine.DEB.1.10.0902261157100.7472@qirst.com> <20090226171549.GH32756@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Mel Gorman wrote:

> > I tried the general use of a pool of zeroed pages back in 2005. Zeroing
> > made sense only if the code allocating the page did not immediately touch
> > the cachelines of the page.
>
> Any feeling as to how often this was the case?

Not often enough to justify the merging of my patches at the time. This
was publicly discussed on lkml:

http://lkml.indiana.edu/hypermail/linux/kernel/0503.2/0482.html

> Indeed, any gain if it existed would be avoiding zeroing the pages used
> by userspace. The cleanup would be reducing the amount of
> architecture-specific code.
>
> I reckon it's worth an investigate but there is still other lower-lying
> fruit.

I hope we can get rid of various ugly elements of the quicklists if the
page allocator would offer some sort of support. I would think that the
slow allocation and freeing behavior is also a factor that makes
quicklists advantageous. The quicklist page lists are simply a linked list
of pages and a page can simply be dequeued and used.


