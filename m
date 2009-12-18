Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZLRKaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZLRKaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZLRKaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:30:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:48239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZLRKaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:30:18 -0500
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
From: James Bottomley <James.Bottomley@suse.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, torvalds@linux-foundation.org, tytso@mit.edu,
       kyle@mcmartin.ca, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-arch@vger.kernel.org
In-Reply-To: <20091218192401D.fujita.tomonori@lab.ntt.co.jp>
References: <1261120128.3013.8.camel@mulgrave.site>
	 <20091218183353I.fujita.tomonori@lab.ntt.co.jp>
	 <1261130489.3013.41.camel@mulgrave.site>
	 <20091218192401D.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 11:30:12 +0100
Message-Id: <1261132212.3013.45.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 19:24 +0900, FUJITA Tomonori wrote:
> On Fri, 18 Dec 2009 11:01:29 +0100
> James Bottomley <James.Bottomley@suse.de> wrote:
> 
> > > Yeah, but now only XFS passes vmap'ed pages to the block layer. Isn't
> > > it better to wait until we have real users of the API?
> > 
> > XFS is a real user ... the XFS filesystem is our most trusted code base
> > that can break the 8TB limit, which hard disks are already at.  Ext4 may
> > be ready, but it's not universally present in enterprise distros like
> > XFS.
> 
> XFS already has the own code to handle that, which works fine (with
> your patchset except for 5/6 for the block layer). Not much motivation
> for XFS to move to the generic API?

Right, but it's for completeness.  If we decide to allow vmap buffers,
then only supporting them on certain paths is a recipe for confusion in
a year's time when someone assumes we support vmap buffers on all block
paths; a bit like the current confusion over what we support ....

> > > > That would ensure the architecturally
> > > > correct flushing of the aliases, and would satisfy the expectations of
> > > > blk_rq_map_kern().  The down side is that vmap/vmalloc set up and clear
> > > > page tables, which isn't necessary and might impact performance (xfs
> > > > people?)
> > > 
> > > btw, I'm not sure that the existing blk_rq_map_* API isn't fit well to
> > > file systems since blk_rq_map_user and blk_rq_map_kern takes a request
> > > structure.
> > 
> > OK, so that was illustrative.  The meat of the change is at the bio
> > layer anyway (fss tend to speak bios).
> 
> Yeah, I think so, it's up to Jens to add new APIs for vmap there.

Agreed.

James


