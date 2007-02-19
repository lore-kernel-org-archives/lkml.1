Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbXBSAp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbXBSAp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXBSAp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:45:28 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:39533 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbXBSAp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:45:27 -0500
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <E1HIwLJ-0005N4-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Mon, 19 Feb 2007 01:25:21 +0100)
Subject: Re: dirty balancing deadlock
References: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu>
	<20070218125307.4103c04a.akpm@linux-foundation.org>
	<E1HIurG-0005Bw-00@dorka.pomaz.szeredi.hu>
	<20070218145929.547c21c7.akpm@linux-foundation.org>
	<E1HIvMB-0005Fd-00@dorka.pomaz.szeredi.hu> <20070218155916.0d3c73a9.akpm@linux-foundation.org> <E1HIwLJ-0005N4-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HIweQ-0005RQ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 Feb 2007 01:45:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > If so, writes to B will decrease the dirty memory threshold.
> > > 
> > > Yes, but not by enough.  Say A dirties a 1100 pages, limit is 1000.
> > > Some pages queued for writeback (doesn't matter how much).  B writes
> > > back 1, 1099 dirty remain in A, zero in B.  balance_dirty_pages() for
> > > B doesn't know that there's nothing more to write back for B, it's
> > > just waiting there for those 1099, which'll never get written.
> > 
> > hm, OK, arguable.  I guess something like this..
> 
> Doesn't help the fuse case, but does seem to help the loopback mount
> one.

No sorry, it doesn't even help the loopback deadlock.  It sometimes
takes quite a while to trigger...

Miklos
