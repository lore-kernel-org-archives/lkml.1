Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbXCDBw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbXCDBw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbXCDBw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:52:57 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51571 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647AbXCDBw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:52:56 -0500
Date: Sat, 3 Mar 2007 17:51:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <clameter@engr.sgi.com>,
       Mel Gorman <mel@skynet.ie>, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
Message-Id: <20070303175158.00d867cb.akpm@linux-foundation.org>
In-Reply-To: <45EA2037.9060303@redhat.com>
References: <20070302050625.GD15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012137580.1768@schroedinger.engr.sgi.com>
	<20070302054944.GE15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012150290.1768@schroedinger.engr.sgi.com>
	<20070302060831.GF15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012213130.1917@schroedinger.engr.sgi.com>
	<20070302062950.GG15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012236160.1979@schroedinger.engr.sgi.com>
	<20070302071955.GA5557@wotan.suse.de>
	<Pine.LNX.4.64.0703012335250.13224@schroedinger.engr.sgi.com>
	<20070302081210.GD5557@wotan.suse.de>
	<45EA2037.9060303@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 20:26:15 -0500 Rik van Riel <riel@redhat.com> wrote:

> Nick Piggin wrote:
> 
> > Different issue, isn't it? Rik wants to be smarter in figuring out which
> > pages to throw away. More work per page == worse for you.
> 
> Being smarter about figuring out which pages to evict does
> not equate to spending more work.  One big component is
> sorting the pages beforehand, so we do not end up scanning
> through (and randomizing the LRU order of) anonymous pages
> when we do not want to, or cannot, evict them anyway.
> 

My gut feel is that we could afford to expend a lot more cycles-per-page
doing stuff to avoid IO than we presently do.

At least, reclaim normally just doesn't figure in system CPU time, except
for when it's gone completely stupid.

It could well be that we sleep too much in there though.
