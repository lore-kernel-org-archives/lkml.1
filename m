Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYBIKh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYBIKh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYBIKhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:37:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYBIKht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:37:49 -0500
Date: Sat, 9 Feb 2008 11:37:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_HIGHPTE vs. sub-page page tables.
Message-ID: <20080209103728.GA29375@elte.hu>
References: <200802081902.m18J2nOm005840@hera.kernel.org> <20080208230433.GA8524@elte.hu> <20080208231506.GA13350@elte.hu> <1202551589.8936.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202551589.8936.1.camel@localhost>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Sat, 2008-02-09 at 00:15 +0100, Ingo Molnar wrote:
> > > config attached. It seems all !PAE 32-bit kernel builds are broken due 
> > > to this. The patch below fixes it.
> > 
> > ok, the patch was against x86.git which had some other changes in 
> > this area - the one below applies to vanilla -git and fixes the bug.
> 
> Thanks Ingo for taking care of it. I already feared that we'll have 
> some more fallout from this patch although it has been in -mm for 
> quite a while. The real testing starts after a patch hit Linus tree.

i think the worst is over already and i'm reasonably sure that there are 
no more bugs in it - this _is_ a 1:1 patch after all, so in theory the 
worst side-effect should be build breakages due to include file 
spaghetti. The window for this particular breakage was just 256 commits, 
that's OK i think.

If you want less stress next time around you might want to consider 
pushing such patches via individual architectures, so that it can all be 
shaken out (and such build bugs are found quickly) and pushed via the 
architecture trees. (Even such a patch that changes the number of 
cross-arch function arguments and introduces a new type can be 
architectured in a way to make it per arch.)

	Ingo
