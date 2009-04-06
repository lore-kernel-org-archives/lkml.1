Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZDFWyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZDFWyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZDFWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:54:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:13373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZDFWyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:54:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,332,1235980800"; 
   d="scan'208";a="445547478"
Subject: Re: 2.6.29 git master and PAT problems
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <200904020912.23071.a.miskiewicz@gmail.com>
References: <200903302317.04515.a.miskiewicz@gmail.com>
	 <20090331002815.GB10490@linux-os.sc.intel.com>
	 <20090402004933.GE10490@linux-os.sc.intel.com>
	 <200904020912.23071.a.miskiewicz@gmail.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 15:52:33 -0700
Message-Id: <1239058353.4529.7124.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz Miskiewicz wrote:
> On Thursday 02 of April 2009, Pallipadi, Venkatesh wrote:
> > On Mon, Mar 30, 2009 at 05:28:15PM -0700, Pallipadi, Venkatesh wrote:
> > > On Mon, Mar 30, 2009 at 03:31:09PM -0700, Arkadiusz Miskiewicz wrote:
> > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > >
> > > > More info follows. Now I've switched to
> > > > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm
> > > > fixes and now I get much lower numbers of PAT errors but still.
> > > >
> > > > > On Mon, 2009-03-30 at 14:31 -0700, Arkadiusz Miskiewicz wrote:
> > > > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > > > > > Patch here should get rid of these errors.
> > > > > > >
> > > > > > > http://marc.info/?l=linux-kernel&m=123788806506230&w=2
> > > > > > >
> > > > > > > The patch is in tip and on its way to upstream.
> > > > > >
> > > > > > The problem is that kernel I'm running already contains this patch
> > > > > > (it's merged already). Other ideas?
> > > > > >
> > > > > > ratelimiting that error is good IMO anyway.
> > > > >
> > > > > Rate limiting will just work around the problem here. Ideally we
> > > > > should never see these errors. So, it will be better if we can narrow
> > > > > down on the bug resulting in these error messages.
> > > >
> > > > Of course it's better. I'm saying that when these messages "fire" then
> > > > it's hard to do anything else on the system for a while until these
> > > > stop.
> > > >
> > > > > Can you please send me the output of
> > > > > # cat /debug/x86/pat_memtype_list
> > > > > with debugfs mounted.
> > > > > and
> > > > > # cat /proc/mtrr
> > >
> > > There seems to be two different problems here.
> > > - We should not have that many single page ranges reserved. That will
> > > cause a performance problem with drm even without the "freeing invalid
> > > type" error. - "freeing invalid type" error itself. Seems to be caused
> > > due to some unbalanced free along the drm path. We tried to find anything
> > > obvious in the code that may be causing problem here. But, haven't found
> > > anything so far. Will try to reproduce the problem internally and debug
> > > it further.
> >
> > OK. I think we have root caused the thinko that was resulting in
> > "freeing invalid type" error. Can you try the below test
> > patch. Patch is not final version and may need some cleanup.
> 
> Was testing on linus git as of today +
> [PATCH] x86, PAT: Remove duplicate memtype reserve in pci mmap
> + patch from this thread.
> 
> It doesn't fix the problem. At least I'm able to reproduce "Freeint invalid
> memtype" by just running http://www.tremulous.net/ game. It also happened when
> watching youtube with opera. _Maybe_ things are little better because number
> of "freeing invalid memtype" messages is much lower than before but there is
> posibility that I simply didn't trigger it fully.

Arkadiusz,

I was finally able to reproduce the problem of "freeing invalid memtype"
with upstream git kernel (commit 0221c81b1b) + latest xf86 intel driver.
But, with upstream + the patch I had sent you earlier in this thread
(http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I don't see
those freeing invalid memtype errors anymore.

Can you please double check with current git and that patch and let me
know if you are still seeing the problem.

Thanks,
Venki 


