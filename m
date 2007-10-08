Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXJHAPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXJHAPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 20:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXJHAPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 20:15:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50437 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbXJHAPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 20:15:03 -0400
Date: Mon, 8 Oct 2007 10:14:52 +1000
From: David Chinner <dgc@sgi.com>
To: Max Waterman <davidmaxwaterman+kernel@fastmail.co.uk>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS internal error
Message-ID: <20071008001452.GX995458@sgi.com>
References: <470831E6.4030704@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470831E6.4030704@fastmail.co.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[please cc xfs@oss.sgi.com on XFS bug reports. thx.]

On Sun, Oct 07, 2007 at 09:09:58AM +0800, Max Waterman wrote:
> Hi,
> 
> I have just had an XFS error occur while deleting some directory
> hierarchy. I hope this is the correct place to report it.

.....
> This is in syslog :
> 
> > Oct  6 23:40:33 jeeves kernel: xfs_da_do_buf: bno 16777216
                                                  ^^^^^^^^^^^^^
> > Oct  6 23:40:33 jeeves kernel: dir: inode 2095141277
> > Oct  6 23:40:33 jeeves kernel: Filesystem "md2": XFS internal error xfs_da_do_buf(1) at line 1994 of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff889b2de4

Did you ever run 2.6.17-2.6.17.6? If so, this implies:

http://oss.sgi.com/projects/xfs/faq.html#dir2

> I am fairly sure there is nothing I can do about this, but I thought it
> prudent to mention it. Searching turned up some similar issues, but they
> seem related to a previous kernel version and claimed to be fixed in
> subsequent versions.

Yes, but those previous corruptions get left on disk as a landmine
for you to trip over some time later, even on a kernel that has the
bug fixed.

I suggest that you run xfs_check on the filesystem and if that
shows up errors, run xfs_repair onteh filesystem to correct them.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
