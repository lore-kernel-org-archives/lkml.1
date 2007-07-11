Return-Path: <linux-kernel-owner+w=401wt.eu-S934060AbXGKWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060AbXGKWOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764302AbXGKWOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:14:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761799AbXGKWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:14:29 -0400
Date: Wed, 11 Jul 2007 15:12:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <28188.1184190381@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.0.999.0707111510030.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>         
   <20070711211638.GE18767@one.firstfloor.org>
 <28188.1184190381@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Valdis.Kletnieks@vt.edu wrote:
> 
> Odd, I looked at the patchset fairly closely a number of times, as I was
> hand-retrofitting the -rc[1-4] versions onto -rc[1-4]-mm kernels, and it looked
> to *me* like it was a nice set of 20 or so step-by-step changes (bisectable
> and everything - I got to do that once trying to figure out which one I botched).
> Was there something in there that I missed?

The patch-set itself actually looks fine, as far as I'm concerned.

But it does seem to have that "enable everything in one go" problem.

I'd much rather see one time source at a time being converted, and enabled 
then and there, so that when people report problems and do a bisection, if 
it was HPET that broke, you get the commit that changed HPET.

As it is, looking at that set, it *looks* like you'd get the "ok, now 
enable it all" as the commit that breaks, which tells you hardly anything, 
since the commit that _shows_ the behaviour has absolutely nothing to do 
with the code that actually causes it.

But yeah, the patch series per se doesn't look bad. If it wasn't for me 
being burnt by the last big switch-over for timers, I probably wouldn't 
mind it at all, personally.

		Linus
