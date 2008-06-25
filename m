Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYFYDni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYFYDni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFYDna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:43:30 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:56299 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbYFYDn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:43:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgGAG5bYUh5LG+uWmdsb2JhbACSaAEdn1c
X-IronPort-AV: E=Sophos;i="4.27,700,1204464600"; 
   d="scan'208";a="134747831"
Date: Wed, 25 Jun 2008 13:43:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: xfs-masters@oss.sgi.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
Message-ID: <20080625034324.GE11558@disturbed>
Mail-Followup-To: xfs-masters@oss.sgi.com,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au> <20080624171809.42bbdf68.randy.dunlap@oracle.com> <20080625003751.GP29319@disturbed> <4861A6EB.6050806@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4861A6EB.6050806@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 12:01:15PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
> > On Tue, Jun 24, 2008 at 05:18:09PM -0700, Randy Dunlap wrote:
> >> XFS shows 2 build problems today.
> >>
> >> 1. xfs_stats.h problem
> >>
> >>   CC      fs/xfs/xfs_rtalloc.o
> >> In file included from /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_linux.h:91,
> >>                  from /local/linsrc/linux-next-20080624/fs/xfs/xfs.h:44,
> >>                  from /local/linsrc/linux-next-20080624/fs/xfs/xfs_rtalloc.c:18:
> >> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h: In function 'xfs_init_procfs':
> >> /local/linsrc/linux-next-20080624/fs/xfs/linux-2.6/xfs_stats.h:150: error: expected ';' before '}' token
> >> make[3]: *** [fs/xfs/xfs_rtalloc.o] Error 1
> > 
> > This will be a !CONFIG_PROC_FS change.
> > 
> > Lachlan/Niv - This is the guilty party:
> > 
> > http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git;a=commit;h=e0fe783155e4f1c7106f3579c258b9f995330c19
> > 
> > The commit log is:
> > 
> > [XFS]
> >  
> >  SGI-PV: 111111
> >  SGI-Modid: xfs-linux-melb:xfs-kern:31210a
> >  
> >  Signed-off-by: Niv Sardi <xaiki@sgi.com>
> >  Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> > ---
> > 
> > What the hell happened here? Where's the commit title, description
> > so this can be tracked back to a real patch?  That PV# is also bogus....
> > 
> > I suspect that it is this patch:
> > 
> > http://oss.sgi.com/archives/xfs/2008-05/msg00322.html
> > 
> > Which means that the Signed-Off-By list is incorrect as well as the original
> > patch came from Christoph. This can't go to mainline like this - the commit log
> > needs to be fixed up.
> 
> We knew this checkin was stuffed up and I was planning to fix it in the for-linus
> branch before pushing to mainline.  The merge tools had kittens when it came across
> it too.  I think we need to rip it out of ptools and re-checkin it in with the
> correct details.

It never should have made the merge in that state. Niv, I suggest
you stop using that broken script of yours to do checkins because you
do nothing but break stuff with it. Change logs like:

xiaki pmod2git xfs-linux-melb:xfs-kern:31210a

(http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_stats.h?f=h#rev1.18)

in the CVS tree and busted git logs make it just about impossible to
track where something came from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
