Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZDTXG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZDTXG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZDTXGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:06:45 -0400
Received: from smtp0.av-mx.com ([137.118.16.56]:38398 "EHLO smtp0.av-mx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZDTXGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:06:44 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 19:06:44 EDT
Date: Mon, 20 Apr 2009 18:59:42 -0400
From: Nate Straz <nate-ltp@refried.org>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, subrata@linux.vnet.ibm.com,
       ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [LTP] statvfs -> f_bavail
Message-ID: <20090420225942.GB3590@refried.org>
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com> <20090417173107.GA3590@refried.org> <49EC1352.6010900@petalogix.com> <20090420062642.GY26366@ZenIV.linux.org.uk> <49EC1945.1000805@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC1945.1000805@petalogix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 20 08:42, Michal Simek wrote:
> Al Viro wrote:
> > On Mon, Apr 20, 2009 at 08:16:50AM +0200, Michal Simek wrote:
> >> Hi guys from linux-fsdevel: Can you told us what is the right solution
> >> for my problem above?
> >
> > "Fields that are undefined for a particular file system are set to 0".
> > So what kind of fs are you running that on and is that sucker really
> > defined for it?  Note that if it's ramfs or tmpfs with -o nr_blocks=0,
> > there is no such thing as "amount of free space", reserved for root
> > or not.
> I use ramfs and nfs without any -o nr_block=0 option.
> That mean that for all other fs is possible to set nr_blocks=0 (f_bavail=0) and for all this cases
> fsync02 test failed. That mean that make sense to test f_bavail value in LTP and if is zero
> don't work with it. Am I right?

Sounds like the patch is the right thing to do based on Al's quote.  I
would suggest modifying the patch to use fsblkcnt_t as f_bavail is
defined in statvfs(2).  Other than that, the patch looks good.

Nate
