Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXJICPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXJICPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 22:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXJICPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 22:15:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15722 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbXJICPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 22:15:10 -0400
Date: Mon, 8 Oct 2007 19:12:54 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, hugh <hugh@veritas.com>,
       stable <stable@kernel.org>
Subject: Re: [PATCH] mm: set_page_dirty_balance() vs ->page_mkwrite()
Message-ID: <20071009021253.GC30360@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <1191862477.20745.22.camel@twins> <200710081637.01122.nickpiggin@yahoo.com.au> <20071008233637.GF995458@sgi.com> <200710081747.52627.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710081747.52627.nickpiggin@yahoo.com.au>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 05:47:52PM +1000, Nick Piggin wrote:
> > block_page_mkwrite() is just using generic interfaces to do this,
> > same as pretty much any write() system call. The idea was to make it
> > as similar to the write() call path as possible...
> >
> > However, unlike generic_file_buffered_write(), we are not calling
> > balance_dirty_pages_ratelimited(mapping) between
> > ->prepare/commit_write call pairs.  Perhaps this should be added to
> > block_page_mkwrite() after the page is unlocked....
> 
> That sounds pretty sane, in terms of matching with
> generic_file_buffered_write.

I agree. We could also insert a call to balance_dirty_pages_ratelimited() in
__ocfs2_page_mkwrite.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
