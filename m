Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbXJIATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbXJIATn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 20:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbXJIATf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 20:19:35 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:44571 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752619AbXJIATf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 20:19:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MPH79EZWB9PbbG7xvZ9qYAFqJzxNnRQtNOL9ZYIMRw0FRRw4EL82Z+PgGgEIP8UoCjpAfJt7DQ5oRZR/pBe2OZY1+UrVEgja0kSh5T/ViIM8aXCVzewuk1Ix2BgltZRP6b5I0m2KB35cR5r9NbRHXVjMbGHoao66XPHrUq0REns=  ;
X-YMail-OSG: rcryQ5UVM1mviAkmno23G3X4hidPxJY5xkO_JlBZGd_7TkXaS9Z5eohuqzaEuobCbMCjjqSpSQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] mm: set_page_dirty_balance() vs ->page_mkwrite()
Date: Mon, 8 Oct 2007 17:47:52 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, mark.fasheh@oracle.com,
       hugh <hugh@veritas.com>, stable <stable@kernel.org>
References: <1191862477.20745.22.camel@twins> <200710081637.01122.nickpiggin@yahoo.com.au> <20071008233637.GF995458@sgi.com>
In-Reply-To: <20071008233637.GF995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710081747.52627.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 09:36, David Chinner wrote:
> On Mon, Oct 08, 2007 at 04:37:00PM +1000, Nick Piggin wrote:
> > On Tuesday 09 October 2007 02:54, Peter Zijlstra wrote:

> > > Force a balance call if ->page_mkwrite() was successful.
> >
> > Would it be better to just have the callers set_page_dirty_balance()?
>
> block_page_mkwrite() is just using generic interfaces to do this,
> same as pretty much any write() system call. The idea was to make it
> as similar to the write() call path as possible...
>
> However, unlike generic_file_buffered_write(), we are not calling
> balance_dirty_pages_ratelimited(mapping) between
> ->prepare/commit_write call pairs.  Perhaps this should be added to
> block_page_mkwrite() after the page is unlocked....

That sounds pretty sane, in terms of matching with
generic_file_buffered_write.
