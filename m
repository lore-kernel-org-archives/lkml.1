Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbZAVWn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbZAVWn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZAVWnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:43:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57771 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZAVWns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:43:48 -0500
Date: Thu, 22 Jan 2009 17:43:47 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090122224347.GA18751@infradead.org>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com> <20090113214949.GN8071@disturbed> <Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com> <20090118173144.GA1999@infradead.org> <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com> <20090120232422.GF10158@disturbed> <20090122205913.GA30859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122205913.GA30859@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:59:13PM -0500, Christoph Hellwig wrote:
> On Wed, Jan 21, 2009 at 10:24:22AM +1100, Dave Chinner wrote:
> > Right, so you need to use internal xfs sync functions that don't
> > have these problems. That is:
> > 
> > 	error = xfs_sync_inodes(ip->i_mount, SYNC_DELWRI|SYNC_WAIT);
> > 
> > will do a blocking flush of all the inodes without deadlocks occurring.
> > Then you can remove the 500ms wait.
> 
> I've given this a try with Eric's testcase from #724 in the oss bugzilla,
> but it's not enough yet.  I thinks that's because SYNC_WAIT is rather
> meaningless for data writeout, and we need SYNC_IOWAIT instead.  The
> patch below gets the testcase working for me:

Actually I still see failures happing sometimes.  I guess tha'ts because
our flush is still asynchronous due to the schedule_work..
