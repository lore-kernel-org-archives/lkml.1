Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbZIHXgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbZIHXgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZIHXgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:36:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbZIHXgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:36:09 -0400
Date: Tue, 8 Sep 2009 16:36:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: reinette chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
In-Reply-To: <20090908151135.7ba64801@jbarnes-g45>
Message-ID: <alpine.LFD.2.01.0909081617100.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.r-D.mgBpKB@chimera> <1252427375.14735.130.camel@rc-desk> <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain> <1252431375.14735.139.camel@rc-desk> <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
 <20090908112014.002a35af@jbarnes-g45> <alpine.LFD.2.01.0909081219130.7458@localhost.localdomain> <20090908123151.1f2b18fe@jbarnes-g45> <alpine.LFD.2.01.0909081502510.7458@localhost.localdomain> <20090908151135.7ba64801@jbarnes-g45>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Sep 2009, Jesse Barnes wrote:
> > This regression is almost two months old, and apparently the Intel 
> > graphics people DID ABSOLUTELY NOTHING about it during those two
> > months, because they couldn't be bothered to look at it.
> 
> Yeah sorry, this is the first I've seen of it...  I usually troll the
> regressions lists but I must have missed this one.

Hmm. We must have screwed up something, because this was bisected to the 
intel DRI commits back in July. See

	http://bugzilla.kernel.org/show_bug.cgi?id=13819#c4

and while there was some confusion about exactly which commit caused 
it - probably because the irq thing obviously depends on timing - 
Reinette had a list of three commits that he used to be able to revert to 
get things going:

   drm/i915: Don't update display FIFO watermark on IGDNG
   drm/i915: add FIFO watermark support
   drm/i915: enable error detection & state collection

So Andrew assigned it to DRI, and Rafael has had both Eric and Ma Ling on 
the cc for his regression reports because of the bisection. And that has 
been going on for a long time, I just checked:

    Date: Sun, 26 Jul 2009 22:28:26 +0200 (CEST)
    From: Rafael J. Wysocki <rjw@sisk.pl>
    To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
    Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Eric Anholt <eric@anholt.net>, "ling.ma@intel.com" <ling.ma@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, Ma Ling <ling.ma@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
    Subject: [Bug #13819] system freeze when switching to console

If you didn't see it, then that means that we have screw-ups with the 
bugzilla thing. You're actually listed as a "Reviewed-by" on the commit 
that the fixed-up bisection blamed - And I get the feeling that Rafael's 
bugzilla "bugme" scripts may only pick up "Signed-off-by:" lines.

The point is: this bug has been in bisected in bugzilla for a month and a 
half, and had at least two Intel DRI people cc'd on the weekly reminder 
reports, along with being

	Assigned To:  	drivers_video-dri@kernel-bugs.osdl.org

We have other bugs on the regression list that are even older (no, I'm not 
proud of them):

	http://bugzilla.kernel.org/show_bug.cgi?id=13809
	http://bugzilla.kernel.org/show_bug.cgi?id=13740
	http://bugzilla.kernel.org/show_bug.cgi?id=13733
	http://bugzilla.kernel.org/show_bug.cgi?id=13645

but they aren't bisected and it's not nearly as clear what is going on 
there. The last one in particular I don't know if it even happens any 
more and the first one seems to be fixed in -rc5, or at least the 
reporter couldn't reproduce it any more..

		Linus
