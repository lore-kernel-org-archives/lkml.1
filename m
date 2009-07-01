Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZGADyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZGADyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZGADyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:54:16 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:47308 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbZGADyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fKKHRHWtMn58/qG+9Al8l3iZTUQyAwDPAvRcO6R7KhGJNoU3jbtcXqfDBhw+Mx/ox+
         9en/suW0XXwGE05Q3SZQg8x/zvO6g0NwqSULNcu5jQRHXk+NbqNVPbum//YNafYLIHR+
         +GsofS10q9FC0a3yyyxRf4PbQeb8c3iHUNqlQ=
Date: Wed, 1 Jul 2009 11:54:15 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Woodhouse <dwmw2@infradead.org>, David Howells <dhowells@redhat.com>,
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
Subject: Re: Found the commit that causes the OOMs
Message-ID: <20090701035415.GA22364@localhost>
References: <20090701021645.GA6356@localhost> <20090701022644.GA7510@localhost> <20090701114959.85D3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701114959.85D3.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 11:51:54AM +0900, KOSAKI Motohiro wrote:
> > > > What is "hidden" anon pages?
> > > > each shrink_{in}active_list isolate 32 pages from lru. it mean anon or file lru
> > > > accounting decrease temporary.
> > > > 
> > > > if system have plenty thread or process, heavy memory pressure makes 
> > > > #-of-thread x 32pages isolation.
> > > > 
> > > > msgctl11 makes >10K processes.
> > > 
> > > More exactly, ~16K processes:
> > > 
> > >         msgctl11    0  INFO  :  Using upto 16298 pids
> > > 
> > > So the maximum number of isolated pages is 16K * 32 = 512K, or 2GiB.
> > > 
> > > > I have debugging patch for this case.
> > > > Wu, Can you please try this patch?
> > > 
> > > OK. But the OOM is not quite reproducible. Sometimes it produces these
> > > messages:
> > 
> > This time I got the OOM: there are 69817 isolated pages (just as expected)!
> > 
> (snip)
> 
> > [ 1522.019259] Active_anon:11 active_file:6 inactive_anon:0
> > [ 1522.019260]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
> > [ 1522.019261]  free:1985 slab:44399 mapped:132 pagetables:61830 bounce:0
> > [ 1522.019262]  isolate:69817
> 
> OK. thanks.
> I plan to submit this patch after small more tests. it is useful for OOM analysis.

Other counters to consider are NR_ANON_PAGES/NR_FILE_PAGES.

If they were showed in the oom message, this problem could be found
much earlier.  In this case, we'll find that the total file+anon pages
outnumbered the active+inactive file/anon pages.

Thanks,
Fengguang
