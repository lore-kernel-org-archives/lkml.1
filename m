Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbXIUCRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbXIUCRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbXIUCRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:17:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:50168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbXIUCRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:17:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,280,1186383600"; 
   d="scan'208";a="146569454"
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, nigel@suspend2.net,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200709211157.28622.nigel@nigel.suspend2.net>
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	 <200709211120.00448.ncunningham@crca.org.au>
	 <20070920184106.79e1858a.akpm@linux-foundation.org>
	 <200709211157.28622.nigel@nigel.suspend2.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 10:18:57 +0800
Message-Id: <1190341137.21818.52.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 21 Sep 2007 02:16:57.0357 (UTC) FILETIME=[7C416BD0:01C7FBF5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 11:57 +1000, Nigel Cunningham wrote:
> Hi.
> 
> On Friday 21 September 2007 11:41:06 Andrew Morton wrote:
> > > On Friday 21 September 2007 11:06:23 Andrew Morton wrote:
> > > > On Fri, 21 Sep 2007 10:24:34 +1000 Nigel Cunningham 
> > > <nigel@nigel.suspend2.net> wrote:
> > > > 
> > > > > Hi Andrew.
> > > > > 
> > > > > On Thursday 20 September 2007 20:09:41 Pavel Machek wrote:
> > > > > > Seems like good enough for -mm to me.
> > > > > > 
> > > > > > 									Pavel
> > > > > 
> > > > > Andrew, if I recall correctly, you said a while ago that you didn't 
> want 
> > > > > another hibernation implementation in the vanilla kernel. If you're 
> going 
> > > to 
> > > > > consider merging this kexec code, will you also please consider 
> merging 
> > > > > TuxOnIce?
> > > > > 
> > > > 
> > > > The theory is that kexec-based hibernation will mainly use preexisting
> > > > kexec code and will permit us to delete the existing hibernation
> > > > implementation.
> > > > 
> > > > That's different from replacing it.
> > > 
> > > TuxOnIce doesn't remove the existing implementation either. It can 
> > > transparently replace it, but you can enable/disable that at compile time.
> > 
> > Right.  So we end up with two implementations in-tree.  Whereas
> > kexec-based-hibernation leads us to having zero implementations in-tree.
> > 
> > See, it's different.
> 
> That's not true. Kexec will itself be an implementation, otherwise you'd end 
> up with people screaming about no hibernation support. And it won't result in 
> the complete removal of the existing hibernation code from the kernel. At the 
> very least, it's going to want the kernel being hibernated to have an 
> interface by which it can find out which pages need to be saved. I wouldn't 

This has been done by kexec/kdump guys. There is a makedumpfile utility
and vmcoreinfo kernel mechanism to implement this. We can just reuse the
work of kexec/kdump.

> be surprised if it also ends up with an interface in which the kernel being 
> hibernated tells it what bdev/sectors in which to save the image as well 
> (otherwise you're going to need a dedicated, otherwise untouched partition 
> exclusively for the kexec'd kernel to use), or what network settings to use 
> if it wants to try to save the image to a network storage device. On top of

These can be done in user space. The image writing will be done in user
space for kexec base hibernation.

> that, there are all the issues related to device reinitialisation and so on, 

Yes. Device reinitialisation is needed. But all in all, kexec based
hibernation can be much simpler on the kernel side.

> and it looks like there's greatly increased pain for users wanting to 
> configure this new implementation. Kexec is by no means proven to be the 
> panacea for all the issues.

Configuration is a problem, we will work on it.

But, because it is based on kexec/kdump instead of starting from
scratch, the duplicated part between hibernation and kexec/kdump can be
eliminated.

Best Regards,
Huang Ying
