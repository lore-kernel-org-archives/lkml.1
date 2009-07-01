Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZGACwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZGACwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZGACvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:51:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33455 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZGACvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:51:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: Found the commit that causes the OOMs
Cc: kosaki.motohiro@jp.fujitsu.com, David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
In-Reply-To: <20090701022644.GA7510@localhost>
References: <20090701021645.GA6356@localhost> <20090701022644.GA7510@localhost>
Message-Id: <20090701114959.85D3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Jul 2009 11:51:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > What is "hidden" anon pages?
> > > each shrink_{in}active_list isolate 32 pages from lru. it mean anon or file lru
> > > accounting decrease temporary.
> > > 
> > > if system have plenty thread or process, heavy memory pressure makes 
> > > #-of-thread x 32pages isolation.
> > > 
> > > msgctl11 makes >10K processes.
> > 
> > More exactly, ~16K processes:
> > 
> >         msgctl11    0  INFO  :  Using upto 16298 pids
> > 
> > So the maximum number of isolated pages is 16K * 32 = 512K, or 2GiB.
> > 
> > > I have debugging patch for this case.
> > > Wu, Can you please try this patch?
> > 
> > OK. But the OOM is not quite reproducible. Sometimes it produces these
> > messages:
> 
> This time I got the OOM: there are 69817 isolated pages (just as expected)!
> 
(snip)

> [ 1522.019259] Active_anon:11 active_file:6 inactive_anon:0
> [ 1522.019260]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
> [ 1522.019261]  free:1985 slab:44399 mapped:132 pagetables:61830 bounce:0
> [ 1522.019262]  isolate:69817

OK. thanks.
I plan to submit this patch after small more tests. it is useful for OOM analysis.




