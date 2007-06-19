Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbXFSPws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbXFSPws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXFSPwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:52:41 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:59046 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbXFSPwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:52:41 -0400
Date: Tue, 19 Jun 2007 16:52:39 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/7] KAMEZAWA Hiroyuki hot-remove patches
Message-ID: <20070619155239.GB17109@skynet.ie>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie> <20070618092841.7790.48917.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0706180954320.4751@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706180954320.4751@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/06/07 09:56), Christoph Lameter didst pronounce:
> On Mon, 18 Jun 2007, Mel Gorman wrote:
> 
> > @@ -632,18 +632,27 @@ static int unmap_and_move(new_page_t get
> >  			goto unlock;
> >  		wait_on_page_writeback(page);
> >  	}
> > -
> > +	/* anon_vma should not be freed while migration. */
> > +	if (PageAnon(page)) {
> > +		rcu_read_lock();
> > +		rcu_locked = 1;
> > +	}
> 
> We agreed on doing rcu_read_lock removing the status variable 
> and checking for PageAnon(). Doing so deuglifies the 
> function.

It makes it less ugly but when making the retry-logic for migration better I
was also routinely locking up my test-box hard. I intend to run this inside
a simulator so I can use gdb to figure out what is going wrong but for the
moment I've actually gone back to using a slightly modified anon_vma patch.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
