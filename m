Return-Path: <linux-kernel-owner+w=401wt.eu-S1946014AbXBICEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946014AbXBICEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946023AbXBICEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:04:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:45037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946017AbXBICEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:04:04 -0500
Date: Fri, 9 Feb 2007 03:04:02 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-ID: <20070209020402.GC17334@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site> <20070209003801.GX14799@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070209003801.GX14799@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 04:38:01PM -0800, Mark Fasheh wrote:
> On Thu, Feb 08, 2007 at 02:07:15PM +0100, Nick Piggin wrote:
> > The problem is that the existing aops interface is crap. "correct, fast,
> > compatible -- choose any 2"
> 
> Agreed. There's lots of problems with the interface (imho), but my biggest
> two issues are the page lock being held on ->prepare_write() /
> ->commit_write() and the fact that the file system only sees the write one
> page at a time
> 
> 
> > So I have finally finished a first slightly-working draft of my new aops
> > op (perform_write) proposal. I would be interested to hear comments about
> > it.  Most of my issues and concerns are in the patch headers themselves,
> > so reply to them.
> 
> I like ->perform_write(). It allows the file system to make re-use of the
> checks in the generic write path, but gives a maximum amount of information
> about the overall operation to be done. There's an added advantage in that
> some file systems (ocfs2 is one of these) want to be more careful about
> ordering page locks, which should be much easier with it.

Yeah, if possible I like a range based interface rather than page
based. As you say it gives the most information with the least constraints.

> If this goes in, it could probably be helpful to me in some of the code I'm
> currently writing which needs to be better about page lock / cluster lock
> ordering and wants to see as much of the (allocating) writes as possible.

I think it would be important to have a non trivial user of this new API
before it goes into mainline. It would be great if you could look at
using it, after it passes some review.

Thanks,
Nick
