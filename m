Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZETC7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZETC7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZETC7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:59:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41687 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZETC7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:59:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class  citizen
Cc: kosaki.motohiro@jp.fujitsu.com,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <20090520023101.GA8186@localhost>
References: <20090520105159.743B.A69D9226@jp.fujitsu.com> <20090520023101.GA8186@localhost>
Message-Id: <20090520114958.743E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 May 2009 11:58:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > I think smem can show which library evicted.  Can you try it?
> > > > 
> > > > download:  http://www.selenic.com/smem/
> > > > usage:   ./smem -m -r --abbreviate
> > > 
> > > Sure, but I don't see much change in its output (see attachments).
> > > 
> > > smem-console-0 is collected after fresh boot,
> > > smem-console-1 is collected after the big IO.
> > 
> > hmmmm, your result has following characatistics.
> > 
> > - no graphics component
> > - very few mapped library
> >   (it is almost only zsh library)
> > 
> > Can you try test on X environment?
> 
> Sure, see the attached smem-x-0/1. This time we see sufficient differences.

thanks. hm, major shrinking item are 

/usr/lib/xulrunner-1.9/libxul.so	11.0M	=>	2.1M 
/usr/lib/libgtk-x11-2.0.so.0.1600.1	1.8M 	=>	88.0K 
/usr/lib/libperl.so.5.10.0		1.2M 	=>	36.0K 

IOW, inactive firefox's page were dropped.

I think that's sane. the latency of background window is not so important
on low memory desktop system.
user hope to use memory for foreground application.
Thus, droppint inactive application memory is sane behavior, I think.



> 
> > > > We can't decide 9/10 is important or not. we need know actual evicted file list.
> > > 
> > > Right. But what I measured is the activeness. Almost zero major page
> > > faults means the evicted 90% mapped pages are inactive during the
> > > long 300 seconds of IO.
> > 
> > Agreed.
> > IOW, I don't think your test environment is typical desktop...
> 
> Kind of :)  It's fluxbox + terminal + firefox, a bare desktop for
> testing things out.
> 



