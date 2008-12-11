Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYLKQga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYLKQga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbYLKQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:36:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36662 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbYLKQgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:36:20 -0500
Date: Thu, 11 Dec 2008 17:35:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, Eric Anholt <eric@anholt.net>,
       nix.or.die@googlemail.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211163548.GA11859@elte.hu>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <49407CE1.9090600@googlemail.com> <49407CE1.9090600@googlemail.com> <1228979963.3254.8.camel@gaiman.anholt.net> <200812111707.20857.elendil@planet.nl> <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812110814360.3340@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 11 Dec 2008, Frans Pop wrote:
> 
> > Eric Anholt wrote:
> > > My recommended solution, of course, is to remove vesafb.
> > 
> > How is taking away useful functionality from users a better option than 
> > just fixing the bug?
> 
> Well, just to clarify: it's not a _bug_. It's a benign warnign that two 
> subsystems are trying to map the same memory differently.
> 
> In this case, we have:
> 
> 	resource map sanity check conflict: 0xd0000000 0xdfffffff 0xd0000000 0xd07effff vesafb
> 
> and what it means is that the caller (which is i915_gem_entervt_ioctl) is 
> trying to apparently ioremap the _whole_ graphics card MMIO resource 
> (0xd0000000-0xdfffffff), but the vesafb driver has already registered the 
> fact that it uses _part_ of that resource (0xd0000000-0xd07effff).
> 
> There's no bug there. It's a warning. It's usually a very odd situation 
> when somebody tries to ioremap something that crosses resource reservation 
> boundaries, but the thing is, in this case it's not really a problem.
> 
> It's triggered by a couple of oddities:
> 
>  - fbcon (vesafb) is odd and only requests a partial resource, because it 
>    only uses part of the MMIO window.
> 
>  - the interaction between fbcon and X is odd to begin with, since they 
>    both use the same physical resource.
> 
> so it's a generic warning that triggers because these things 
> _shouldn't_ happen, but it's not actually an error in this case. We 
> could just remove the warning. Or leave it in, in case it finds other 
> (real) issues, and just ignore it.

hm, the warning caught a couple of real bugs already. (one in some cpq 
driver, another was in some networking driver iirc)

	Ingo
