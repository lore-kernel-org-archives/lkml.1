Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZIZRoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZIZRoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 13:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZIZRoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 13:44:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbZIZRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 13:44:00 -0400
Date: Sat, 26 Sep 2009 10:43:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Fix hwpoison code related build failure on 32-bit
 NUMAQ
In-Reply-To: <20090926173522.GA22723@elte.hu>
Message-ID: <alpine.LFD.2.01.0909261038510.3303@localhost.localdomain>
References: <20090916125116.GA12751@basil.fritz.box> <20090926141352.GA26117@elte.hu> <20090926151740.GN30185@one.firstfloor.org> <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain> <20090926173522.GA22723@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Sep 2009, Ingo Molnar wrote:
> >  
> > +config X86_SUPPORTS_MEMORY_FAILURE
> > +	bool
> > +	depends on !X86_NUMAQ
> > +	select ARCH_SUPPORTS_MEMORY_FAILURE
> > +	default y
> 
> Thanks Linus, this patch fixed the NUMAQ build problem.

I think it's slightly buggy still.

I think the X86_SUPPORTS_MEMORY_FAILURE thing should also have a

	depends on X86_MCE

line, because we still depend on MCE.

And as you found out, there's also the sparsemem thing.

Don't make it one huge ugly thing, just split out the requirements like

	depends on X86_MCE
	depends on !X86_NUMAQ
	depends on X86_64 || !SPARSEMEM

because I think the requirements are fairly independent, and it makes it 
easier to read (you could even comment each line on why _that_ particular 
issue needs to disable X86_SUPPORTS_MEMORY_FAILURE)

But yeah, with that, and some testing, please add my sign-off (or 
acked-by, if you end up changing the patch so much that it has little to 
do with my original one)

		Linus
