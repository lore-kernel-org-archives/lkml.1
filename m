Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbXBSBPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbXBSBPG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 20:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXBSBPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 20:15:06 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52427 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXBSBPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 20:15:05 -0500
To: chris.mason@oracle.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-reply-to: <20070219010102.GC9289@think.oraclecorp.com> (message from Chris
	Mason on Sun, 18 Feb 2007 20:01:02 -0500)
Subject: Re: dirty balancing deadlock
References: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu> <20070218125307.4103c04a.akpm@linux-foundation.org> <E1HIurG-0005Bw-00@dorka.pomaz.szeredi.hu> <20070218145929.547c21c7.akpm@linux-foundation.org> <E1HIvMB-0005Fd-00@dorka.pomaz.szeredi.hu> <20070218155916.0d3c73a9.akpm@linux-foundation.org> <E1HIwLJ-0005N4-00@dorka.pomaz.szeredi.hu> <20070219004537.GB9289@think.oraclecorp.com> <E1HIwnX-0005Sr-00@dorka.pomaz.szeredi.hu> <20070219010102.GC9289@think.oraclecorp.com>
Message-Id: <E1HIx6d-0005V4-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 Feb 2007 02:14:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > In general, writepage is supposed to do work without blocking on
> > > expensive locks that will get pdflush and dirty reclaim stuck in this
> > > fashion.  You'll probably have to take the same approach reiserfs does
> > > in data=journal mode, which is leaving the page dirty if fuse_get_req_wp
> > > is going to block without making progress.
> > 
> > Pdflush, and dirty reclaim set wbc->nonblocking to true.
> > balance_dirty_pages and fsync don't.  The problem here is that
> > Andrew's patch is wrong to let balance_dirty_pages() try to write back
> > pages from a different queue.
> 
> async or sync, writepage is supposed to either make progress or bail.
> loopback aside, if the fuse call is blocking long term, you're going to
> run into problems.

Hmm, like what?

Thanks,
Miklos
