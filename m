Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYCJXqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYCJXqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCJXpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:45:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52448 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751304AbYCJXpw (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:45:52 -0400
Date: Tue, 11 Mar 2008 10:45:40 +1100
From: David Chinner <dgc@sgi.com>
To: Andreas Kotes <count@flatline.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS internal error
Message-ID: <20080310234539.GC155407@sgi.com>
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <20080310122216.GG14256@slop.flatline.de> <20080310223018.GA155407@sgi.com> <20080310225927.GP14256@slop.flatline.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310225927.GP14256@slop.flatline.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 11:59:27PM +0100, Andreas Kotes wrote:
> * David Chinner <dgc@sgi.com> [20080310 23:30]:
> > On Mon, Mar 10, 2008 at 01:22:16PM +0100, Andreas Kotes wrote:
> > > * David Chinner <dgc@sgi.com> [20080310 13:18]:
> > > > Yes, but those previous corruptions get left on disk as a landmine
> > > > for you to trip over some time later, even on a kernel that has the
> > > > bug fixed.
> > > > 
> > > > I suggest that you run xfs_check on the filesystem and if that
> > > > shows up errors, run xfs_repair onteh filesystem to correct them.
> > > 
> > > I seem to be having similiar problems, and xfs_repair is not helping :(
> > 
> > xfs_repair is ensuring that the problem is not being caused by on-disk
> > corruption. In this case, it does not appear to be caused by on-disk
> > corruption, so xfs_repair won't help.
> 
> ok, too bad - btw, is it a problem that I'm doing the xfs_repair on a
> mounted filesystem with xfs_repair -f -L after a remount rw?

If it was read only, and you rebooted immediately afterwards, you'd
probably be ok. Doing this to a mounted, rw filesystem is asking
for trouble. If the shutdown is occurring after you've run xfs_repair,
then it is almost certainly the cause....

I'd suggest getting a knoppix (or similar) rescue disk and repairing
from that, rebooting and seeing if the problem persists. If it
does, then we'll have to look further into it.

FWIW, you've got plenty of free inodes so this does not look
to be the same problem I've just found. 

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
