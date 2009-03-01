Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZCAKjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZCAKjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 05:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZCAKjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 05:39:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35438 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbZCAKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 05:39:31 -0500
Date: Sun, 1 Mar 2009 19:37:36 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, rjw@sisk.pl, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090227132726.GE1482@ucw.cz>
References: <20090206130009.99400d43.akpm@linux-foundation.org> <20090227132726.GE1482@ucw.cz>
Message-Id: <20090228154120.6FC3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > hm?  And if this approach leads to less-than-optimum performance after
> > resume then the fault lies with core page reclaim - it reclaimed the
> > wrong pages!
> > 
> > That actually was my thinking when I first worked on
> > shrink_all_memory() and it did turn out to be surprisingly hard to
> > simply reuse the existing reclaim code for this application.  Things
> > kept on going wrong.  IIRC this was because we were freeing pages as we
> > were reclaiming, so the page reclaim logic kept on seeing all these
> > free pages and kept on wanting to bale out.
> > 
> > Now, the simple and obvious fix to this is not to free the pages - just
> > keep on allocating pages and storing them locally until we have
> > "enough" memory.  Then when we're all done, dump them all straight onto
> > to the freelists.
> > 
> > But for some reason which I do not recall, we couldn't do that.
> 
> We used to do that. I remember having loop doing get_free_page and
> doing linklist of them. I believe it was considered quite an hack.
> 
> .....one reason is that ee don't want to OOMkill anything if memory is
> low, we want to abort the hibernation...
> 
> Sorry for being late.....

Not at all.
your information is really helpful.

maybe, I expect we can make simplification without oomkill...



