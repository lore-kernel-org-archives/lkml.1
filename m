Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbZIXJJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbZIXJJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZIXJJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:09:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45397 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZIXJJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:09:19 -0400
Date: Thu, 24 Sep 2009 10:09:23 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: a patch drop request in -mm
Message-ID: <20090924090923.GA8800@csn.ul.ie>
References: <2f11576a0909210800l639560e4jad6cfc2e7f74538f@mail.gmail.com> <20090921152219.GQ12726@csn.ul.ie> <20090924092903.B648.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090924092903.B648.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 09:40:34AM +0900, KOSAKI Motohiro wrote:
> > On Tue, Sep 22, 2009 at 12:00:51AM +0900, KOSAKI Motohiro wrote:
> > > Mel,
> > > 
> > > Today, my test found following patch makes false-positive warning.
> > > because, truncate can free the pages
> > > although the pages are mlock()ed.
> > > 
> > > So, I think following patch should be dropped.
> > > .. or, do you think truncate should clear PG_mlock before free the page?
> > 
> > Is there a reason that truncate cannot clear PG_mlock before freeing the
> > page?
> 
> CC to Lee.
> IIRC, Lee tried it at first. but after some trouble, he decided change free_hot_cold_page().
> but unfortunately, I don't recall the reason ;-)
> 
> Lee, Can you recall it?
> 
> 
> > > Can I ask your patch intention?
> > 
> > Locked pages being freed to the page allocator were considered
> > unexpected and a counter was in place to determine how often that
> > situation occurred. However, I considered it unlikely that the counter
> > would be noticed so the warning was put in place to catch what class of
> > pages were getting freed locked inappropriately. I think a few anomolies
> > have been cleared up since. Ultimately, it should have been safe to
> > delete the check.
> 
> OK. it seems reasonable. so, I only hope no see linus tree output false-positive warnings.
> Thus, I propse 
> 
>   - don't merge this patch to linus tree
>   - but, no drop from -mm
>     it be holded in mm until this issue fixed.
>   - I'll working on fixing this issue.
> 
> I think this is enough fair.
> 

I'm afraid I'm just about to run out the door and will be offline until
Tuesday at the very least. I haven't had the chance to review the patch.
However, I have no problem with this patch not being merged to Linus's tree
if it remains in -mm to catch this and other false positives.

> Hannes, I'm sorry. I haven't review your patch. I'm too busy now. please gime me more
> sevaral time.
> 

It'll be Tuesday at the very earliest before I get a chance to review.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
