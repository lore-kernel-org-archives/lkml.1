Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYHVCKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYHVCKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYHVCKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:10:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39586 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYHVCKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:10:20 -0400
Date: Fri, 22 Aug 2008 04:12:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080822021221.GD23334@one.firstfloor.org>
References: <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <87wsibxcdh.fsf@basil.nowhere.org> <20080821211302.GD1152@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821211302.GD1152@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi, we are planning to add couple of page flags which will track

page flags are still scarce unfortunately, at least on 32bit.
It's a little better now than it used to be (at some point
they were nearly out before some were reclaimed), but adding a lot 
of flags is still difficult. 

In interest of full disclosure I need at least two for other
work too.

On 64bit adding a lot of new flags is fine, but 64bit only
solutions are not good in this case.

> the memory attribute of the page. We need to do some checks like,
> allow the memory attribute of the page to be changed, only if it is not
> mapped any where and not on free lists(like the in the X driver case,
> where they allocate the page and then change the attribute). Similarly,
> in generic -mm, we need to ensure that the page before it gets added to free
> list, has the right memory attribute etc.

You want to handle that in __free_pages? 

I would have thought that should be handled in some higher level
function which could just check the memattr.

 If the driver is exposing this
> page with special attribute, then it is drivers responsibility to
> use the same attribute across all the mappings.
> 
> Is there a reason why this won't work with anonymous pages? Can you please
> elaborate.

The issue is just if you reuse the two list heads in struct page
because they're already used by the

Adding flags does not conflict here of course.

> > Also it doesn't fix the scalability of the data structure anyways
> > (a list is a list),  just saves some memory.
> 
> With this, we will track only the reserved regions using the linked list
> and typically these reserved regions will be small number (may be huge
> contiguous chunks but total number of such chunks will be reasonably smaller).

Reserved region defined how exactly?

-Andi
