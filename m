Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbYBTVRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbYBTVRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:17:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765360AbYBTVQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:16:11 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44266 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765266AbYBTVQI (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:16:08 -0500
Date: Thu, 21 Feb 2008 08:15:52 +1100
From: David Chinner <dgc@sgi.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: inode leak in 2.6.24?
Message-ID: <20080220211552.GS155407@sgi.com>
References: <87hcg9hkpp.fsf@szonett.ki.iif.hu> <20080218215344.GM155407@sgi.com> <87skzoanq3.fsf@szonett.ki.iif.hu> <20080220010405.GF155407@sgi.com> <87fxvny9ru.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxvny9ru.fsf@szonett.ki.iif.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 03:36:53PM +0100, Ferenc Wagner wrote:
> David Chinner <dgc@sgi.com> writes:
> > The xfs inodes are clearly pinned by the dentry cache, so the issue
> > is dentries, not inodes. What's causing dentries not to be
> > reclaimed?  I can't see anything that cold pin them (e.g. no filp's
> > that would indicate open files being responsible), so my initial
> > thoughts are that memory reclaim may have changed behaviour.
> >
> > I guess the first thing to find out is whether memory pressure
> > results in freeing the dentries. To simulate memory pressure causing
> > slab cache reclaim, can you run:
> >
> > # echo 2 > /proc/sys/vm/drop_caches
> >
> > and see if the number of dentries and inodes drops. If the number
> > goes down significantly, then we aren't leaking dentries and there's
> > been a change in memoy reclaim behaviour. If it stays the same, then
> > we probably are leaking dentries....
> 
> Hi Dave,
> 
> Thanks for looking into this.  There's no real conclusion yet: the
> simulated memory pressure sent the numbers down allright, but
> meanwhile it turned out that this is a different case: on this machine
> the increase wasn't a constant growth, but related to the daily
> updatedb job.  I'll reload the original kernel on the original
> machine, and collect the same info if the problem reappers.

Ok, let me know how it goes when you get a chance.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
