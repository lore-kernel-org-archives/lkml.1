Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZKQMrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZKQMrO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbZKQMrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:47:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbZKQMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:47:10 -0500
Date: Tue, 17 Nov 2009 07:47:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
Message-ID: <20091117124715.GA22834@infradead.org>
References: <20091117192232.3DF9.A69D9226@jp.fujitsu.com> <20091117102701.GA16472@infradead.org> <20091117212327.3E08.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117212327.3E08.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 09:24:24PM +0900, KOSAKI Motohiro wrote:
> > On Tue, Nov 17, 2009 at 07:24:42PM +0900, KOSAKI Motohiro wrote:
> > > if xfsbufd doesn't only write out dirty data but also drop page,
> > > I agree you. 
> > 
> > It then drops the reference to the buffer which drops references to the
> > pages, which often are the last references, yes.
> 
> I though it is not typical case. Am I wrong?
> if so, I'm sorry. I'm not XFS expert.

I think in the typical case it's the last reference.  The are two
reasons why it might not be:

 - we're on a filesystem with block size < page size in which case two
   buffers can share a page and we'd need to write out and release both
   buffers to free the page
 - someone else might have a reference on the buffer.  Offhand I can't
   remember a place where we do this for delayed write buffers (which
   is what xfsbufd writes out) as it would be a bit against the purpose
   of those delayed write buffers.

