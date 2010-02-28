Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032046Ab0B1Ugm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:36:42 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:55622 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032025Ab0B1Ugl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:36:41 -0500
Date: Sun, 28 Feb 2010 21:36:27 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm: used-once mapped file page detection
Message-ID: <20100228203627.GA21128@cmpxchg.org>
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org> <20100224133946.a5092804.akpm@linux-foundation.org> <20100226143232.GA13001@cmpxchg.org> <4B8AAC9A.10203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8AAC9A.10203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 12:49:14PM -0500, Rik van Riel wrote:
> On 02/26/2010 09:32 AM, Johannes Weiner wrote:
> >On Wed, Feb 24, 2010 at 01:39:46PM -0800, Andrew Morton wrote:
> >>On Mon, 22 Feb 2010 20:49:07 +0100 Johannes Weiner<hannes@cmpxchg.org>  
> >>wrote:
> >>
> >>>This patch makes the VM be more careful about activating mapped file
> >>>pages in the first place.  The minimum granted lifetime without
> >>>another memory access becomes an inactive list cycle instead of the
> >>>full memory cycle, which is more natural given the mentioned loads.
> >>
> >>iirc from a long time ago, the insta-activation of mapped pages was
> >>done because people were getting peeved about having their interactive
> >>applications (X, browser, etc) getting paged out, and bumping the pages
> >>immediately was found to help with this subjective problem.
> >>
> >>So it was a latency issue more than a throughput issue.  I wouldn't be
> >>surprised if we get some complaints from people for the same reasons as
> >>a result of this patch.
> >
> >Agreed.  Although we now have other things in place to protect them once
> >they are active (VM_EXEC protection, lazy active list scanning).
> 
> You think we'll need VM_EXEC protection on the inactive list
> after your changes?

So far I personally did not experience anything that would indicate the
need for it.  But I would consider it an option if Andrew's worries turned
out to be true.
