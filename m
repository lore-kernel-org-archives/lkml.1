Return-Path: <linux-kernel-owner+w=401wt.eu-S1946592AbXEAFtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946592AbXEAFtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423802AbXEAFtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:49:16 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423789AbXEAFtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:49:15 -0400
Date: Mon, 30 Apr 2007 22:49:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Miguel Figueiredo <elmig@debianpt.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 frozen for a few minutes, swapping to disk
Message-Id: <20070430224911.ac989f40.akpm@linux-foundation.org>
In-Reply-To: <4636D346.2010507@yahoo.com.au>
References: <46347335.7080601@debianpt.org>
	<20070430003031.2e89fbc1.akpm@linux-foundation.org>
	<4636D346.2010507@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 15:42:30 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > hm, a genuine oom on an all-ext3 data=ordered i386 system, just like a
> > million other people.  How very weird.
> > 
> > I assume all those pages on the LRU are pagecache pages which for some
> > reason we're unable to reclaim.
> 
> It looks like it used up all swap? I'd guess a memory leak in some
> application, or maybe a page refcount leak somewhere.

yes, I missed that.   The number of mapped pages is tiny so the thing has
been trying to swap out like.

The question is: how much memory is free after the oom-killing storm?
If it's "lots" then it's probably an application problem.  If it's
"not much" then perhaps there's a kernel leak.
