Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbXBAGUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbXBAGUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933381AbXBAGUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:20:37 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:34534 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933354AbXBAGUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:20:36 -0500
Date: Thu, 1 Feb 2007 17:20:18 +1100
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201062018.GC33919298@melbourne.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org> <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com> <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com> <20070131163638.290f40c1.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131163638.290f40c1.akpm@osdl.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 04:36:38PM -0800, Andrew Morton wrote:
> On Wed, 31 Jan 2007 16:27:16 -0800 (PST)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Wed, 31 Jan 2007, Andrew Morton wrote:
> > 
> > > ow.  Please don't make me drop git-block-and-lots-of-other-things again.
> > > Was 2.6.20-rc6-mm2 OK?  It didn't have git-block.
> > 
> > Yes, 2.6.20-rc6-mm2 was okay. Sorry.
> 
> OK, thanks.
> 
> Actually, we might not have lost an IO: it could be that we're simply
> missing an unplug.

Could be - I can't be certain but I think we've got one thread
waiting for a buffer to be unpinned before it is written, and
the other thread waiting for log I/O to complete. The first thread
won't unplug the device, and the log I/o is async so it won't either.

What are the new unplugging rules introduced by the git-block
patch? How do they differ from the existing rules?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
