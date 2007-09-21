Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXIUCZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXIUCZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbXIUCZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:25:31 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:52106 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXIUCZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:25:30 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 12:25:24 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, nigel@suspend2.net,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211157.28622.nigel@nigel.suspend2.net> <1190341137.21818.52.camel@caritas-dev.intel.com>
In-Reply-To: <1190341137.21818.52.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211225.25874.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Friday 21 September 2007 12:18:57 Huang, Ying wrote:
> > That's not true. Kexec will itself be an implementation, otherwise you'd 
end 
> > up with people screaming about no hibernation support. And it won't result 
in 
> > the complete removal of the existing hibernation code from the kernel. At 
the 
> > very least, it's going to want the kernel being hibernated to have an 
> > interface by which it can find out which pages need to be saved. I 
wouldn't 
> 
> This has been done by kexec/kdump guys. There is a makedumpfile utility
> and vmcoreinfo kernel mechanism to implement this. We can just reuse the
> work of kexec/kdump.

You've already said that you are currently saving all pages. How are you going 
to avoid saving free pages if you don't get the information from the kernel 
being saved? This will require more than just code reuse.

> > be surprised if it also ends up with an interface in which the kernel 
being 
> > hibernated tells it what bdev/sectors in which to save the image as well 
> > (otherwise you're going to need a dedicated, otherwise untouched partition 
> > exclusively for the kexec'd kernel to use), or what network settings to 
use 
> > if it wants to try to save the image to a network storage device. On top 
of
> 
> These can be done in user space. The image writing will be done in user
> space for kexec base hibernation.

That only complicates things more. Now you need to get the information on 
where to save the image from the kernel being saved, then transfer it to 
userspace after switching to the kexec kernel. That's more kernel code, not 
less.

> > that, there are all the issues related to device reinitialisation and so 
on, 
> 
> Yes. Device reinitialisation is needed. But all in all, kexec based
> hibernation can be much simpler on the kernel side.

Sorry, but I'm yet to be convinced. I'm not unwilling, I'm just not there yet.
 
> > and it looks like there's greatly increased pain for users wanting to 
> > configure this new implementation. Kexec is by no means proven to be the 
> > panacea for all the issues.
> 
> Configuration is a problem, we will work on it.
> 
> But, because it is based on kexec/kdump instead of starting from
> scratch, the duplicated part between hibernation and kexec/kdump can be
> eliminated.

Regards,

Nigel
-- 
Nigel, Michelle and Alisdair Cunningham
5 Mitchell Street
Cobden 3266
Victoria, Australia
