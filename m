Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbZDWMnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbZDWMnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbZDWMnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:43:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59483 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688AbZDWMnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:43:03 -0400
Date: Thu, 23 Apr 2009 14:41:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
Message-ID: <20090423124154.GA1397@elte.hu>
References: <49EA57C4.1000603@kernel.org> <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090423123619.GA11519@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423123619.GA11519@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> > +/* need to insert those two under iomem */
> > +struct resource iomem32_resource = {
> > +	.name	= "PCI mem 32bit",
> > +	.start	= 0,
> > +	.end	= 0xffffffff,
> > +	.flags	= IORESOURCE_MEM,
> > +};
> > +struct resource iomem64_resource = {
> > +	.name	= "PCI mem 64bit",
> > +	.start	= 1ULL<<32,
> > +	.end	= -1,
> > +	.flags	= IORESOURCE_MEM | IORESOURCE_MEM_64,
> > +};
> > +
> 
> This only works on x86 and similar systems with 1:1 CPU address to 
> bus address mapping. There is a lot of machines with multiple 
> 32-bit PCI bus spaces (4G per PCI domain).

If you mean this "only" works on 95% of the systems that test the 
upstream kernel then yes.

Obviously other architectural needs have to be considered too, but 
you are making it sound as if there was some vast, more important 
space to consider that Yinghai did not consider in his foolishness 
;-)

	Ingo
