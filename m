Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbYFHXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbYFHXf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 19:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbYFHXfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 19:35:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbYFHXfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 19:35:18 -0400
Date: Sun, 8 Jun 2008 19:34:20 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Message-ID: <20080608193420.2a9cc030@bree.surriel.com>
In-Reply-To: <20080608162208.a2683a6c.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.291472052@redhat.com>
	<20080606180506.081f686a.akpm@linux-foundation.org>
	<20080608163413.08d46427@bree.surriel.com>
	<20080608135704.a4b0dbe1.akpm@linux-foundation.org>
	<20080608173244.0ac4ad9b@bree.surriel.com>
	<20080608162208.a2683a6c.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 16:22:08 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> The this-is-64-bit-only problem really sucks, IMO.  We still don't know
> the reason for that decision.  Presumably it was because we've already
> run out of page flags?  If so, the time for the larger pageframe is
> upon us.

32 bit machines are unlikely to have so much memory that they run
into big scalability issues with mlocked memory.

The obvious exception to that are large PAE systems, which run
into other bottlenecks already and will probably hit the wall in
some other way before suffering greatly from the "kswapd is
scanning unevictable pages" problem.

I'll leave it up to you to decide whether you want this feature
64 bit only, or whether you want to use up the page flag on 32
bit systems too.

Please let me know which direction I should take, so I can fix
up the patch set accordingly.
 
> > > As a starting point: what, in your english-language-paragraph-length
> > > words, does this flag mean?
> > 
> > "Cannot be reclaimed because someone has it locked in memory
> > through mlock, or the page belongs to something that cannot
> > be evicted like ramfs."
> 
> Ray's "unevictable" sounds good.  It's not a term we've used elsewhere.
> 
> It's all a bit arbitrary, but it's just a label which maps onto a
> concept and if we all honour that mapping carefully in our code and
> writings, VM maintenance becomes that bit easier.

OK, I'll rename everything to unevictable and will add documentation
to clear up the meaning.

-- 
All rights reversed.
