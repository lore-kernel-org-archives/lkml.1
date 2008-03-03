Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbYCCK6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbYCCK6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761864AbYCCK62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:58:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762430AbYCCK61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:58:27 -0500
Date: Mon, 3 Mar 2008 11:57:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Roskin <proski@gnu.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080303105752.GA23594@elte.hu>
References: <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <1204304352.6767.21.camel@localhost> <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org> <1204305609.21719.16.camel@dv> <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org> <1204313978.2316.8.camel@dv> <20080229211513.GI27212@elte.hu> <1204324265.2316.70.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204324265.2316.70.camel@dv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Roskin <proski@gnu.org> wrote:

> > btw., what are the technical reasons why ndiswrapper cannot be done 
> > in userspace, much like the (wildly successful) FUSE concept?
> 
> ndiswrapper contains essentially two drivers in one - PCI and USB.  
> The PCI driver uses DMA, which should be a strong argument for keeping 
> it in the kernel.

how exactly does it use DMA - how does it allocate the memory it later 
on DMAs into, and how does it typically program that DMA target - is 
there any control over that in the NDIS protocol - or will NDIS drivers 
just write random addresses to the mmio space and then the hardware does 
DMA to/from those addresses? [without the NDIS framework having any 
knowledge about the encoding of those bits?]

on modern hardware it might even be possible to jail an ndiswrapper 
driver to its own pages via the IOMMU.

	Ingo
