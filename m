Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYAVOV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYAVOV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYAVOVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:21:50 -0500
Received: from ns2.suse.de ([195.135.220.15]:52332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYAVOVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:21:49 -0500
Date: Tue, 22 Jan 2008 15:21:47 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
Message-ID: <20080122142147.GD19936@wotan.suse.de>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de> <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de> <20080122132355.GA24320@wotan.suse.de> <alpine.LFD.1.00.0801221439520.3199@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801221439520.3199@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 03:06:00PM +0100, Thomas Gleixner wrote:
> On Tue, 22 Jan 2008, Andi Kleen wrote:
> 
> > > First priority is getting CPA and PAT consolidated before we put new
> > 
> > PAT seems to be still quite unstable and frankly for me it is 
> > unclear how long it will take to it become stable. It would
> > not surprise me if it takes longer than the .26 merge window.
> 
> Definitely, if we change the code further without doing anything to
> consolidate it in the first place. 
> 
> Have you even cared to look, why PAT is so ugly and fragile ? Simply

Well I was second generation hacker on the patchkit (after Eric B.) and
wrote quite some code in it, so yes I'm a little familiar with how it works... 

> because it interferes/interacts with CPA and the page table code. So

No that is not its main problem I believe. Main problem are 
all the driver and other subsystem interactions (it is a little
bit similar to power management where you have lots of little
bits all over right instead of a single big one). The actual
page table handling is the smallest issue and well understood
anyways.

gbpages on the other hand does not change the driver interaction
problem at all.

> adding further stuff to that area without considering the requirements
> of PAT will make it worse.

I don't think gbpages has much to do with how well PAT works or not.

It is just a different way to map the large areas of the direct mapping
that do not contain any mmio or aperture mappings. These areas
are not affected by PAT. By definition (in Linux) if PAT is active
for something there are no gbpages anymore.

PAT essentially only works on areas which are already split into
4K and the gbpages code does not come into play on those at all.

> > That seems to me like against your own principles -- simple stuff
> > first -- that you two harped on so extensively on earlier this thread.
> 
> Not at all. If the simple stuff makes it harder to do something else,

I don't think that's the case here.

> 
> If your patches are so simple, then they can be done on top of a
> consolidated CPA/PAT easily.

Sure they can -- i did that in fact with PAT only -- my worry is just that
there is no time frame when someone will actually produce 
working PAT and then consolidated CPA. So basically my relatively
simple (and imho not very intrusive) feature is queued behind two very 
complicated projects with unclear time frame and might
be delayed forever for those.

And the rationales I so far heard for this particular prioritization
were not very convincing to say the least. Frankly I suspect Ingo 
hadn't actually looked at the gbpage code really before coming up with
it and from your comments it doesn't sound like you did either.

> > But now that it is gone again anyways delaying the gbpages for it again
> > would be quite unfortunate from my perspective.
> 
> I can understand that, because it is in the way of your particular
> interests, but we have to look at the global picture and not at the
> personal preferences of you or anyone else.

According to you and Ingo "the global perspective" is to get
simple stuff first in. But in this case you're doing the complicated
(and worse the unfinished) stuff first which seems to be against
your own principles.

-Andi

