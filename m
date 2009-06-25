Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbZFYHEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbZFYHEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZFYHEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:04:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55340 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbZFYHEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:04:10 -0400
Date: Thu, 25 Jun 2009 09:03:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one
	root bus
Message-ID: <20090625070347.GB2676@elte.hu>
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A42AFAC.6000300@kernel.org> <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain> <alpine.LFD.2.01.0906241615160.18460@localhost.localdomain> <20090624163705.0389c8f0@jbarnes-g45> <alpine.LFD.2.01.0906241645300.3605@localhost.localdomain> <20090624170114.385322df@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624170114.385322df@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > [ There's a difference between "we're supposed to find and fix bugs
> > in the -rc series", and "I release known-buggy -rc1's since we're
> > supposed to fix it later". For similar reasons, I hate pulling
> > known-buggy stuff during the merge window - it's ok if it shows
> > itself to be buggy _later_, but if people send me stuff that they
> > know is buggy as they send it to me, then that's a problem. ]
> 
> Yeah, 100% agreed.  I didn't hear any reports until after people 
> started using your tree, so I think this case was handled 
> correctly: push something that *seems* ok upstream, but with eyes 
> wide open for the possibility we'd need to revert.

There's only one small gripe i have with the handling of it: the 
timing. "9e9f46c: PCI: use ACPI _CRS data by default" was written 
and committed on June 11th, two days _after_ the merge window 
opened.

That's way too late for maybe-broken changes to x86 lowlevel details 
(especially if it touches hw-environmental interaction - which is 
very hard to test with meaningful coverage), and it's also pretty 
much the worst moment to solicit testing from people who are busy 
getting their stuff to Linus and who are busy testing out any of the 
unexpected interactions and bugs.

So this was, to a certain degree, a predictable outcome. Trees in 
the Linux "critical path" of testing (core kernel, x86, core 
networking, very common drivers, PCI, driver core, VFS, etc.) should 
generally try to cool down 1-2 weeks before the merge window - 
because breakage there can do a lot of knock-on cascading damage. 
Two weeks is not a lot of time and the effects of showstopper bugs 
get magnified disproportionately.

	Ingo
