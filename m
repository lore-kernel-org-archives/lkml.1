Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbYFSEPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbYFSEPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 00:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYFSEPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 00:15:04 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:55011 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbYFSEOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 00:14:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPh4WUh5LG+u/2dsb2JhbACwMw
X-IronPort-AV: E=Sophos;i="4.27,670,1204464600"; 
   d="scan'208";a="129718666"
Date: Thu, 19 Jun 2008 14:14:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS: 2.6.26-rc6 link count mismatch for inode
Message-ID: <20080619041441.GW3700@disturbed>
Mail-Followup-To: Marco Berizzi <pupilla@hotmail.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl> <20080618161252.GV3700@disturbed> <BAY103-DAV10F0AFAC45572E50A384AB2AB0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV10F0AFAC45572E50A384AB2AB0@phx.gbl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 06:39:59PM +0200, Marco Berizzi wrote:
> Dave Chinner wrote:
> 
> > On Mon, Jun 16, 2008 at 11:11:31AM +0200, Marco Berizzi wrote:
> > > Hi Folk,
> > >
> > > I was tring to compile firefox 3.0rc3
> > > and while I was erasing a previous
> > > /tmp/mozilla tree, I started a new
> > > tar xjf mozilla-blabla.
> > > After a while linux 2.6.26-rc6 was
> > > unresponsive: I have unplugged the
> > > power cable. No problem at startup,
> > > but:
> >
> > What are your mount options?
> 
> root@Venus:/etc# cat mtab
> /dev/sda2 / xfs rw 0 0
> 
> root@Venus:/etc# cat fstab
> /dev/sda2        /                xfs         defaults         1   1

[...]

> XFS mounting filesystem sda2
> Ending clean XFS mount for filesystem: sda2
> VFS: Mounted root (xfs filesystem) readonly.
> 
> > I ask because I've
> > seen this sort of directory corruption before when using volatile
> > write caches and yanking the power....
> >
> > i.e. the corruption could have been caused by the way you reset the
> > system, not because of the hang. Do you have any information on what
> > caused the hang?
> 
> The tar xf mozilla-source.tarball was not responding
> nor writing anything on the disk. I did issue also a
> kill -9 'pid of tar xf' but it did not want to die.
> So I think the problem was on the filesystem before
> the incorrect shutdown.

Yeah, it sounds like the I/O subsystem hung somewhere. Without
details I can't say what went wrong. If it happens again doing
this:

# echo w > /proc/sysrq-trigger

To get a dump of all the blocked processes on the console. That
may contain enough info to tell us what the problem is.

> I can retry the test. Let me know if I can do a
> xfs_repair.

Sure, go ahead and fix it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
