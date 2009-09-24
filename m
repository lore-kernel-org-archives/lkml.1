Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZIXAkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZIXAkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZIXAkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:40:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54245 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZIXAkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:40:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: a patch drop request in -mm
Cc: kosaki.motohiro@jp.fujitsu.com,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <20090921152219.GQ12726@csn.ul.ie>
References: <2f11576a0909210800l639560e4jad6cfc2e7f74538f@mail.gmail.com> <20090921152219.GQ12726@csn.ul.ie>
Message-Id: <20090924092903.B648.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 24 Sep 2009 09:40:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Sep 22, 2009 at 12:00:51AM +0900, KOSAKI Motohiro wrote:
> > Mel,
> > 
> > Today, my test found following patch makes false-positive warning.
> > because, truncate can free the pages
> > although the pages are mlock()ed.
> > 
> > So, I think following patch should be dropped.
> > .. or, do you think truncate should clear PG_mlock before free the page?
> 
> Is there a reason that truncate cannot clear PG_mlock before freeing the
> page?

CC to Lee.
IIRC, Lee tried it at first. but after some trouble, he decided change free_hot_cold_page().
but unfortunately, I don't recall the reason ;-)

Lee, Can you recall it?


> > Can I ask your patch intention?
> 
> Locked pages being freed to the page allocator were considered
> unexpected and a counter was in place to determine how often that
> situation occurred. However, I considered it unlikely that the counter
> would be noticed so the warning was put in place to catch what class of
> pages were getting freed locked inappropriately. I think a few anomolies
> have been cleared up since. Ultimately, it should have been safe to
> delete the check.

OK. it seems reasonable. so, I only hope no see linus tree output false-positive warnings.
Thus, I propse 

  - don't merge this patch to linus tree
  - but, no drop from -mm
    it be holded in mm until this issue fixed.
  - I'll working on fixing this issue.

I think this is enough fair.


Hannes, I'm sorry. I haven't review your patch. I'm too busy now. please gime me more
sevaral time.



