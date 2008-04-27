Return-Path: <linux-kernel-owner+w=401wt.eu-S1764866AbYD0XSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866AbYD0XSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYD0XSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:18:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYD0XSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:18:24 -0400
Date: Mon, 28 Apr 2008 01:18:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080427231809.GA13848@elte.hu>
References: <1209329485.3801.46.camel@localhost.localdomain> <20080427214837.GA11631@elte.hu> <1209333959.3801.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209333959.3801.67.camel@localhost.localdomain>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > with the PAT changes, what used to be this default and careless 
> > ioremap() behavior by x86 turned into a hard cache aliasing 
> > conflict. So we pretty much _have to_ default to uncached - like all 
> > other sane architectures already did forever. This is a direct 
> > consequence of the PAT changes which were discussed on lkml.
> > 
> > But with PAT we take over from the MTRRs on x86 and using a 
> > cacheable ioremap() would give us aliasing conflicts and trouble all 
> > around the place.
> 
> I'm not saying the patch is wrong ... or that just because it broke 
> voyager it shouldn't be done. [...]

ok, but that rather crutial piece of information was not at all clear 
from your mail ... ;-)

> [...] What I'm saying is that it shouldn't have been put into the x86 
> tree without mailing list review.

... but the PAT patchset was all around lkml. The ioremap change was 
trivial, went into v2.6.25 and was discussed on lkml:

  http://lkml.org/lkml/2008/1/25/287

" that's why we changed all ioremaps to default to cache-disabled (PCD)
  in latest x86.git as well. For years the x86 architecture set the
  ioremap pagetable entries to cacheable by default and only the MTRRs
  (and the BIOS writers) saved us from trouble. Now we try to be a bit
  more defensive and avoid "BIOS bug causes only Linux to crash and burn
  while other OSs work fine" type of scenarios. "

i could have included the actual patch in that mail i guess - but this 
was hardly an unreviewed change and you never showed interest in the PAT 
threads on lkml (or much interest in x86 threads for that matter) so 
would it have made any difference in practice?

The commit was mentioned in the pull request to Linus as well, which was 
Cc:-ed to lkml. The commit was upstream about 3 months before you 
noticed that it broke Voyager.

But, we'd not mind at all posting 1000 x86.git patches to lkml (or 
another list) every 3 months (or more frequently), if people request 
that.

	Ingo
