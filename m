Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZCMCDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZCMCDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZCMCDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:03:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50150 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZCMCDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:03:08 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Cc: kosaki.motohiro@jp.fujitsu.com, David Howells <dhowells@redhat.com>,
       torvalds@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090312124323.ad0dbd68.akpm@linux-foundation.org>
References: <24030.1236860724@redhat.com> <20090312124323.ad0dbd68.akpm@linux-foundation.org>
Message-Id: <20090313105618.43DF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 11:03:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > Which as Peter points out:
> > 
> > 	The ramfs stuff is rather icky in that it adds the pages to the aging
> > 	list, marks them dirty, but does not provide a writeout method. 
> > 
> > 	This will make the paging code scan over them (continuously) trying to
> > 	clean them, failing that (lack of writeout method) and putting them back
> > 	on the list.
> > 
> > Not requiring the pages to be added to the LRU would be a really good idea.
> > They are not discardable, be it in MMU or NOMMU mode, except when the inode
> > itself is discarded.
> 
> Yep, these pages shouldn't be on the LRU at all.  I guess that will
> require some tweaks to core filemap.c code.

IMHO, UNEVICTABLE_LRU already does lru isolation.
only rest prblem is, getting rid of "depends on MMU" line in mm/Kconfig.

Am I missing anything?




