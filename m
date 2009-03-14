Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZCNObw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZCNObw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 10:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZCNObm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 10:31:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33119 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbZCNObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 10:31:41 -0400
Date: Sat, 14 Mar 2009 23:29:05 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may get wrongly discarded
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090313104442.GB2119@cmpxchg.org>
References: <20090313170058.6840.A69D9226@jp.fujitsu.com> <20090313104442.GB2119@cmpxchg.org>
Message-Id: <20090314232411.4495.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > (1) page migration code depend on the page stay on lru.
> > (2) "taking off at reclaim time" can avoid adding lock to fastpath.
> >     anyway, complely removing from lru need something lock.
> >     we disliked it at that time.
> 
> Agreed with (1).  NOMMU can't support migration, though.  But keeping
> them off the LRU on NOMMU needs adjustment of the page cache
> read/write code in mm/filemap.c.

yes.

> I'm not quite sure I understand (2).  But never adding these pages on
> the LRU means we never have to remove them anywhere, no?

Yeah, you are right.
I was confused to munlock/shm_unlock case.



