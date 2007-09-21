Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXIUB5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXIUB5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 21:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXIUB5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 21:57:36 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:43679 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbXIUB5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 21:57:35 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 11:57:26 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211120.00448.ncunningham@crca.org.au> <20070920184106.79e1858a.akpm@linux-foundation.org>
In-Reply-To: <20070920184106.79e1858a.akpm@linux-foundation.org>
Organization: Christian Reformed Church of Cobden
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211157.28622.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Friday 21 September 2007 11:41:06 Andrew Morton wrote:
> > On Friday 21 September 2007 11:06:23 Andrew Morton wrote:
> > > On Fri, 21 Sep 2007 10:24:34 +1000 Nigel Cunningham 
> > <nigel@nigel.suspend2.net> wrote:
> > > 
> > > > Hi Andrew.
> > > > 
> > > > On Thursday 20 September 2007 20:09:41 Pavel Machek wrote:
> > > > > Seems like good enough for -mm to me.
> > > > > 
> > > > > 									Pavel
> > > > 
> > > > Andrew, if I recall correctly, you said a while ago that you didn't 
want 
> > > > another hibernation implementation in the vanilla kernel. If you're 
going 
> > to 
> > > > consider merging this kexec code, will you also please consider 
merging 
> > > > TuxOnIce?
> > > > 
> > > 
> > > The theory is that kexec-based hibernation will mainly use preexisting
> > > kexec code and will permit us to delete the existing hibernation
> > > implementation.
> > > 
> > > That's different from replacing it.
> > 
> > TuxOnIce doesn't remove the existing implementation either. It can 
> > transparently replace it, but you can enable/disable that at compile time.
> 
> Right.  So we end up with two implementations in-tree.  Whereas
> kexec-based-hibernation leads us to having zero implementations in-tree.
> 
> See, it's different.

That's not true. Kexec will itself be an implementation, otherwise you'd end 
up with people screaming about no hibernation support. And it won't result in 
the complete removal of the existing hibernation code from the kernel. At the 
very least, it's going to want the kernel being hibernated to have an 
interface by which it can find out which pages need to be saved. I wouldn't 
be surprised if it also ends up with an interface in which the kernel being 
hibernated tells it what bdev/sectors in which to save the image as well 
(otherwise you're going to need a dedicated, otherwise untouched partition 
exclusively for the kexec'd kernel to use), or what network settings to use 
if it wants to try to save the image to a network storage device. On top of 
that, there are all the issues related to device reinitialisation and so on, 
and it looks like there's greatly increased pain for users wanting to 
configure this new implementation. Kexec is by no means proven to be the 
panacea for all the issues.

Regards,

Nigel
-- 
Nigel Cunningham
Pastor
Christian Reformed Church of Cobden
Victoria, Australia
+61 3 5595 1185
