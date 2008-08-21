Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYHUVNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYHUVNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYHUVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:13:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:51856 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYHUVNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:13:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,247,1217833200"; 
   d="scan'208";a="36274533"
Date: Thu, 21 Aug 2008 14:13:03 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Ingo Molnar <mingo@elte.hu>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080821211302.GD1152@linux-os.sc.intel.com>
References: <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <87wsibxcdh.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsibxcdh.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 08:42:18PM -0700, Andi Kleen wrote:
> Venki Pallipadi <venkatesh.pallipadi@intel.com> writes:
> >
> > We are also looking at changing the reserve_memtype in PAT, not to use linked
> > list for RAM backed pages and track them in page struct.
> 
> Back when I hacked on this I explicitely chose to not do this because
> it would make it impossible to put any normal anonymous pages into
> the PAT list. While that's not done today there's no reason it couldn't
> be done in the future.

Andi, we are planning to add couple of page flags which will track
the memory attribute of the page. We need to do some checks like,
allow the memory attribute of the page to be changed, only if it is not
mapped any where and not on free lists(like the in the X driver case,
where they allocate the page and then change the attribute). Similarly,
in generic -mm, we need to ensure that the page before it gets added to free
list, has the right memory attribute etc. If the driver is exposing this
page with special attribute, then it is drivers responsibility to
use the same attribute across all the mappings.

Is there a reason why this won't work with anonymous pages? Can you please
elaborate.

> Also it doesn't fix the scalability of the data structure anyways
> (a list is a list),  just saves some memory.

With this, we will track only the reserved regions using the linked list
and typically these reserved regions will be small number (may be huge
contiguous chunks but total number of such chunks will be reasonably smaller).

thanks,
suresh
