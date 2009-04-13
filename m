Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZDMEZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZDMEZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 00:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZDMEZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 00:25:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbZDMEZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 00:25:45 -0400
Date: Mon, 13 Apr 2009 06:24:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090413042459.GA6479@elte.hu>
References: <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com> <alpine.LFD.2.00.0904120754240.4583@localhost.localdomain> <20090412163356.GA2392@elte.hu> <49E2398A.3050405@redhat.com> <20090413041625.GF11652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413041625.GF11652@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > Ingo Molnar wrote:
> >>> Sure, go ahead and wrap them in some kind of "save and restore all  
> >>> registers" wrapping, but nothing fancier than that. It would just be 
> >>> overkill, and likely to break more than it fixes.
> >>>     
> >>
> >> Yeah. I only brought up the virtualization thing as a 
> >> hypothetical: "if" corrupting the main OS ever became a 
> >> widespread problem. Then i made the argument that this is 
> >> unlikely to happen, because Windows will be affected by it just 
> >> as much. (while register state corruptions might go unnoticed 
> >> much more easily, just via the random call-environment clobbering 
> >> of registers by Windows itself.)
> >>
> >> The only case where i could see virtualization to be useful is 
> >> the low memory RAM corruption pattern that some people have 
> >> observed.
> >
> > You could easily check that by checksumming pages (or actually 
> > copying them to high memory) before the call, and verifying after 
> > the call.
> 
> Yes, we could do memory checks, and ... hey, we already do that:
> 
>    bb577f9: x86: add periodic corruption check
>    5394f80: x86: check for and defend against BIOS memory corruption
> 
> ... and i seem to be the one who implemented it! ;-)

s/implemented/merged+fixed :-)

	Ingo
