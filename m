Return-Path: <linux-kernel-owner+w=401wt.eu-S932992AbXGLOpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbXGLOpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbXGLOo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:44:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45061 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752863AbXGLOo5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:44:57 -0400
Date: Fri, 13 Jul 2007 00:44:49 +1000
From: David Chinner <dgc@sgi.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070712144449.GZ31489@sgi.com>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random> <20070712001256.GI31489@sgi.com> <20070712111436.GG28613@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712111436.GG28613@v2.random>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 01:14:36PM +0200, Andrea Arcangeli wrote:
> On Thu, Jul 12, 2007 at 10:12:56AM +1000, David Chinner wrote:
> > I need really large filesystems that contain both small and large files to
> > work more efficiently on small boxes where we can't throw endless amounts of
> > RAM and CPUs at the problem.  Hence things like 64k page size are just not an
> > option because of the wastage that it entails.
> 
> I didn't know you were allocating 4k pages for the small files and 64k
> for the large ones in the same fs. That sounds quite a bit
> overkill.

We already have rudimentary multi-block size support via the
per-inode extent size hint, but we still cache based on the
filesystem block size ('coz we can't increase it).

All I want is to be able to change the index granularity in the page
cache with minimal impact and everything in XFS falls almost
straight out in a pretty optimal manner.

> I still think you should run those systems with PAGE_SIZE 64k even if
> it'll waste you more memory on the small files.

That's crap. Just because a machine has lots of memory does not
make it OK to waste lots of memory.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
