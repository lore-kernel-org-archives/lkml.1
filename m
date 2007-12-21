Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXLUVsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXLUVsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXLUVs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:48:27 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2393 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbXLUVs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:48:26 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Date: Fri, 21 Dec 2007 22:51:45 +0100
User-Agent: KMail/1.9.7
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
References: <20071220.045359.107684960.davem@davemloft.net> <20071220.161726.68534356.davem@davemloft.net> <20071221010653.GA19691@waste.org>
In-Reply-To: <20071221010653.GA19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712212251.46397.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > [  145.128915] TSTATE: 0000004411009603 TPC: 00000000005119ac TNPC: 00000000005119b0 Y: 00000000    Not tainted
> > > [  145.128940] TPC: <kpagecount_read+0x94/0xe0>
> > 
> > My suspicion at this point is that with certain RAM layouts, simply
> > iterating over PFN's is simply not working out.
> 
> That was my original suspicion, which is why I asked Mariusz to
> effectively comment out the actual PFN lookup up-thread. I didn't send
> him a patch to do that, so I guess my instructions on how to hack it
> may have been misunderstood.

No. I just made a trivial mistake :-/ Sorry for confusion. I guess I need to
verify things three times before sending an email next time.
  
> > pfn_to_page() seems to be doing no range checking, and with sparsemem
> > vmemmap, which sparc64 always uses, this can be problematic.
> > 
> > It just blindly goes "vmemmap + pfn" which is asking for trouble, in
> > particular when the physical RAM layout really is sparse.
> > 
> > Maybe it's enough to add a pfn_valid() check here?  If pfn_valid()
> > means there is a vmemmap translation setup for that page struct too,
> > it would work.
> 
> Here's a test patch:

Tested on 2.6.23 and 2.6.24-rc5-mm1. The patch fixes the bug.

Thanks a lot to both of you.

	Mariusz
