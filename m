Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYG1X5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYG1X5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYG1X5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:57:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbYG1X5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:57:22 -0400
Date: Mon, 28 Jul 2008 19:57:13 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: PERF: performance tests with the split LRU VM in -mm
Message-ID: <20080728195713.42cbceed@cuia.bos.redhat.com>
In-Reply-To: <20080728164124.8240eabe.akpm@linux-foundation.org>
References: <20080724222510.3bbbbedc@bree.surriel.com>
	<20080728105742.50d6514e@cuia.bos.redhat.com>
	<20080728164124.8240eabe.akpm@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 16:41:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Andrew, what is your preference between:
> > 	http://lkml.org/lkml/2008/7/15/465
> > and
> > 	http://marc.info/?l=linux-mm&m=121683855132630&w=2
> > 
> 
> Boy.  They both seem rather hacky special-cases.  But that doesn't mean
> that they're undesirable hacky special-cases.  I guess the second one
> looks a bit more "algorithmic" and a bit less hacky-special-case.  But
> it all depends on testing..

I prefer the second one, since it removes the + 1 magic (at least,
for the higher priorities), instead of adding new magic like the
other patch does.

> On a different topic, these:
> 
> vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
> vm-dont-run-touch_buffer-during-buffercache-lookups.patch
> 
> have been floating about in -mm for ages, awaiting demonstration that
> they're a net benefit.  But all of this new page-reclaim rework was
> built on top of those two patches and incorporates and retains them.
> 
> I could toss them out, but that would require some rework and would
> partially invalidate previous testing and who knows, they _might_ be
> good patches.  Or they might not be.
> 
> What are your thoughts?

I believe you should definately keep those.  Being able to better
preserve actively accessed file pages could be a good benefit and
we have yet to discover a downside to those patches.

-- 
All Rights Reversed
