Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZFLXT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZFLXT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 19:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZFLXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 19:19:16 -0400
Received: from thunk.org ([69.25.196.29]:37726 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZFLXTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 19:19:16 -0400
Date: Fri, 12 Jun 2009 19:19:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 2.6.31-rc
Message-ID: <20090612231903.GE24336@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
References: <20090611204456.GA3834@think> <alpine.LFD.2.01.0906121450530.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906121450530.3237@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 02:55:33PM -0700, Linus Torvalds wrote:
> On Thu, 11 Jun 2009, Chris Mason wrote:
> > 
> > Existing filesystems will be upgraded to the new format on the first
> > mount.  All of your old data will still be there and still work
> > properly, but I strongly recommend a full backup before going to the new
> > code.
> 
> Auugh.
> 
> This is horrible. I just screwed up my system by booting a kernel on this: 
> it worked beatifully, but due to other reasons I then wanted to bisect a 
> totally unrelated issue. While having _totally_ forgotten about this 
> issue, even if I was technically aware of it.
> 
> .. so I installed a new kernel, and now it won't boot due to "couldn't 
> mount because of unsupported optional features (1)". In fact, I have no 
> kernel available on that system that will boot, since my normal "safe" 
> fall-back kernels are all distro kernels that can't boot this either.

We learned this lesson the hard way with ext3, a long time ago,
although occasionally we've had to relearn it along the way.  The
normal failure mode is that some user is still using some ancient
distribution, (say, Red Hat 8), and for some reason they boot using a
Fedora Rescue CD, and are really annoyed when the filesystem is no
longer mountable using the 2.4 kernel that comes with their ancient
distribution.

So my policy at least with ext4 is to *never* add any new patches were
the kernel automatically adds some new feature to the compatibility
bitmasks.  The user should have to explicitly and manually use a
userspace program (i.e., tune2fs) to add some new feature.  At least
initially we had some cases where ext4 would automatically add some
new feature flag thanks to a mount option, but I believe we've gotten
rid of all of those cases.

I'd suggest that btrfs follow the same strategy; yeah, it means you
have to keep more backwards compatibility code for longer, but as
btrfs matures, it'll definitely be a Good Thing.

					- Ted
