Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXCOIF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXCOIF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 04:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbXCOIF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 04:05:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:43569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975AbXCOIFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 04:05:03 -0400
Date: Thu, 15 Mar 2007 09:04:40 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mark Fasheh <mark.fasheh@oracle.com>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315080440.GA16155@wotan.suse.de>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site> <20070315041329.GB21942@ca-server1.us.oracle.com> <20070315043642.GF15069@wotan.suse.de> <20070315062305.GA20528@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315062305.GA20528@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 11:23:05PM -0700, Joel Becker wrote:
> On Thu, Mar 15, 2007 at 05:36:42AM +0100, Nick Piggin wrote:
> > On Wed, Mar 14, 2007 at 09:13:29PM -0700, Mark Fasheh wrote:
> > > Are we going to get rid of the file and intr arguments btw? I'm not sure
> > > intr is useful, and mapping is probably enough to get whatever we inside
> > > ->write_begin / ->write_end.
> > 
> > Yeah, I was going to, but I had this version ready to go so decided
> > to leave them in at the last minute. We can definitely take them out
> > if people agree.
> 
> 	You're really going to need the file argument around.  Some
> folks care about file->private_data, etc.  A good example is
> nfs_updatepage() from nfs_commit_write().  There's a context on the
> filp.  Mapping can get back to the inode via ->host, but not to the
> struct file.

OK, I'll keep the file around unless we see a better alternative.
Thanks for pointing that out.


