Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYBIQEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYBIQEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYBIQDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:03:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50070 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYBIQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:03:50 -0500
Date: Sat, 9 Feb 2008 17:39:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@suse.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] CPA: Split static_protections into required_static_prot and advised_static_prot
Message-ID: <20080209163904.GA24548@one.firstfloor.org>
References: <20080208536.837219990@suse.de> <20080208163612.D76421B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091525400.3145@apollo.tec.linutronix.de> <20080209151322.GB6773@basil.nowhere.org> <alpine.LFD.1.00.0802091639200.3145@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802091639200.3145@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 04:50:14PM +0100, Thomas Gleixner wrote:
> On Sat, 9 Feb 2008, Andi Kleen wrote:
> > On Sat, Feb 09, 2008 at 03:56:02PM +0100, Thomas Gleixner wrote:
> > > On Fri, 8 Feb 2008, Andi Kleen wrote:
> > > > There is a big difference between NX and RO. NX absolutely has to be cleared
> > > > or the kernel will fail while RO just can be set, but does not need to.
> > > > And for a large page area not setting NX if there is a area below 
> > > > it that needs it is essential, while making it ro is optional again.
> > 
> > Optional as in it doesn't need to be forced.
> > 
> > > 
> > > No, it's not optional. Making the PMD RO will write protect all 4k
> > > PTEs below independent of their setting. So there is the same
> > > restriction as we have with NX.
> > 
> > If there is a boundary between a RO area
> > and a RW area and you want to map it with 2MB pages then NX is required,
> > but RO is optional on the page and if you prefer TLB use minimalization
> > over debugging it is optional. Is it clear now? 
> 
> No, it is not clear at all. Why is there a requirement for NX, when I

Sorry the requirement is no NX, not NX. I left out the "no"
in the second sentence.

> have an overlapping area of RO and RW in a large page mapping? If I
> want to preserve the large page mapping in such a case, then its
> required to make the mapping RW and omit the protection of the RO
> area, nothing else.

Yes that is what my patch (or rather a followup) patch implements.

> > Note the behaviour for pageattr and thus DEBUG_RODATA / debugging
> > sitations where you don't care about your TLB this
> > does not change, this makes only a difference for the initial init_32
> > direct mapping setup.
> 
> Your patches do change the behaviour. The range checking breaks the
> enforcement of some restrictions for the sake of keeping the large
> page intact.

You mean in try_preserve_large_page()?

No actually they were not completely enforced previously at all, because
it did only check the restrictions of the first page.

On the end of my patch series the enforcement is actually stricter
than it was before, although not 100%.

-Andi

