Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbZCMIXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbZCMIXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbZCMIPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:15:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41251 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbZCMIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:15:49 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1236931036.5188.80.camel@laptop>
References: <20090313105618.43DF.A69D9226@jp.fujitsu.com> <1236931036.5188.80.camel@laptop>
Message-Id: <20090313170058.6840.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 17:15:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > 	The ramfs stuff is rather icky in that it adds the pages to the aging
> > > > 	list, marks them dirty, but does not provide a writeout method. 
> > > > 
> > > > 	This will make the paging code scan over them (continuously) trying to
> > > > 	clean them, failing that (lack of writeout method) and putting them back
> > > > 	on the list.
> > > > 
> > > > Not requiring the pages to be added to the LRU would be a really good idea.
> > > > They are not discardable, be it in MMU or NOMMU mode, except when the inode
> > > > itself is discarded.
> > > 
> > > Yep, these pages shouldn't be on the LRU at all.  I guess that will
> > > require some tweaks to core filemap.c code.
> > 
> > IMHO, UNEVICTABLE_LRU already does lru isolation.
> > only rest prblem is, getting rid of "depends on MMU" line in mm/Kconfig.
> > 
> > Am I missing anything?
> 
> Yes, the need to take something off that shouldn't be there to begin
> with.

In past unevictable lru discussion, we discuss the same thing.
at that time, we found two reason of unevictable lru is better than 
completely taking off.

(1) page migration code depend on the page stay on lru.
(2) "taking off at reclaim time" can avoid adding lock to fastpath.
    anyway, complely removing from lru need something lock.
    we disliked it at that time.

So, I think it is still true.
Of cource, better cool solution is always welcome :)




