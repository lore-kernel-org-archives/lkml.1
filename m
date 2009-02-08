Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZBHVSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZBHVSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZBHVS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:18:26 -0500
Received: from kroah.org ([198.145.64.141]:36534 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752228AbZBHVSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:18:23 -0500
Date: Sun, 8 Feb 2009 13:11:43 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>, stable@kernel.org
Subject: Re: [stable] [RFC PATCH 03/10] PCI: properly clean up ASPM link
	state on device remove
Message-ID: <20090208211143.GB3204@kroah.com>
References: <20090128213814.28003.34634.stgit@bob.kio> <20090128215918.28003.58805.stgit@bob.kio> <200902041637.45099.jbarnes@virtuousgeek.org> <20090205011352.GA30756@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205011352.GA30756@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 06:13:52PM -0700, Alex Chiang wrote:
> * Jesse Barnes <jbarnes@virtuousgeek.org>:
> > On Wednesday, January 28, 2009 1:59 pm Alex Chiang wrote:
> > > We only want to disable ASPM when the last function is removed from
> > > the parent's device list. We determine this by checking to see if
> > > the parent's device list is completely empty.
> > >
> > > Unfortunately, we never hit that code because the parent is considered
> > > an upstream port, and never had an ASPM link_state associated with it.
> > >
> > > The early check for !link_state causes us to return early, we never
> > > discover that our device list is empty, and thus we never remove the
> > > downstream ports' link_state nodes.
> > >
> > > Instead of checking to see if the parent's device list is empty, we can
> > > check to see if we are the last device on the list, and if so, then we
> > > know that we can clean up properly.
> > >
> > > Cc: Shaohua Li <shaohua.li@intel.com>
> > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > 
> > Applied to my for-linus branch, thanks.  Let me know if you have a problem 
> > with it (fast) Shaohua! :)
> 
> Thanks Jesse.
> 
> I'm cc'ing stable@kernel.org as well (which I should have done in
> the first place). This fixes a bug that existed since ASPM
> support was added (7d715a6c1), and git name-rev tells me that
> we've had it since 2.6.26.
> 
> So this patch is a candidate for 2.6.27 and 2.6.28 stable
> branches.

Now queued up.

thanks,

greg k-h
