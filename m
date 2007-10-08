Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXJIHfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXJIHfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 03:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXJIHfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 03:35:42 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:42186 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753058AbXJIHfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 03:35:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4UHdDU8zlshUBJyiULy3b1oNFZdGnMFYmeto4ego6TAlQLNsMtpFF+Hgg8OBg12uxMKOMEmrzzv/QNS97AGAWyRfEhezUbJzBVhbxIV8v4KCq8U0t/drdJayb4lWOEKdxQB8+OnkWtlzBfXWmQEtyruW/+OelVpH+KRz5uit8Ys=  ;
X-YMail-OSG: y0Gjx1sVM1nT7VKYjqpRemyNOzAEIFZJWrUv5AxYfkixbhhMxiieUvJB6PX8b8woOTMuD5o8Sw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH] mm: set_page_dirty_balance() vs ->page_mkwrite()
Date: Tue, 9 Oct 2007 00:50:04 +1000
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, hugh <hugh@veritas.com>,
       stable <stable@kernel.org>
References: <1191862477.20745.22.camel@twins> <200710081747.52627.nickpiggin@yahoo.com.au> <20071009021253.GC30360@ca-server1.us.oracle.com>
In-Reply-To: <20071009021253.GC30360@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090050.05059.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 12:12, Mark Fasheh wrote:
> On Mon, Oct 08, 2007 at 05:47:52PM +1000, Nick Piggin wrote:
> > > block_page_mkwrite() is just using generic interfaces to do this,
> > > same as pretty much any write() system call. The idea was to make it
> > > as similar to the write() call path as possible...
> > >
> > > However, unlike generic_file_buffered_write(), we are not calling
> > > balance_dirty_pages_ratelimited(mapping) between
> > > ->prepare/commit_write call pairs.  Perhaps this should be added to
> > > block_page_mkwrite() after the page is unlocked....
> >
> > That sounds pretty sane, in terms of matching with
> > generic_file_buffered_write.
>
> I agree. We could also insert a call to balance_dirty_pages_ratelimited()
> in __ocfs2_page_mkwrite.

Hmm, Peter's patch got merged -- I suppose that's fine for 2.6.23 though...

