Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZI2OVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZI2OVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZI2OVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:21:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZI2OVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:21:48 -0400
Date: Tue, 29 Sep 2009 10:21:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090929142128.GA3447@infradead.org>
References: <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org> <20090929023227.GA20153@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929023227.GA20153@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 10:32:27AM +0800, Wu Fengguang wrote:
> > This should help a bit for XFS as it historically does multi-page
> > writeouts from ->writepages (and apprently btrfs that added some
> 
> ->writepage ?

Yes.

> > write-around recently?) but not those brave filesystems only
> > implementing the multi-page writeout from writepages as designed.
> 
> Thanks.  Just tried write_cache_pages(), looks simple. Need to further
> convert all aops->writepages to support lumpy pageout :)

Yeah.  Most ->writepages instances are just copies of write_cache_pages
with local hacks.  If you have any good idea to consolidate that that
would be great.  Also XFS and btrfs do cluster move pages even from
->writepage, I wonder how well that interacts with reclaim.

