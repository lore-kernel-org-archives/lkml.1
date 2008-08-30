Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYH3TPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYH3TPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 15:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbYH3TP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 15:15:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553AbYH3TP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 15:15:28 -0400
Date: Sat, 30 Aug 2008 12:14:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808301150150.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <alpine.LFD.1.10.0808291434110.3300@nehalem.linux-foundation.org>  <200808300030.32905.rjw@sisk.pl>  <alpine.LFD.1.10.0808301012060.3290@nehalem.linux-foundation.org>
 <86802c440808301107n4561e815ldf53183c92a7bc93@mail.gmail.com> <alpine.LFD.1.10.0808301141590.3290@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Aug 2008, Linus Torvalds wrote:
> 
> We simply shouldn't try to compare the BAR start with randomly chosen 
> things.

Btw, looking at that bogus BAR#3 some more: I don't actually think it's 
even an MCFG resource.

I think it's literally the resource that describes the HT window for the 
host bridge. So it's literally like the "root" resource - all external 
MMIO resources that go over HT have to be in that window.

IOW, I'm starting to think that it's not even broken. It is probably 
perfectly real. It's not a "PCI bridge" in the sense that it doesn't 
bridge one PCI bus to another, but it's a host bridge, and it bridges the 
CPU memory accesses to another bus. 

The fact that the MCFG area happens to be at the start of that window is 
probably just a random detail.

Does anybody know how to find chipset docs for AMD/ATI chipsets? I find 
CPU docs, and the GPU docs, but not the 790 chipset docs anywhere (yeah, 
it looks promising with a link that says "AMD 790FX Chipset 
Specifications", but the link just takes you to some trivial overview, not 
any actual specs.

Anybody?

			Linus
