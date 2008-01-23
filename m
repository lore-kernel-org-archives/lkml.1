Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYAWGL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYAWGL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 01:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYAWGLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 01:11:49 -0500
Received: from relay2.sgi.com ([192.48.171.30]:33675 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753274AbYAWGLt (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 01:11:49 -0500
Date: Wed, 23 Jan 2008 17:11:36 +1100
From: David Chinner <dgc@sgi.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: do_remount_sb(RDONLY) race? (was: XFS oops under 2.6.23.9)
Message-ID: <20080123061136.GS155259@sgi.com>
References: <20080123053412.GN155259@sgi.com> <200801230554.m0N5sXJL001173@turbo.physics.adelaide.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801230554.m0N5sXJL001173@turbo.physics.adelaide.edu.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 04:24:33PM +1030, Jonathan Woithe wrote:
> > On Wed, Jan 23, 2008 at 03:00:48PM +1030, Jonathan Woithe wrote:
> > > Last night my laptop suffered an oops during closedown.  The full oops
> > > reports can be downloaded from
> > > 
> > >   http://www.atrad.com.au/~jwoithe/xfs_oops/
> > 
> > Assertion failed: atomic_read(&mp->m_active_trans) == 0, file:
> > fs/xfs/xfs_vfsops.c, line 689.
> > 
> > The remount read-only of the root drive supposedly completed
> > while there was still active modification of the filesystem
> > taking place.
.....
> > The read only flag only gets set *after* we've made the filesystem
> > readonly, which means before we are truly read only, we can race
> > with other threads opening files read/write or filesystem
> > modifcations can take place.
> > 
> > The result of that race (if it is really unsafe) will be assert you
> > see. The patch I wrote a couple of months ago to fix the problem
> > is attached below....
> 
> Thanks for the patch.  I will apply it and see what happens.
> 
> Will this be in 2.6.24?

No - because hitting the problem is so rare that I'm not even
sure it's a problem. One of the VFS gurus will need to comment
on whether this really is a problem, and if so the correct fix
is to do_remount_sb() so that it closes the hole for everyone.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
