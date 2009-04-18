Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbZDRU00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbZDRU00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZDRU0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:26:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37495 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbZDRU0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:26:16 -0400
Date: Sat, 18 Apr 2009 22:25:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] pci: don't assume pref memio are 64bit -v2
Message-ID: <20090418202511.GA30144@elte.hu>
References: <49E992C2.4010707@kernel.org> <49E99303.50004@kernel.org> <20090418200909.GA23229@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090418200909.GA23229@jurassic.park.msu.ru>
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

> On Sat, Apr 18, 2009 at 01:44:51AM -0700, Yinghai Lu wrote:
> > and BIOS set
> > [    0.240007] pci 0000:00:01.0: bridge 64bit mmio pref: [0xbdf00000-0xddefffff]
> 
> An obvious BIOS bug, the bridge base overlaps the physical low RAM 
> (0x00000000-0xc0000000). Technically speaking, this nonsense 
> *happens* to work on Intel hardware, so it seems to be quite 
> common bug nowadays - BIOS writers get lost in ACPI and other 
> "useful" stuff contradicting the PCI specs.

it doesnt matter whether we call it a BIOS bug or not.

> ...
> 
> > +	/* don't allocate too high if the pref mem doesn't support 64bit*/
> > +	if ((res->flags & (IORESOURCE_PREFETCH | PCI_PREF_RANGE_TYPE_64)) ==
> > +	    IORESOURCE_PREFETCH)
> > +		max = 0xffffffff;
> 
> This effectively destroys non-x86 64-bit arches. You've been told about
> that before, so I'm really surprised to see this "patch" once again.
> 
> Categorically NACKed.

You can ridicule the patch and can NAK it (and rightfully so, it's 
wrong), but you seem to miss the simple fact that this solves a very 
real problem.

So consider this patch a documentation and analysis of a real 
problem which made Linux work on hardware where it did not work 
before. That's more valuable than 95% of our commits btw.

> P.S. I recall that I had a patch that addressed the issue, and 
> Ingo made some reasonable comments about it. Will post it 
> tomorrow.

That should have been pursued far more agressively.

Thanks,

	Ingo
