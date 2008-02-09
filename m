Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYBIPuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYBIPuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYBIPu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:50:27 -0500
Received: from www.tglx.de ([62.245.132.106]:34784 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbYBIPu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:50:26 -0500
Date: Sat, 9 Feb 2008 16:50:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] CPA: Split static_protections into required_static_prot
 and advised_static_prot
In-Reply-To: <20080209151322.GB6773@basil.nowhere.org>
Message-ID: <alpine.LFD.1.00.0802091639200.3145@apollo.tec.linutronix.de>
References: <20080208536.837219990@suse.de> <20080208163612.D76421B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091525400.3145@apollo.tec.linutronix.de> <20080209151322.GB6773@basil.nowhere.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andi Kleen wrote:
> On Sat, Feb 09, 2008 at 03:56:02PM +0100, Thomas Gleixner wrote:
> > On Fri, 8 Feb 2008, Andi Kleen wrote:
> > > There is a big difference between NX and RO. NX absolutely has to be cleared
> > > or the kernel will fail while RO just can be set, but does not need to.
> > > And for a large page area not setting NX if there is a area below 
> > > it that needs it is essential, while making it ro is optional again.
> 
> Optional as in it doesn't need to be forced.
> 
> > 
> > No, it's not optional. Making the PMD RO will write protect all 4k
> > PTEs below independent of their setting. So there is the same
> > restriction as we have with NX.
> 
> If there is a boundary between a RO area
> and a RW area and you want to map it with 2MB pages then NX is required,
> but RO is optional on the page and if you prefer TLB use minimalization
> over debugging it is optional. Is it clear now? 

No, it is not clear at all. Why is there a requirement for NX, when I
have an overlapping area of RO and RW in a large page mapping? If I
want to preserve the large page mapping in such a case, then its
required to make the mapping RW and omit the protection of the RO
area, nothing else.

> Note the behaviour for pageattr and thus DEBUG_RODATA / debugging
> sitations where you don't care about your TLB this
> does not change, this makes only a difference for the initial init_32
> direct mapping setup.

Your patches do change the behaviour. The range checking breaks the
enforcement of some restrictions for the sake of keeping the large
page intact.

Thanks,
	tglx
