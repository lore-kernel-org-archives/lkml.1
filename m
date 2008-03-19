Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbYCSTi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbYCSTi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYCST3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:29:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:51598 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754670AbYCST3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:29:03 -0400
Date: Wed, 19 Mar 2008 11:08:05 +0100
From: Jan Kara <jack@suse.cz>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: BUG: drop_pagecache_sb vs kjournald lockup
Message-ID: <20080319100805.GB22109@duck.suse.cz>
References: <20080318112843.GJ95344431@sgi.com> <20080318134326.GA6558@atrey.karlin.mff.cuni.cz> <20080318204646.GY155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318204646.GY155407@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-03-08 07:46:46, David Chinner wrote:
> On Tue, Mar 18, 2008 at 02:43:26PM +0100, Jan Kara wrote:
> > > 2.6.25-rc3, 4p ia64, ext3 root drive.
> > > 
> > > I was running an XFS stress test on one of the XFS partitions on
> > > the machine (zero load on the root ext3 drive), when the system
> > > locked up in kjournald with this on the console:
> > > 
> > > BUG: spinlock lockup on CPU#2, kjournald/2150, a000000100e022e0
> > > 
> >   <snip traces>
> 
> <snip other stuff>
> 
> > > Anyone know the reason why drop_pagecache_sb() uses such a brute-force
> > > mechanism to free up clean page cache pages?
> >   Yes, we know that drop_pagecache_sb() has locking issues but since it
> > is intended to be used for debugging purposes only, nobody cared enough
> > to fix it. Completely untested patch below if you dare to try ;)
> 
> It may be intended for debuging purposes, but it does get used in
> production HPC environments (a lot!). I guess I've never seen this
> lockup before because SGI customers don't use ext3, but they have
> complained about the system "stopping" while drop_caches is executed.
> This locking ..... strategy would explain it, though.
  ;) But in case your customers use it in production, shouldn't you push
for a better interface for such feature? Just a thought...

> I'll try the patch, but I can't guarantee anything - I only saw this
> lockup once in about 18 hours when dropping caches every 2 seconds.
  Well, if you enable lockdep, it should warn you about possible problems
much earlier (at least we already got several reports of lockdep warnings
when using drop_caches).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
