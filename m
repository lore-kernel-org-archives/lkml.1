Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXIUC7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXIUC7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbXIUC7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:59:07 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:54590 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbXIUC7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:59:05 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 12:58:59 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, nigel@suspend2.net,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211225.25874.nigel@nigel.suspend2.net> <1190342757.21818.75.camel@caritas-dev.intel.com>
In-Reply-To: <1190342757.21818.75.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211259.00195.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Friday 21 September 2007 12:45:57 Huang, Ying wrote:
> On Fri, 2007-09-21 at 12:25 +1000, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Friday 21 September 2007 12:18:57 Huang, Ying wrote:
> > > > That's not true. Kexec will itself be an implementation, otherwise 
you'd 
> > end 
> > > > up with people screaming about no hibernation support. And it won't 
result 
> > in 
> > > > the complete removal of the existing hibernation code from the kernel. 
At 
> > the 
> > > > very least, it's going to want the kernel being hibernated to have an 
> > > > interface by which it can find out which pages need to be saved. I 
> > wouldn't 
> > > 
> > > This has been done by kexec/kdump guys. There is a makedumpfile utility
> > > and vmcoreinfo kernel mechanism to implement this. We can just reuse the
> > > work of kexec/kdump.
> > 
> > You've already said that you are currently saving all pages. How are you 
going 
> > to avoid saving free pages if you don't get the information from the 
kernel 
> > being saved? This will require more than just code reuse.
> 
> I have not tried "makedumpfile". The "makedumpfile" avoids saving free
> pages through checking the "mem_map" of the original kernel. I think
> there is nothing prevent it been used for kexec based hibernation image
> writing.
> 
> This is an example of duplicated effort between kexec/kdump and original
> hibernation implementation. Both kexec/kdump and hibernation need to
> save memory image without saving the free pages. This can be done once
> instead of twice.

Ok.

> > > > be surprised if it also ends up with an interface in which the kernel 
> > being 
> > > > hibernated tells it what bdev/sectors in which to save the image as 
well 
> > > > (otherwise you're going to need a dedicated, otherwise untouched 
partition 
> > > > exclusively for the kexec'd kernel to use), or what network settings 
to 
> > use 
> > > > if it wants to try to save the image to a network storage device. On 
top 
> > of
> > > 
> > > These can be done in user space. The image writing will be done in user
> > > space for kexec base hibernation.
> > 
> > That only complicates things more. Now you need to get the information on 
> > where to save the image from the kernel being saved, then transfer it to 
> > userspace after switching to the kexec kernel. That's more kernel code, 
not 
> > less.
> 
> This is fairly simple in fact. For example, you can specify the
> bdev/sectors in kernel command line when do kexec load "kexec -l <...>
> --append='...'", then the image writing system can get it through
> "cat /proc/cmdline".

Sounds doable, as long as you can cope with long command lines (which 
shouldn't be a biggie). (If you've got a swapfile or parts of a swap 
partition already in use, it can be quite fragmented).

Andrew, you're seeing that it really doesn't mean the removal of all 
hibernation code from the kernel being suspended, aren't you? (And if the 
kexec'd kernel is the same binary, then there's more code again).

Regards,

Nigel
-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
