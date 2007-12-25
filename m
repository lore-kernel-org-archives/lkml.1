Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbXLYWHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbXLYWHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 17:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXLYWGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 17:06:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbXLYWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 17:06:47 -0500
Date: Tue, 25 Dec 2007 14:05:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       pagg@oss.sgi.com, erikj@sgi.com, matthltc@us.ibm.com, pj@sgi.com
Subject: Re: [PATCH 0/4] add task handling notifier
Message-Id: <20071225140526.547a882f.akpm@linux-foundation.org>
In-Reply-To: <20071223122621.GA19310@infradead.org>
References: <476A780C.76E4.0078.0@novell.com>
	<20071223122621.GA19310@infradead.org>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007 12:26:21 +0000 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Dec 20, 2007 at 01:11:24PM +0000, Jan Beulich wrote:
> > With more and more sub-systems/sub-components leaving their footprint
> > in task handling functions, it seems reasonable to add notifiers that
> > these components can use instead of having them all patch themselves
> > directly into core files.
> 
> I agree that we probably want something like this.  As do some others,
> so we already had a few a few attempts at similar things.  The first one
> is from SGI and called PAGG (http://oss.sgi.com/projects/pagg/) and also
> includes allocating per-task data for it's users.  Then also from SGI
> there has been a simplified version called pnotify that's also available
> from the website above.
> 
> Later Matt Helsley had something called "Task Watchers" which lwn has
> an article on: http://lwn.net/Articles/208117/.
> 
> For some reason neither ever made a lot of progess (performance
> problems?).
> 

I had it in -mm, sorted out all the problems but ended up not pulling the
trigger.

Problem is, it adds runtime overhead purely for the convenience of kernel
programmers, and I don't think that's a good tradeoff.

Sprinkling direct calls into a few well-known sites won't kill us, and
we've survived this long.  Why not keep doing that, and save everyone a few
cycles?


