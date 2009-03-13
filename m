Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZCMH6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZCMH6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZCMH5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:57:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZCMH5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:57:48 -0400
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache
 may get wrongly discarded
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090313105618.43DF.A69D9226@jp.fujitsu.com>
References: <24030.1236860724@redhat.com>
	 <20090312124323.ad0dbd68.akpm@linux-foundation.org>
	 <20090313105618.43DF.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 08:57:16 +0100
Message-Id: <1236931036.5188.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 11:03 +0900, KOSAKI Motohiro wrote:
> Hi
> 
> > > Which as Peter points out:
> > > 
> > > 	The ramfs stuff is rather icky in that it adds the pages to the aging
> > > 	list, marks them dirty, but does not provide a writeout method. 
> > > 
> > > 	This will make the paging code scan over them (continuously) trying to
> > > 	clean them, failing that (lack of writeout method) and putting them back
> > > 	on the list.
> > > 
> > > Not requiring the pages to be added to the LRU would be a really good idea.
> > > They are not discardable, be it in MMU or NOMMU mode, except when the inode
> > > itself is discarded.
> > 
> > Yep, these pages shouldn't be on the LRU at all.  I guess that will
> > require some tweaks to core filemap.c code.
> 
> IMHO, UNEVICTABLE_LRU already does lru isolation.
> only rest prblem is, getting rid of "depends on MMU" line in mm/Kconfig.
> 
> Am I missing anything?

Yes, the need to take something off that shouldn't be there to begin
with.

