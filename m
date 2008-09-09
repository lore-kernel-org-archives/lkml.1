Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYIIH2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYIIH2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYIIH2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:28:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbYIIH2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:28:10 -0400
Date: Tue, 9 Sep 2008 09:27:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909072751.GA8264@elte.hu>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu> <38118.1220905541@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38118.1220905541@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Mon, 08 Sep 2008 21:02:49 +0200, Ingo Molnar said:
> 
> > ... and so on it goes with this argument. Everyone has a different 
> > target audience and there's no firm limit. Maybe what makes more sense 
> > is to have some sort of time dependency:
> > 
> >   support all x86 CPUs released in the last year
> >   support all x86 CPUs released in the past 5 years
> >   support all x86 CPUs released in the past 10 years
> >   support all x86 CPUs released ever
> >   [ ... or configure a specific model ]
> > 
> > and people/distributions would use _those_ switches. That means we could 
> > continuously tweak those targets, as systems become obsolete and new 
> > CPUs arrive.
> 
> That's just *asking* for flame mail if somebody builds a kernel for a 
> system that's 4 year 9 months old, and he builds a kernel 6 months 
> later, and it fails to boot because the CPU is now 3 months out and 
> we've deprecated it...

yeah, in terms of precision of the definition it's certainly more 
towards the 'vague' end of the spectrum. OTOH, we do change our defaults 
slowly but surely to match the hardware. So this would give a practical 
definition. If someone _does_ complain legitimately, it doesnt cost us 
much to revert a tweak and delay it some more.

So the idea is to have some sort of independent platform, instead of the 
current practice of distros like Debian chosing pretty much random 
options. No strong opinion though. We can cover 90% of the real 
advantages via dynamic methods, it's quite rare that we have to make 
hard .config choices.

Pretty much the only hardcoded aspect that hurts in practice is the 
cache alignment parameter - all the rest is either dynamic already or 
insignificant. Ever since distros have discovered 
CONFIG_CC_OPTIMIZE_FOR_SIZE=y, even the various compiler optimization 
parameters have less of a role. We just have to wait a year or two for 
P4's to not matter that much anymore, then we can do generic kernels 
with 64 byte alignment and cmov, that will just work almost everywhere 
rather optimally.

	Ingo
