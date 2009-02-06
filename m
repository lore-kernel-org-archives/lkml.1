Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZBFLvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZBFLvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZBFLvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:51:23 -0500
Received: from cmpxchg.org ([85.214.51.133]:46678 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZBFLvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:51:22 -0500
Date: Fri, 6 Feb 2009 12:50:46 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: MinChan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Message-ID: <20090206115045.GA1580@cmpxchg.org>
References: <20090206031125.693559239@cmpxchg.org> <20090206031324.004715023@cmpxchg.org> <20090206080354.GA6516@barrios-desktop> <28c262360902060206h78c15a1dsf52b481c5cc1bc74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28c262360902060206h78c15a1dsf52b481c5cc1bc74@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 07:06:34PM +0900, MinChan Kim wrote:
> On Fri, Feb 6, 2009 at 5:03 PM, MinChan Kim <minchan.kim@gmail.com> wrote:
> >> Another reason for preferring file page eviction is that the locality
> >> principle is visible in fault patterns and swap might perform really
> >> bad with subsequent faulting of contiguously mapped pages.
> >
> > Why do you think that swap might perform bad with subsequent faulting
> > of contiguusly mapped page ?
> > You mean normal file system is faster than swap due to readahead and
> > smart block of allocation ?
> 
> But, I still can't understand this issue.
> what mean "page eviction" ? Is it reclaim or swap out ?

Reclaim evicts pages from memory by swap out (and writeback).

In the suspend case, "reclaim" is perhaps not 100% correct.  We are
not directly interested in the amount of free pages as you are with
reclaim, but interested in the amount of pages in use as those are the
pages we have to write to disk.  So "shrinking" is the better term.

But yes, I mean what you said:

	You mean normal file system is faster than swap due to
	readahead and smart block of allocation ?

Yes.

	Hannes
