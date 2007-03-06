Return-Path: <linux-kernel-owner+w=401wt.eu-S1030427AbXCFWhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030427AbXCFWhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030420AbXCFWhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:37:41 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:57587 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030410AbXCFWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:37:40 -0500
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, staubach@redhat.com, hugh@veritas.com
In-reply-to: <1173220101.6374.118.camel@twins> (message from Peter Zijlstra on
	Tue, 06 Mar 2007 23:28:21 +0100)
Subject: Re: [patch 2/8] update ctime and mtime for mmaped write
References: <20070306180443.669036741@szeredi.hu>
	 <20070306180549.312408559@szeredi.hu> <1173213151.4718.16.camel@lappy>
	 <E1HOh8r-0006Sp-00@dorka.pomaz.szeredi.hu> <1173217621.4718.27.camel@lappy>
	 <1173218843.4718.38.camel@lappy> <E1HOhzG-0006bd-00@dorka.pomaz.szeredi.hu> <1173220101.6374.118.camel@twins>
Message-Id: <E1HOiGt-0006f3-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 Mar 2007 23:36:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > AS_CMTIME is only for the case, when the "file modified since the last
> > msync" info is lost from the ptes, e.g. because of page reclaim.
> > 
> > So it doesn't matter if AS_CMTIME is not set, is_page_modified() will
> > provide the necessary barrier.
> 
> The trouble is, we went from a pull to a push model, and now you're
> adding pull code again.
> 
> We have PG_dirty correct at all times, I think its no less reasonable to
> have AS_CMTIME correct in the same fashion.

There's a very important difference.  PG_dirty correctness is needed,
because the _number_ of dirty pages needs to be accounted.  But there
is no such requirement for AS_CMTIME, nobody cares _how_many_ pages
have been modified since the last msync() call.  All we need to know
is _if_ the file has been modified or not.

Thanks,
Miklos
