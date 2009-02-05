Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbZBEBON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbZBEBON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761547AbZBEBNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:13:54 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:41682 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124AbZBEBNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:13:53 -0500
Date: Wed, 4 Feb 2009 18:13:52 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>, stable@kernel.org
Subject: Re: [RFC PATCH 03/10] PCI: properly clean up ASPM link state on
	device remove
Message-ID: <20090205011352.GA30756@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>,
	stable@kernel.org
References: <20090128213814.28003.34634.stgit@bob.kio> <20090128215918.28003.58805.stgit@bob.kio> <200902041637.45099.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902041637.45099.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Wednesday, January 28, 2009 1:59 pm Alex Chiang wrote:
> > We only want to disable ASPM when the last function is removed from
> > the parent's device list. We determine this by checking to see if
> > the parent's device list is completely empty.
> >
> > Unfortunately, we never hit that code because the parent is considered
> > an upstream port, and never had an ASPM link_state associated with it.
> >
> > The early check for !link_state causes us to return early, we never
> > discover that our device list is empty, and thus we never remove the
> > downstream ports' link_state nodes.
> >
> > Instead of checking to see if the parent's device list is empty, we can
> > check to see if we are the last device on the list, and if so, then we
> > know that we can clean up properly.
> >
> > Cc: Shaohua Li <shaohua.li@intel.com>
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> 
> Applied to my for-linus branch, thanks.  Let me know if you have a problem 
> with it (fast) Shaohua! :)

Thanks Jesse.

I'm cc'ing stable@kernel.org as well (which I should have done in
the first place). This fixes a bug that existed since ASPM
support was added (7d715a6c1), and git name-rev tells me that
we've had it since 2.6.26.

So this patch is a candidate for 2.6.27 and 2.6.28 stable
branches.

Thanks.

/ac

