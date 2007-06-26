Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbXFZXak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbXFZXak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761140AbXFZXS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:18:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37888 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761034AbXFZXSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:18:25 -0400
Date: Wed, 27 Jun 2007 09:18:04 +1000
From: David Chinner <dgc@sgi.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com,
       xfs@oss.sgi.com
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626231803.GQ31489@sgi.com>
References: <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070626153413.GC6652@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626153413.GC6652@schatzie.adilger.int>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:34:13AM -0400, Andreas Dilger wrote:
> On Jun 26, 2007  16:02 +0530, Amit K. Arora wrote:
> > On Mon, Jun 25, 2007 at 03:46:26PM -0600, Andreas Dilger wrote:
> > > Can you clarify - what is the current behaviour when ENOSPC (or some other
> > > error) is hit?  Does it keep the current fallocate() or does it free it?
> > 
> > Currently it is left on the file system implementation. In ext4, we do
> > not undo preallocation if some error (say, ENOSPC) is hit. Hence it may
> > end up with partial (pre)allocation. This is inline with dd and
> > posix_fallocate, which also do not free the partially allocated space.
> 
> Since I believe the XFS allocation ioctls do it the opposite way (free
> preallocated space on error) this should be encoded into the flags.
> Having it "filesystem dependent" just means that nobody will be happy.

No, XFs does not free preallocated space on error. it is up to the
application to clean up.

> What I mean is that any data read from the file should have the "appearance"
> of being zeroed (whether zeroes are actually written to disk or not).  What
> I _think_ David is proposing is to allow fallocate() to return without
> marking the blocks even "uninitialized" and subsequent reads would return
> the old data from the disk.

Correct, but for swap files that's not an issue - no user should be able
too read them, and FA_MKSWAP would really need root privileges to execute.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
