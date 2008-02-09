Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbYBIRJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbYBIRJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYBIRJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:09:39 -0500
Received: from www.tglx.de ([62.245.132.106]:50756 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYBIRJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:09:38 -0500
Date: Sat, 9 Feb 2008 18:09:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/5] CPA: Split static_protections into required_static_prot
 and advised_static_prot
In-Reply-To: <20080209163904.GA24548@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0802091806220.3145@apollo.tec.linutronix.de>
References: <20080208536.837219990@suse.de> <20080208163612.D76421B41AA@basil.firstfloor.org> <alpine.LFD.1.00.0802091525400.3145@apollo.tec.linutronix.de> <20080209151322.GB6773@basil.nowhere.org> <alpine.LFD.1.00.0802091639200.3145@apollo.tec.linutronix.de>
 <20080209163904.GA24548@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008, Andi Kleen wrote:
> > > Note the behaviour for pageattr and thus DEBUG_RODATA / debugging
> > > sitations where you don't care about your TLB this
> > > does not change, this makes only a difference for the initial init_32
> > > direct mapping setup.
> > 
> > Your patches do change the behaviour. The range checking breaks the
> > enforcement of some restrictions for the sake of keeping the large
> > page intact.
> 
> You mean in try_preserve_large_page()?
> 
> No actually they were not completely enforced previously at all, because
> it did only check the restrictions of the first page.

Right, you poked my nose to it. I did not think about it when I coded
it. It is wrong and needs to be fixed, but not by the range check you
introduced.
 
> On the end of my patch series the enforcement is actually stricter
> than it was before, although not 100%.

As far as I can tell it is more relaxed, as it will make overlapping
regions of rodata and rwdata completely rw instead of splitting it up.

Thanks,
	tglx
