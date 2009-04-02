Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbZDBRIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbZDBRIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762436AbZDBRIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:08:05 -0400
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:47194 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760214AbZDBRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:08:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sb/61XmmMXL4uNx/JtJt9ZVVoGOmxH01x83aUVaglO0DhAPYlXION3V1sYfCxJ9z1v4Szpq5Bw8aPnOi6Y3TRzV9EyYKFaR1w8lrcBVqXRiBW4iTivlBasAaWRbavJ9/t8xeDRAVd4UTeDMBNq1AEHYlE5j4B5T9Hrte6qZ4ss0=  ;
X-YMail-OSG: 1r9YCY4VM1nuAxDIYxOG44cw2IKrMsBfxBWzrOs2jWHag1qoYNawJSEyscJyH5HtVl_3hzACEI7S7h0b0L7nRG3dvlF0AbV2ug4EITU2G_aRZdxXa4cnbfpUC0PMAbImj2DzRuZYfGP70VfNFCNrcnlurIbioP9LzurOhbhJkC1QP9CMVkQsFECs3Enhw7q7n9fCrEFIbAR_3msppGytZV3ZbJfDjhDxHZ0xWn9B_uHZcuARrhdaXZq0EdpEVnNXsPH4QmSOyqIPkXmOOuWWfr_lAif8vdIL5dy.X_ALNsC83O4qitlA
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Fri, 3 Apr 2009 04:07:54 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <200904030100.05741.nickpiggin@yahoo.com.au> <200904030347.21470.nickpiggin@yahoo.com.au> <20090402165505.GA21859@infradead.org>
In-Reply-To: <20090402165505.GA21859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904030407.55471.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 April 2009 03:55:05 Christoph Hellwig wrote:
> On Fri, Apr 03, 2009 at 03:47:20AM +1100, Nick Piggin wrote:
> > Well they now are quite well filesystem defined. We no longer take
> > the page lock before calling them. Not saying it's perfect, but if
> > the backing fs is just using a known subset of ones that work
> > (like loop does).
> 
> The page lock doesn't matter.  What matters is locks protecting the
> io.  Like the XFS iolock or cluster locks in the cluster filesystems,
> and you will get silent data corruption that way.

Hmm, I can see i_mutex being a problem, but can't see how a filesystem
takes any other locks down that chain?

Naturally a random in-kernel user misses other important things, so yes
a simple write sounds like the best option.


> > Probably yes. But it seems like it should have more discussion IMO
> > (unless it has already been had and I missed it).
> 
> This came up plenty of times.

I mean, unless the discussion agreed on write_one_page being the right
API to add, then it should not be added in fscache and fscache should
just take a workaround for the meantime.


> > I don't think "write_one_page" sounds like a particularly good new
> > API addition.
> 
> I also thing it's not a nice one.  I still haven't seen a really good
> explanation of why it can't just use plain ->write

Good question.
