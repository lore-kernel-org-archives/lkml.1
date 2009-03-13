Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbZCMH5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbZCMH5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZCMH5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:57:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:43444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbZCMH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:56:59 -0400
Subject: Re: [uClinux-dev] RE: [PATCH] NOMMU: Pages allocated to a ramfs
 inode's pagecache may get wrongly discarded
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       uClinux development list <uclinux-dev@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090313082051.5eaa11a3.minchan.kim@barrios-desktop>
References: <20090311153034.9389.19938.stgit@warthog.procyon.org.uk>
	 <20090311170840.2f136849.akpm@linux-foundation.org>
	 <5DC5324CE00E4D4494EE5F031E354E9501CE9C0F@BUDMLVEM03.e2k.ad.ge.com>
	 <20090312112953.GD6995@shareable.org> <1236858608.22914.3689.camel@twins>
	 <20090313082051.5eaa11a3.minchan.kim@barrios-desktop>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 08:56:25 +0100
Message-Id: <1236930985.5188.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 08:20 +0900, Minchan Kim wrote:

> > > Does the vm pageout logic include or skip these "dirty" pages looking
> > > for candidates to flush to storage?  What about with MMU?
> > 
> > Includes them, regular pageout will try to do the writeout to clean them
> > and then discard them. 
> > 
> > The ramfs stuff is rather icky in that it adds the pages to the aging
> > list, marks them dirty, but does not provide a writeout method. 
> > 
> > This will make the paging code scan over them (continuously) trying to
> > clean them, failing that (lack of writeout method) and putting them back
> > on the list.
> 
> It ins't true any more. 
> UNEVICTABLE_LRU will move ramfs's page from LRU to unevictable list.
> Couldn't we solve this problem if NOMMU can support CONFIG_UNEVICTABLE_LRU ?

That's more of a band-aid than a solution, no? They should never have
been on the list to begin with.

