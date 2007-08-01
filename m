Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbXHAI2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbXHAI2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbXHAI1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:27:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbXHAI1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:27:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1185949055.12034.31.camel@twins>
References: <1185949055.12034.31.camel@twins> <20070731202454.6412.88646.stgit@warthog.cambridge.redhat.com> <20070731202505.6412.37918.stgit@warthog.cambridge.redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] FS-Cache: Recruit a couple of page flags for cache management
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 01 Aug 2007 09:27:13 +0100
Message-ID: <17631.1185956833@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> Not sure its a good idea to overload page_has_private() with an
> overloadable page-flag. What if some future FS wants to use
> PG_owner_priv_2 for other purposes?

All that it means is that releasepage() and co will get called if a page is to
be released or invalidated that has that bit set.  I think that's something a
future FS could probably live with.

However, I do have to trigger a call to releasepage() and co *somehow*.

> Obviously filesystems cannot use these two page-flags if they want to be
> compatible with FS-cache, but need all filesystems be?

What do you mean?  That's why I went for the PG_owner_priv_* approach rather
than just naming the bits unto FS-Cache directly.

> (also, ouch! - 2 pageflags)

Yeah.  The consequence of having things asynchronous is that you have to find
signalling mechanisms to synchronise around the asynchronicity:-/

Furthermore, it occurs to me that I can't use PG_private or page->private to
store this information because I want to make isofs use caching, and those two
pieces of information are owned by the buffering code.

David
