Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbXHBTfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbXHBTfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbXHBTfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:35:38 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:45509 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbXHBTfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:35:37 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, kenchen@google.com, peterz@infradead.org
In-reply-to: <20070802121806.d7071ba1.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 2 Aug 2007 12:18:06 -0700)
Subject: Re: kupdate weirdness
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
	<20070801141439.ff1c29f9.akpm@linux-foundation.org>
	<E1IGcyd-00025s-00@dorka.pomaz.szeredi.hu> <20070802121806.d7071ba1.akpm@linux-foundation.org>
Message-Id: <E1IGgS3-0002ib-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Aug 2007 21:35:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There were heaps of problems in there and it is surprising how few people
> were hitting them.  Ordered-mode journalling filesystems will fix it all up
> behind the scenes, of course.
> 
> I just have a bad feeling about that code - list_heads are the wrong data
> structure and it all needs to be ripped and redone using some indexable
> data structure.  There has been desultory discussion, but nothing's
> happening and nothing will happen in the medium term, so we need to keep
> on whapping bandainds on it.

The reason why I'm looking at that code is because of those
balance_dirty_pages() deadlocks.  I'm not perfectly happy with the
per-pdi-per-cpu counters Peter's patch is introducing.

I was wondering if we can count the number of writeback pages through
the radix tree, just like we do for dirty pages?

All that would be needed is to keep the under-writeback inodes on some
list as well.

But I realize, that this introduces it's own problems as well...

Miklos
